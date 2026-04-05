#!/bin/bash
# Investment Research Agent Runner v7 (Mac Edition)
# Two-pass: Claude does research + writes to file, Python converts to HTML, Resend emails

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
RAW_OUTPUT="$TMP_DIR/${AGENT_NAME}_${TIMESTAMP}_raw.txt"
RESEARCH_FILE="$TMP_DIR/${AGENT_NAME}_${TIMESTAMP}_research.md"

echo "[$(date)] Starting $AGENT_NAME" >> $LOG_FILE

# Pull latest from GitHub
cd $BASE_DIR && git pull >> $LOG_FILE 2>&1

# Build context from previous agent reports
CONTEXT=""
get_latest_report() {
    ls -t $REPORT_DIR/$1_${TODAY}*.html 2>/dev/null | head -1
}

case $AGENT_NAME in
    morning-brief)
        # 6 AM: Gets yesterday's Trader Agent report
        PREV=$(ls -t $REPORT_DIR/trader-agent_*.html 2>/dev/null | head -1)
        if [ -n "$PREV" ] && [ -f "$PREV" ] && [ $(wc -c < "$PREV") -gt 2000 ]; then
            CONTEXT="## Context: Last Trader Agent Report
$(head -c 8000 $PREV)"
        fi
        ;;
    trader-agent)
        # 7 AM: Gets today's Morning Brief + yesterday's Post-Market Scorecard
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
        # 11:30 AM: Gets today's Morning Brief + today's Trader Agent
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
    post-market-scorecard)
        # 5 PM: Gets today's Morning Brief + today's Opportunity Screener
        PREV_MB=$(get_latest_report morning-brief)
        PREV_OS=$(get_latest_report opportunity-screener)
        if [ -n "$PREV_MB" ] && [ -f "$PREV_MB" ] && [ $(wc -c < "$PREV_MB") -gt 2000 ]; then
            CONTEXT="## Context: Today's Morning Brief (6 AM)
Compare the Morning Brief's predictions to what actually happened today.
$(head -c 5000 $PREV_MB)"
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
# CALL 1: Research — Claude does all tool calls and writes findings to file
########################################
cat > "$TMP_DIR/prompt_${TIMESTAMP}.txt" << PROMPTEOF
Read prompts/$PROMPT_FILE and execute it fully. Do all web searches, all MMD API calls, all analysis.

$CONTEXT

CRITICAL: When you are done with ALL your research, you MUST write the complete, detailed findings to a file using the Write tool. Write to this exact path:
$RESEARCH_FILE

The file must contain your FULL detailed report — every ticker with complete analysis (company overview, thesis, financials, technicals, catalysts, risks, verdict), pipeline summary, cross-discovery analysis, and gap analysis.

Write in markdown format. Target 5000+ words. Do NOT summarize — write the FULL analysis. This file is the deliverable.

Do NOT use Gmail or email tools. Just do the research and write the findings file.

FALLBACK: If the Massive Market Data API is unavailable or returning errors after 3 retries, fall back to web research for prices (Yahoo Finance, Google Finance) and note "MMD unavailable — prices sourced from web" in the report.
PROMPTEOF

echo "[$(date)] CALL 1: Starting research phase..." >> $LOG_FILE

cd $BASE_DIR
cat "$TMP_DIR/prompt_${TIMESTAMP}.txt" | claude --print --dangerously-skip-permissions > /dev/null 2>> $LOG_FILE

# Check if research file was created
if [ -f "$RESEARCH_FILE" ]; then
    RESEARCH_SIZE=$(wc -c < "$RESEARCH_FILE")
    echo "[$(date)] CALL 1 complete: Research file created (${RESEARCH_SIZE} bytes)" >> $LOG_FILE
else
    echo "[$(date)] CALL 1 FAILED: No research file created. Falling back to raw output." >> $LOG_FILE
    cat "$TMP_DIR/prompt_${TIMESTAMP}.txt" | claude --print --dangerously-skip-permissions > "$RESEARCH_FILE" 2>> $LOG_FILE
    RESEARCH_SIZE=$(wc -c < "$RESEARCH_FILE")
    echo "[$(date)] Fallback captured: ${RESEARCH_SIZE} bytes" >> $LOG_FILE
fi

########################################
# Convert research to styled HTML
########################################
echo "[$(date)] Converting to HTML..." >> $LOG_FILE

# Extract subject from research
SUBJECT=$(grep "^SUBJECT:" "$RESEARCH_FILE" 2>/dev/null | tail -1 | sed 's/^SUBJECT: *//')
if [ -z "$SUBJECT" ]; then
    SUBJECT="$AGENT_NAME Report — $DATE_DISPLAY"
fi

# Remove SUBJECT line and convert to HTML
grep -v "^SUBJECT:" "$RESEARCH_FILE" | python3 $BASE_DIR/scripts/format_report.py > "$REPORT_FILE"

REPORT_SIZE=$(wc -c < "$REPORT_FILE")
echo "[$(date)] Final HTML report: ${REPORT_SIZE} bytes" >> $LOG_FILE

if [ "$REPORT_SIZE" -lt 3000 ]; then
    SUBJECT="[PARTIAL] $SUBJECT"
fi

# Send email via Resend
python3 $BASE_DIR/scripts/send_email.py "$SUBJECT" "$REPORT_FILE" 2>> $LOG_FILE

# Push config changes if any
cd $BASE_DIR
if ! git diff --quiet config/ 2>/dev/null; then
    echo "[$(date)] Config files changed — committing and pushing" >> $LOG_FILE
    git add config/ >> $LOG_FILE 2>&1
    git commit -m "$AGENT_NAME auto-update: config changes — $DATE_DISPLAY" >> $LOG_FILE 2>&1
    git push origin main >> $LOG_FILE 2>&1
fi

echo "[$(date)] Finished $AGENT_NAME — emailed (${REPORT_SIZE} bytes)" >> $LOG_FILE

# Clean up old tmp files (keep last 7 days)
find $TMP_DIR -name "*.txt" -mtime +7 -delete 2>/dev/null
find $TMP_DIR -name "*.md" -mtime +7 -delete 2>/dev/null
