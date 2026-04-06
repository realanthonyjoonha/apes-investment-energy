#!/bin/bash
# War Room Alert Runner (Sonnet 4.6 — lightweight, fast)
# Only sends email if a trigger condition is met. Silent if nothing happened.

export PATH=$PATH:/usr/local/bin:/opt/homebrew/bin

BASE_DIR=/Users/anthonyha/Desktop/Trading
LOG_DIR=$BASE_DIR/outputs/logs
TMP_DIR=$BASE_DIR/outputs/tmp
mkdir -p $LOG_DIR $TMP_DIR

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M')
TIME_DISPLAY=$(date '+%I:%M %p')
LOG_FILE="$LOG_DIR/war-room_${TIMESTAMP}.log"
RAW_OUTPUT="$TMP_DIR/war-room_${TIMESTAMP}_raw.txt"

echo "[$(date)] Starting War Room Alert check" >> $LOG_FILE

# Pull latest from GitHub
cd $BASE_DIR && git pull >> $LOG_FILE 2>&1

# Build the prompt — read the war-room-alert.md and inject it
PROMPT=$(cat $BASE_DIR/prompts/war-room-alert.md)

echo "[$(date)] Running Sonnet scan..." >> $LOG_FILE

# Run with Sonnet 4.6 — fast, lightweight
cd $BASE_DIR
echo "$PROMPT" | claude --print --dangerously-skip-permissions --model claude-sonnet-4-6 > "$RAW_OUTPUT" 2>> $LOG_FILE

RAW_SIZE=$(wc -c < "$RAW_OUTPUT")
echo "[$(date)] Sonnet output: ${RAW_SIZE} bytes" >> $LOG_FILE

# Check if NO ALERT
if grep -q "NO ALERT" "$RAW_OUTPUT"; then
    echo "[$(date)] No alert triggered. Skipping email." >> $LOG_FILE
    echo "[$(date)] $(grep 'NO ALERT' "$RAW_OUTPUT")" >> $LOG_FILE
    exit 0
fi

# Alert was triggered — extract subject and send
SUBJECT=$(grep "^🚨" "$RAW_OUTPUT" | head -1 | sed 's/^🚨 //')
if [ -z "$SUBJECT" ]; then
    SUBJECT="🚨 War Room Alert — $TIME_DISPLAY PT"
fi

# Convert to HTML
REPORT_FILE="$TMP_DIR/war-room_${TIMESTAMP}.html"
grep -v "^🚨" "$RAW_OUTPUT" | python3 $BASE_DIR/scripts/format_report.py > "$REPORT_FILE"

REPORT_SIZE=$(wc -c < "$REPORT_FILE")
echo "[$(date)] Alert report: ${REPORT_SIZE} bytes" >> $LOG_FILE

# Send email
python3 $BASE_DIR/scripts/send_email.py "$SUBJECT" "$REPORT_FILE" 2>> $LOG_FILE

echo "[$(date)] War Room Alert sent (${REPORT_SIZE} bytes)" >> $LOG_FILE
