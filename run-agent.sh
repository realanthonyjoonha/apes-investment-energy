#!/bin/bash
# Investment Research Agent Runner v8 (Mac Edition)
# Direct stdout capture — no Write tool dependency
# Features: retry on failure, auth-failure detection, size validation

export PATH=$PATH:/usr/local/bin:/opt/homebrew/bin

AGENT_NAME=$1
PROMPT_FILE=$2
BASE_DIR=/Users/anthonyha/Desktop/Trading
LOG_DIR=$BASE_DIR/outputs/logs
REPORT_DIR=$BASE_DIR/outputs/reports
TMP_DIR=$BASE_DIR/outputs/tmp
mkdir -p $LOG_DIR $REPORT_DIR $TMP_DIR

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M')
DATE_DISPLAY=$(date '+%B %d, %Y')
TODAY=$(date '+%Y-%m-%d')
LOG_FILE="$LOG_DIR/${AGENT_NAME}_${TIMESTAMP}.log"
REPORT_FILE="$REPORT_DIR/${AGENT_NAME}_${TIMESTAMP}.html"
RESEARCH_FILE="$TMP_DIR/${AGENT_NAME}_${TIMESTAMP}_research.md"

# Minimum acceptable report size in bytes. Anything smaller is considered a failure.
# Pulse is a smaller agent (10-15 min target) so threshold is lower for it.
if [ "$1" = "post-market-pulse" ] || [ "$1" = "war-room" ]; then
    MIN_VALID_SIZE=10000
else
    MIN_VALID_SIZE=20000
fi

# Max runtime for Claude --print in seconds (45 minutes)
CLAUDE_TIMEOUT=2700

# Who to send to: "all" = full distro, "admin" = anthonyjoonha only
# Set via env var for testing: SEND_TARGET=admin /path/to/run-agent.sh ...
SEND_TARGET="${SEND_TARGET:-all}"

# Lock file to prevent overlapping agent runs
LOCK_FILE="$TMP_DIR/${AGENT_NAME}.lock"
if [ -f "$LOCK_FILE" ]; then
    LOCK_PID=$(cat "$LOCK_FILE" 2>/dev/null)
    if [ -n "$LOCK_PID" ] && kill -0 "$LOCK_PID" 2>/dev/null; then
        echo "[$(date)] $AGENT_NAME already running (PID $LOCK_PID). Aborting." >> $LOG_FILE
        exit 0
    else
        echo "[$(date)] Stale lock file found. Removing." >> $LOG_FILE
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

echo "[$(date)] Starting $AGENT_NAME (v9 — stdout capture + lock + timeout)" >> $LOG_FILE

# Pull latest from GitHub with retry and conflict recovery
pull_attempts=0
max_attempts=3
until git -C $BASE_DIR pull >> $LOG_FILE 2>&1; do
    pull_attempts=$((pull_attempts + 1))
    if [ $pull_attempts -ge $max_attempts ]; then
        echo "[$(date)] git pull failed after $max_attempts attempts — attempting recovery" >> $LOG_FILE
        # Stash any local changes, reset to remote, re-apply
        git -C $BASE_DIR stash >> $LOG_FILE 2>&1
        git -C $BASE_DIR fetch origin >> $LOG_FILE 2>&1
        git -C $BASE_DIR reset --hard origin/main >> $LOG_FILE 2>&1
        break
    fi
    echo "[$(date)] git pull retry $pull_attempts" >> $LOG_FILE
    sleep 2
done

# Build context from previous agent reports
CONTEXT=""
get_latest_report() {
    ls -t $REPORT_DIR/$1_${TODAY}*.html 2>/dev/null | head -1
}

case $AGENT_NAME in
    morning-brief)
        PREV=$(ls -t $REPORT_DIR/trader-agent_*.html 2>/dev/null | head -1)
        if [ -n "$PREV" ] && [ -f "$PREV" ] && [ $(wc -c < "$PREV") -gt 2000 ]; then
            CONTEXT="## Context: Last Trader Agent Report
$(head -c 8000 $PREV)"
        fi
        ;;
    trader-agent)
        PREV_MB=$(get_latest_report morning-brief)
        PREV_PMS=$(ls -t $REPORT_DIR/post-market-scorecard_*.html 2>/dev/null | head -1)
        if [ -n "$PREV_MB" ] && [ -f "$PREV_MB" ] && [ $(wc -c < "$PREV_MB") -gt 2000 ]; then
            CONTEXT="## Context: Today's Morning Brief (6 AM)
Use this for today's market context, news, commodity moves, and flagged ticker updates.
$(head -c 8000 $PREV_MB)"
        fi
        if [ -n "$PREV_PMS" ] && [ -f "$PREV_PMS" ] && [ $(wc -c < "$PREV_PMS") -gt 2000 ]; then
            CONTEXT="$CONTEXT

## Context: Latest Post-Market Scorecard
Use the conviction scores to prioritize which tickers to build trades around. Focus on composite 7+ names.
$(head -c 10000 $PREV_PMS)"
        fi
        ;;
    opportunity-screener)
        PREV_MB=$(get_latest_report morning-brief)
        PREV_TA=$(get_latest_report trader-agent)
        if [ -n "$PREV_MB" ] && [ -f "$PREV_MB" ] && [ $(wc -c < "$PREV_MB") -gt 2000 ]; then
            CONTEXT="## Context: Today's Morning Brief (6 AM)
$(head -c 8000 $PREV_MB)"
        fi
        if [ -n "$PREV_TA" ] && [ -f "$PREV_TA" ] && [ $(wc -c < "$PREV_TA") -gt 2000 ]; then
            CONTEXT="$CONTEXT

## Context: Today's Trader Agent (7 AM)
The Trader Agent already proposed trades on these names. Avoid duplicating discovery on tickers already covered. Focus on finding NEW names.
$(head -c 5000 $PREV_TA)"
        fi
        ;;
    post-market-pulse)
        # 5:00 PM: Reads today's Morning Brief and Opportunity Screener
        PREV_MB=$(get_latest_report morning-brief)
        PREV_OS=$(get_latest_report opportunity-screener)
        if [ -n "$PREV_MB" ] && [ -f "$PREV_MB" ] && [ $(wc -c < "$PREV_MB") -gt 2000 ]; then
            CONTEXT="## Context: Today's Morning Brief (6 AM)
Compare the Morning Brief's predictions to what actually played out today.
$(head -c 5000 $PREV_MB)"
        fi
        if [ -n "$PREV_OS" ] && [ -f "$PREV_OS" ] && [ $(wc -c < "$PREV_OS") -gt 2000 ]; then
            CONTEXT="$CONTEXT

## Context: Today's Opportunity Screener (11:30 AM)
Note any new names the Screener found — mention them in Top Movers if they moved.
$(head -c 5000 $PREV_OS)"
        fi
        ;;
    post-market-scorecard)
        # 5:30 PM: Reads today's Post-Market Pulse (primary) + Morning Brief + Opportunity Screener
        PREV_PULSE=$(get_latest_report post-market-pulse)
        PREV_MB=$(get_latest_report morning-brief)
        PREV_OS=$(get_latest_report opportunity-screener)
        if [ -n "$PREV_PULSE" ] && [ -f "$PREV_PULSE" ] && [ $(wc -c < "$PREV_PULSE") -gt 2000 ]; then
            CONTEXT="## Context: Today's Post-Market Pulse (5:00 PM) — PRIMARY FOUNDATION
This is the market recap you are building on. Do NOT repeat the commodity dashboard, sector performance, or top movers — those are in the Pulse. Your job is to score flagged tickers and produce tomorrow's focus list.
$(head -c 10000 $PREV_PULSE)"
        fi
        if [ -n "$PREV_MB" ] && [ -f "$PREV_MB" ] && [ $(wc -c < "$PREV_MB") -gt 2000 ]; then
            CONTEXT="$CONTEXT

## Context: Today's Morning Brief (6 AM)
Reference only for the escalation assessment and threshold alerts from this morning.
$(head -c 3000 $PREV_MB)"
        fi
        if [ -n "$PREV_OS" ] && [ -f "$PREV_OS" ] && [ $(wc -c < "$PREV_OS") -gt 2000 ]; then
            CONTEXT="$CONTEXT

## Context: Today's Opportunity Screener (11:30 AM)
Score any new discoveries alongside the existing watchlist.
$(head -c 5000 $PREV_OS)"
        fi
        ;;
esac

########################################
# Build the prompt — stdout IS the deliverable
########################################
cat > "$TMP_DIR/prompt_${TIMESTAMP}.txt" << PROMPTEOF
Read prompts/$PROMPT_FILE and execute it fully. Do all web searches, all MMD API calls, all analysis.

$CONTEXT

=== OUTPUT FORMAT — READ CAREFULLY ===

YOUR ENTIRE TEXT RESPONSE IS THE FINAL DELIVERABLE. There is no email step after this. There is no summary step. Whatever you type as your response is what gets sent to the recipients verbatim.

DO NOT:
- Summarize your findings at the end
- Say "Here's what I found" or "The report is above"
- Use the Write tool to save to a file
- Reference attachments or other steps
- Output conversational text like "I've completed my analysis"

DO:
- Write the COMPLETE report as your response text
- Start with a markdown H1 title
- Include every ticker analysis in full detail (company overview, thesis, financials, technicals, catalysts, risks, verdict)
- Include all tables, all scores, all findings
- Target 5000+ words minimum
- End with the literal line: SUBJECT: <your email subject line>

Your response text will be captured verbatim, converted to HTML, and emailed. Treat your response as if you're writing the final research report directly into the email body.

FALLBACK: If the Massive Market Data API is unavailable after 3 retries, fall back to web research for prices (Yahoo Finance, Google Finance) and note "MMD unavailable — prices sourced from web" in the report.
PROMPTEOF

########################################
# Run Claude — capture stdout directly to the research file
########################################
run_claude_attempt() {
    local attempt=$1
    echo "[$(date)] Attempt $attempt: Running Claude (timeout ${CLAUDE_TIMEOUT}s)..." >> $LOG_FILE
    cd $BASE_DIR
    # Background + kill pattern for timeout (macOS doesn't have GNU timeout)
    # CRITICAL: redirect all FDs of background subshells to avoid hanging command substitution
    (cat "$TMP_DIR/prompt_${TIMESTAMP}.txt" | claude --print --dangerously-skip-permissions > "$RESEARCH_FILE" 2>> "$LOG_FILE") </dev/null >/dev/null 2>/dev/null &
    local claude_pid=$!
    (sleep $CLAUDE_TIMEOUT && kill -9 $claude_pid 2>/dev/null && echo "[$(date)] Attempt $attempt: TIMEOUT killed at ${CLAUDE_TIMEOUT}s" >> "$LOG_FILE") </dev/null >/dev/null 2>/dev/null &
    local watcher_pid=$!
    wait $claude_pid 2>/dev/null
    kill $watcher_pid 2>/dev/null
    wait $watcher_pid 2>/dev/null
    local size=$(wc -c < "$RESEARCH_FILE")
    echo "[$(date)] Attempt $attempt: Captured ${size} bytes" >> $LOG_FILE
    echo $size
}

# First attempt
SIZE=$(run_claude_attempt 1)

# Auth-failure detection
if grep -qi "invalid api key\|please run /login\|unauthorized\|authentication" "$RESEARCH_FILE" 2>/dev/null; then
    echo "[$(date)] AUTH FAILURE DETECTED" >> $LOG_FILE
    cat > "$RESEARCH_FILE" << EOF
# ⚠️ AUTH FAILURE — Manual Action Required

The Claude Code auth token on this Mac has expired. The $AGENT_NAME agent could not run.

## To fix:
1. Open Terminal on the Mac (209.38.70.60 or local)
2. Run: \`claude login\`
3. Follow the browser prompt to log in
4. Agents will resume on the next scheduled run

The system detected: "Invalid API key" in the agent output.

SUBJECT: 🚨 AUTH FAILURE — $AGENT_NAME — Run claude login
EOF
    SIZE=$(wc -c < "$RESEARCH_FILE")
fi

# Retry if output is too small (and not an auth failure)
if [ "$SIZE" -lt "$MIN_VALID_SIZE" ] && ! grep -qi "AUTH FAILURE" "$RESEARCH_FILE" 2>/dev/null; then
    echo "[$(date)] Size ${SIZE} < ${MIN_VALID_SIZE} — retrying once" >> $LOG_FILE
    SIZE=$(run_claude_attempt 2)
fi

########################################
# Convert to styled HTML
########################################
echo "[$(date)] Converting to HTML..." >> $LOG_FILE

# Extract subject
SUBJECT=$(grep "^SUBJECT:" "$RESEARCH_FILE" 2>/dev/null | tail -1 | sed 's/^SUBJECT: *//')
if [ -z "$SUBJECT" ]; then
    SUBJECT="$AGENT_NAME Report — $DATE_DISPLAY"
fi

# Remove SUBJECT line and convert
grep -v "^SUBJECT:" "$RESEARCH_FILE" | python3 $BASE_DIR/scripts/format_report.py > "$REPORT_FILE"

REPORT_SIZE=$(wc -c < "$REPORT_FILE")
echo "[$(date)] Final HTML report: ${REPORT_SIZE} bytes" >> $LOG_FILE

# Determine send target: full distro vs admin-only
if [ "$SIZE" -lt "$MIN_VALID_SIZE" ] || grep -qi "AUTH FAILURE" "$RESEARCH_FILE" 2>/dev/null; then
    SUBJECT="🚨 [FAILED] $SUBJECT"
    echo "[$(date)] Report failed validation — sending alert to admin only" >> $LOG_FILE
    python3 $BASE_DIR/scripts/send_email.py --admin-only "$SUBJECT" "$REPORT_FILE" 2>> $LOG_FILE
elif [ "$SEND_TARGET" = "admin" ]; then
    echo "[$(date)] SEND_TARGET=admin — sending to admin only (testing mode)" >> $LOG_FILE
    python3 $BASE_DIR/scripts/send_email.py --admin-only "$SUBJECT" "$REPORT_FILE" 2>> $LOG_FILE
else
    echo "[$(date)] Report validated — sending to full distro" >> $LOG_FILE
    python3 $BASE_DIR/scripts/send_email.py "$SUBJECT" "$REPORT_FILE" 2>> $LOG_FILE
fi

# Push config changes if any
cd $BASE_DIR
if ! git diff --quiet config/ 2>/dev/null; then
    echo "[$(date)] Config files changed — committing" >> $LOG_FILE
    git add config/ >> $LOG_FILE 2>&1
    git commit -m "$AGENT_NAME auto-update: config changes — $DATE_DISPLAY" >> $LOG_FILE 2>&1
    # Push with retry and rebase-on-conflict
    push_attempts=0
    until git push origin main >> $LOG_FILE 2>&1 || [ $push_attempts -ge 3 ]; do
        push_attempts=$((push_attempts + 1))
        echo "[$(date)] git push conflict — attempt $push_attempts rebase" >> $LOG_FILE
        git pull --rebase origin main >> $LOG_FILE 2>&1
        sleep 1
    done
fi

echo "[$(date)] Finished $AGENT_NAME — emailed (${REPORT_SIZE} bytes)" >> $LOG_FILE

# Clean up old tmp files (keep last 7 days)
find $TMP_DIR -name "*.txt" -mtime +7 -delete 2>/dev/null
find $TMP_DIR -name "*.md" -mtime +7 -delete 2>/dev/null
