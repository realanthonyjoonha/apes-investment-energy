# Investment Research & Learning System

## Project Overview
Claude-powered investment research system with 5 agents covering two sectors:
- **Defense & Space** (tickers: LMT, RTX, NOC, GD, BA, RKLB, LUNR, ASTS, LDOS, PLTR, LHX, CACI, BAH, AVAV, KTOS, JOBY | ETFs: ITA, XAR, DFEN)
- **AI, Semiconductors & Robotics** (tickers: NVDA, AMD, AVGO, MRVL, TSM, ASML, AMAT, LRCX, ISRG, FANUY, TER, IRBT, MSFT, GOOGL, AMZN, CRM, QCOM, ARM, INTC, MCHP | ETFs: SMH, SOXX, BOTZ)

## Agents
1. **Morning Brief** — 6 AM, Sonnet 4.6, daily sector briefing + flagged ticker deep-dives
2. **Opportunity Screener** — 12 PM, Sonnet 4.6, discovers NEW tickers not on watchlist
3. **Post-Market Scorecard** — 5 PM, Opus 4.6, recap + conviction scoring (1-10 across Momentum, Sentiment, Valuation, Catalyst Density)
4. **Trader Agent** — 8 PM, Opus 4.6, specific trade proposals with full thesis, risk/reward, options analysis
5. **Tutor Agent** — on-demand interactive, Opus 4.6, works through curriculum files

## Configuration Files
All in `/config/`:
- `watchlist.json` — master ticker list by sector/sub-sector
- `flagged-tickers.json` — tickers getting extra attention (update frequently)
- `email-distro.json` — email recipients for automated reports
- `trader-mode.json` — trader agent mode (discovery/analyst/hybrid), picks, risk tolerance

## Prompt Templates
All in `/prompts/`:
- `morning-brief.md` — Morning Brief Agent prompt
- `opportunity-screener.md` — Opportunity Screener Agent prompt
- `post-market-scorecard.md` — Post-Market Scorecard Agent prompt
- `trader-agent.md` — Trader Agent prompt

## Curriculum Files
All in `/curriculum/`:
- `defense-space-curriculum.md` — Defense & Space sector learning modules
- `ai-semi-robotics-curriculum.md` — AI/Semi/Robotics sector learning modules

## Key Conventions
- Config changes: edit locally, git push, next scheduled run picks up changes
- Flagged tickers: keep to 3-5 at a time to manage output size
- Trader agent: max 5 ideas/day, configurable in trader-mode.json
- Tutor sessions: run during off-peak hours to avoid rate limit conflicts with automated agents
- All automated agent emails include AI-generated research disclaimer

## Data Sources
- Massive Market Data API (quotes, fundamentals, options, technicals)
- Web search (news, analyst actions, catalyst calendar)
- Gmail (email delivery for reports)
