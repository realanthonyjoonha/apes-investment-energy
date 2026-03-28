#!/usr/bin/env python3
"""
Claude-Powered Investment Research Agent Runner

This script replaces Claude Code for running research agents in GitHub Actions.
It reads a prompt template, sends it to the Claude API with tool definitions,
and handles the multi-turn tool-use loop until the agent completes its work.

Usage:
    python run_agent.py --agent morning-brief
    python run_agent.py --agent opportunity-screener
    python run_agent.py --agent post-market-scorecard
    python run_agent.py --agent trader-agent

Environment Variables Required:
    ANTHROPIC_API_KEY  - Claude API key
    MMD_API_KEY        - Massive Market Data (Polygon) API key
    GMAIL_TOKEN        - Gmail OAuth2 token JSON
    GMAIL_CREDENTIALS  - Gmail OAuth2 credentials JSON (optional for refresh)
    GOOGLE_SEARCH_API_KEY - Google Custom Search API key (optional)
    GOOGLE_SEARCH_CX     - Google Custom Search engine ID (optional)
"""

import os
import sys
import json
import argparse
import time
from datetime import datetime, timedelta

import anthropic
from tools import TOOL_DEFINITIONS, dispatch_tool


# ============================================================
# AGENT CONFIGURATION
# ============================================================

AGENTS = {
    "morning-brief": {
        "prompt_file": "morning-brief.md",
        "model": "claude-sonnet-4-20250514",
        "max_tokens": 16000,
        "max_turns": 80,       # Morning brief needs many API calls
        "description": "Morning Brief Agent — Daily sector briefing"
    },
    "opportunity-screener": {
        "prompt_file": "opportunity-screener.md",
        "model": "claude-sonnet-4-20250514",
        "max_tokens": 16000,
        "max_turns": 100,      # 3-pass discovery = lots of tool calls
        "description": "Opportunity Screener — 3-pass discovery system"
    },
    "post-market-scorecard": {
        "prompt_file": "post-market-scorecard.md",
        "model": "claude-opus-4-20250514",
        "max_tokens": 16000,
        "max_turns": 120,      # 47 tickers × 2 calls + analysis
        "description": "Post-Market Scorecard — Recap + conviction scoring"
    },
    "trader-agent": {
        "prompt_file": "trader-agent.md",
        "model": "claude-opus-4-20250514",
        "max_tokens": 16000,
        "max_turns": 80,
        "description": "Trader Agent — Specific trade proposals"
    }
}


# ============================================================
# SYSTEM PROMPT
# ============================================================

def build_system_prompt(agent_name: str) -> str:
    """Build the system prompt with today's date and context."""
    today = datetime.now().strftime("%Y-%m-%d")
    weekday = datetime.now().strftime("%A")

    return f"""You are a Claude-powered investment research agent running autonomously via GitHub Actions.

Today's date: {today} ({weekday})
Agent: {agent_name}

## Important Context
- You are running in an automated pipeline, NOT in an interactive conversation
- You have access to tools: mmd_call_api, mmd_search_endpoints, mmd_query_data, web_search, send_email, read_config, read_prompt
- The Massive Market Data API uses Polygon-compatible endpoints
- For email, use send_email (this actually SENDS, unlike the draft-only MCP tool)
- Read config files with read_config to get watchlist, flagged tickers, and email recipients
- Rate limits: If you hit 429 errors on MMD, wait and retry. Batch 5-6 calls, then pause.
- Complete ALL phases of your prompt before writing the final output
- The final output MUST be sent via email to all recipients in email-distro.json

## Macro Thesis Context
The U.S. is entering its most significant electricity demand supercycle since post-WWII electrification.
AI data center buildout could consume 325-580 TWh by 2028. Hyperscaler capex accelerating toward $600-690B in 2026.
The grid cannot deliver power fast enough — creating a multi-decade investment supercycle across nuclear, natural gas,
grid infrastructure, storage, and AI-energy convergence. Middle East geopolitical disruption (Iran conflict)
is creating additional tailwinds for U.S. domestic energy producers and LNG exporters.

## Pillar Rankings (Risk-Adjusted)
1. Natural Gas — #1 near-term (only scalable answer at speed)
2. Grid Infrastructure — #2 most durable (bottleneck and opportunity)
3. AI-Energy Convergence — #3 (valuation re-rating underway)
4. Storage/Renewables — #4 (policy cliff under OBBBA)
5. Nuclear — #5 (best long-term optionality, worst near-term execution risk)

## Threshold Alerts
- Hyperscaler capex cut >20%: reduce AI-energy convergence exposure
- Henry Hub sustained >$5/MMBtu: add gas E&P, trim gas-dependent DC plays
- Uranium spot >$120/lb: trim leveraged nuclear restarts
- 10Y Treasury >5.5%: reduce rate-sensitive utility exposure
- 3+ states pass DC moratoriums: reduce AI-energy convergence
- Transformer lead times <100 weeks: accelerate grid infrastructure
"""


# ============================================================
# AGENT RUNNER — THE CORE LOOP
# ============================================================

def run_agent(agent_name: str, dry_run: bool = False):
    """Run a research agent end-to-end with tool use."""

    if agent_name not in AGENTS:
        print(f"ERROR: Unknown agent '{agent_name}'. Available: {list(AGENTS.keys())}")
        sys.exit(1)

    config = AGENTS[agent_name]
    print(f"\n{'='*60}")
    print(f"  {config['description']}")
    print(f"  Model: {config['model']}")
    print(f"  Started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'='*60}\n")

    # Initialize Claude client
    client = anthropic.Anthropic()

    # Read the agent's prompt template
    prompt_path = os.path.join(
        os.path.dirname(os.path.dirname(__file__)), "prompts", config["prompt_file"]
    )
    with open(prompt_path, "r") as f:
        agent_prompt = f.read()

    # Build the conversation
    system_prompt = build_system_prompt(agent_name)
    messages = [
        {
            "role": "user",
            "content": f"Execute your full research pipeline now. Follow every phase in your prompt template completely. Do not skip any data gathering steps.\n\n{agent_prompt}"
        }
    ]

    # Tool-use loop
    turn = 0
    total_input_tokens = 0
    total_output_tokens = 0

    while turn < config["max_turns"]:
        turn += 1
        print(f"\n--- Turn {turn}/{config['max_turns']} ---")

        try:
            response = client.messages.create(
                model=config["model"],
                max_tokens=config["max_tokens"],
                system=system_prompt,
                tools=TOOL_DEFINITIONS,
                messages=messages
            )
        except anthropic.RateLimitError:
            print("Claude API rate limited. Waiting 60 seconds...")
            time.sleep(60)
            continue
        except anthropic.APIError as e:
            print(f"Claude API error: {e}")
            if turn < 3:
                time.sleep(10)
                continue
            else:
                print("Too many API errors. Aborting.")
                sys.exit(1)

        # Track token usage
        total_input_tokens += response.usage.input_tokens
        total_output_tokens += response.usage.output_tokens
        print(f"Tokens this turn: {response.usage.input_tokens} in / {response.usage.output_tokens} out")

        # Check stop reason
        if response.stop_reason == "end_turn":
            # Agent is done — extract final text
            final_text = ""
            for block in response.content:
                if block.type == "text":
                    final_text += block.text

            print(f"\n{'='*60}")
            print(f"  Agent completed!")
            print(f"  Total turns: {turn}")
            print(f"  Total tokens: {total_input_tokens:,} in / {total_output_tokens:,} out")
            print(f"  Estimated cost: ${(total_input_tokens * 0.003 + total_output_tokens * 0.015) / 1000:.2f}")
            print(f"  Finished: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
            print(f"{'='*60}\n")

            if dry_run:
                print("\n[DRY RUN] Final output preview (first 500 chars):")
                print(final_text[:500])

            return final_text

        elif response.stop_reason == "tool_use":
            # Process tool calls
            tool_results = []

            for block in response.content:
                if block.type == "tool_use":
                    tool_name = block.name
                    tool_input = block.input
                    tool_id = block.id

                    print(f"  Tool call: {tool_name}", end="")
                    if tool_name == "mmd_call_api":
                        print(f" → {tool_input.get('path', '?')}", end="")
                    elif tool_name == "web_search":
                        print(f" → \"{tool_input.get('query', '?')[:50]}\"", end="")
                    elif tool_name == "send_email":
                        print(f" → {tool_input.get('subject', '?')[:40]}", end="")
                    print()

                    if dry_run and tool_name == "send_email":
                        result_text = f"[DRY RUN] Email would be sent to: {tool_input.get('to')}"
                        print(f"    {result_text}")
                    else:
                        result_text = dispatch_tool(tool_name, tool_input)

                    # Truncate very long results to manage context window
                    if len(result_text) > 8000:
                        result_text = result_text[:8000] + "\n\n... [truncated for context management]"

                    tool_results.append({
                        "type": "tool_result",
                        "tool_use_id": tool_id,
                        "content": result_text
                    })

            # Add assistant response and tool results to conversation
            messages.append({"role": "assistant", "content": response.content})
            messages.append({"role": "user", "content": tool_results})

        else:
            print(f"Unexpected stop reason: {response.stop_reason}")
            break

    print(f"\nWARNING: Agent hit max turns ({config['max_turns']}). Output may be incomplete.")
    return None


# ============================================================
# ENTRY POINT
# ============================================================

def main():
    parser = argparse.ArgumentParser(description="Run a Claude-powered investment research agent")
    parser.add_argument(
        "--agent",
        required=True,
        choices=list(AGENTS.keys()),
        help="Which agent to run"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Run without sending emails (preview mode)"
    )
    args = parser.parse_args()

    # Validate required environment variables
    required_vars = ["ANTHROPIC_API_KEY", "MMD_API_KEY"]
    missing = [v for v in required_vars if not os.environ.get(v)]
    if missing:
        print(f"ERROR: Missing required environment variables: {', '.join(missing)}")
        print("\nRequired variables:")
        print("  ANTHROPIC_API_KEY  - Your Anthropic API key")
        print("  MMD_API_KEY        - Your Massive Market Data (Polygon) API key")
        print("\nOptional variables:")
        print("  GMAIL_TOKEN        - Gmail OAuth2 token JSON (for sending emails)")
        print("  GMAIL_CREDENTIALS  - Gmail OAuth2 credentials JSON")
        print("  GOOGLE_SEARCH_API_KEY - Google Custom Search API key")
        print("  GOOGLE_SEARCH_CX     - Google Custom Search engine ID")
        sys.exit(1)

    # Check Gmail setup
    if not os.environ.get("GMAIL_TOKEN"):
        print("WARNING: GMAIL_TOKEN not set. Emails will fail. Agent will still run for research.")

    run_agent(args.agent, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
