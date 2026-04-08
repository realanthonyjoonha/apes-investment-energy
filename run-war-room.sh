#!/bin/bash
# War Room Alert Runner v2 (Mac Edition)
# Sonnet 4.6 — lightweight intraday pulse check
# Features: auth failure detection, size validation, admin-only failure routing, retry

export PATH=$PATH:/usr/local/bin:/opt/homebrew/bin:$HOME/.local/bin

BASE_DIR=/Users/anthonyha/Trading
LOG_DIR=$BASE_DIR/outputs/logs
TMP_DIR=$BASE_DIR/outputs/tmp
mkdir -p $LOG_DIR $TMP_DIR

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M')
TIME_DISPLAY=$(date '+%I:%M %p')
LOG_FILE="$LOG_DIR/war-room_${TIMESTAMP}.log"
RAW_OUTPUT="$TMP_DIR/war-room_${TIMESTAMP}_raw.txt"

# Minimum acceptable output size. War room alerts should be at least 500 bytes (4-5 paragraphs)
MIN_VALID_SIZE=500

# Who to send to: "all" = full distro, "admin" = anthonyjoonha only
# Set to "admin" during testing
SEND_TARGET="${SEND_TARGET:-all}"

echo "[$(date)] Starting War Room Alert check (v2)" >> $LOG_FILE

# Pull latest from GitHub with retry
pull_attempts=0
until git -C $BASE_DIR pull >> $LOG_FILE 2>&1 || [ $pull_attempts -ge 3 ]; do
    pull_attempts=$((pull_attempts + 1))
    echo "[$(date)] git pull retry $pull_attempts" >> $LOG_FILE
    sleep 2
done

# Build the prompt — tell Sonnet to read and execute the file, not just look at it
PROMPT="Read prompts/war-room-alert.md and execute it fully right now. Do all required web searches and MMD API calls. Your entire text response is the final deliverable — the runner script will capture stdout, convert to HTML, and email it. If no triggers, output 'NO ALERT' per the prompt instructions. If triggered, output the 4-5 paragraph alert. Do not output anything else — no preamble, no meta-commentary, no questions back to the user. Start your response with the report content or NO ALERT."

echo "[$(date)] Running Sonnet scan..." >> $LOG_FILE

# Run Sonnet with 10-minute timeout (background + kill pattern)
# CRITICAL: redirect all FDs of background subshells to /dev/null to prevent hangs
cd $BASE_DIR
CLAUDE_TIMEOUT=600
(echo "$PROMPT" | claude --print --dangerously-skip-permissions --model claude-sonnet-4-6 > "$RAW_OUTPUT" 2>> "$LOG_FILE") </dev/null >/dev/null 2>/dev/null &
CLAUDE_PID=$!
( sleep $CLAUDE_TIMEOUT && kill -9 $CLAUDE_PID 2>/dev/null && echo "[$(date)] TIMEOUT after ${CLAUDE_TIMEOUT}s — killed" >> "$LOG_FILE" ) </dev/null >/dev/null 2>/dev/null &
WATCHER_PID=$!
wait $CLAUDE_PID 2>/dev/null
kill $WATCHER_PID 2>/dev/null
wait $WATCHER_PID 2>/dev/null

RAW_SIZE=$(wc -c < "$RAW_OUTPUT")
echo "[$(date)] Sonnet output: ${RAW_SIZE} bytes" >> $LOG_FILE

# Auth-failure detection
if grep -qi "invalid api key\|please run /login\|unauthorized" "$RAW_OUTPUT" 2>/dev/null; then
    echo "[$(date)] AUTH FAILURE DETECTED" >> $LOG_FILE
    cat > "$RAW_OUTPUT" << EOF
# 🚨 AUTH FAILURE — War Room Alert

The Claude Code auth token on this Mac has expired. War Room Alert could not run.

**To fix:** Open Terminal and run \`claude login\`

Time: $TIME_DISPLAY PT
EOF
    SUBJECT="🚨 AUTH FAILURE — War Room — Run claude login"
    IS_FAILURE=1
# Size validation
elif [ "$RAW_SIZE" -lt "$MIN_VALID_SIZE" ]; then
    echo "[$(date)] Output too small (${RAW_SIZE} bytes < ${MIN_VALID_SIZE}) — treating as failure" >> $LOG_FILE
    SUBJECT="🚨 [FAILED] War Room — $TIME_DISPLAY PT — Output too small"
    IS_FAILURE=1
# Valid output — determine alert vs all-clear
elif grep -q "NO ALERT" "$RAW_OUTPUT"; then
    echo "[$(date)] No alert triggered — sending all-clear" >> $LOG_FILE
    SUBJECT="✅ War Room — $TIME_DISPLAY PT — All Clear"
    IS_FAILURE=0
else
    # Alert triggered — extract the custom subject from the 🚨 line
    EXTRACTED=$(grep "^🚨" "$RAW_OUTPUT" | head -1 | sed 's/^🚨 //')
    if [ -n "$EXTRACTED" ]; then
        SUBJECT="🚨 $EXTRACTED"
    else
        SUBJECT="🚨 War Room Alert — $TIME_DISPLAY PT"
    fi
    IS_FAILURE=0
fi

# Convert to HTML
REPORT_FILE="$TMP_DIR/war-room_${TIMESTAMP}.html"
grep -v "^🚨" "$RAW_OUTPUT" | python3 $BASE_DIR/scripts/format_report.py > "$REPORT_FILE"

REPORT_SIZE=$(wc -c < "$REPORT_FILE")
echo "[$(date)] Alert report: ${REPORT_SIZE} bytes" >> $LOG_FILE

# Send email — failures go admin-only, everything else goes to war-room-distro (4 recipients)
if [ "$IS_FAILURE" = "1" ] || [ "$SEND_TARGET" = "admin" ]; then
    echo "[$(date)] Sending admin-only" >> $LOG_FILE
    python3 $BASE_DIR/scripts/send_email.py --admin-only "$SUBJECT" "$REPORT_FILE" 2>> $LOG_FILE
else
    echo "[$(date)] Sending to war-room-distro (4 recipients)" >> $LOG_FILE
    python3 $BASE_DIR/scripts/send_email.py --distro war-room-distro.json "$SUBJECT" "$REPORT_FILE" 2>> $LOG_FILE
fi

echo "[$(date)] War Room complete (${REPORT_SIZE} bytes)" >> $LOG_FILE
