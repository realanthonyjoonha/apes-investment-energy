# GitHub Actions Setup Guide

## Overview
This system runs 4 investment research agents automatically on GitHub's servers using GitHub Actions. Your laptop can be off — everything runs in the cloud.

## Schedule (Pacific Time, Weekdays Only)
| Agent | Time | Cron (UTC) |
|-------|------|-----------|
| Morning Brief | 6:00 AM | `0 13 * * 1-5` |
| Opportunity Screener | 12:00 PM | `0 19 * * 1-5` |
| Post-Market Scorecard | 5:00 PM | `0 0 * * 2-6` |
| Trader Agent | 8:00 PM | `0 3 * * 2-6` |

## Setup Steps

### Step 1: Add GitHub Secrets
Go to: **GitHub Repo → Settings → Secrets and variables → Actions → New repository secret**

Add these secrets:

| Secret Name | Required | Description |
|-------------|----------|-------------|
| `ANTHROPIC_API_KEY` | ✅ Yes | Your Anthropic API key (starts with `sk-ant-`) |
| `MMD_API_KEY` | ✅ Yes | Your Massive Market Data / Polygon API key |
| `GMAIL_TOKEN` | ✅ Yes | Gmail OAuth2 token JSON (see Step 2) |
| `GMAIL_CREDENTIALS` | Optional | Gmail OAuth2 credentials JSON (for token refresh) |
| `GOOGLE_SEARCH_API_KEY` | Optional | Google Custom Search API key (improves web search) |
| `GOOGLE_SEARCH_CX` | Optional | Google Custom Search engine ID |

### Step 2: Set Up Gmail Sending

The agents need to SEND emails (not just create drafts). This requires Gmail OAuth2:

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create or select a project
3. Enable the **Gmail API** (APIs & Services → Library → search "Gmail API")
4. Go to **APIs & Services → Credentials → Create Credentials → OAuth 2.0 Client ID**
5. Application type: **Desktop App**
6. Download the credentials JSON file
7. Run the setup script locally:

```bash
cd ~/Desktop/Trading
pip install -r scripts/requirements.txt
python scripts/setup_gmail_oauth.py --credentials path/to/downloaded_credentials.json
```

8. The script opens your browser — log in with `anthonyjoonha@gmail.com`
9. Copy the output token JSON
10. Add it as the `GMAIL_TOKEN` secret in GitHub

### Step 3: (Optional) Set Up Google Custom Search

For better web search results:

1. Go to [Programmable Search Engine](https://programmablesearchengine.google.com)
2. Create a search engine that searches the entire web
3. Copy the **Search Engine ID** → add as `GOOGLE_SEARCH_CX` secret
4. Go to [Google Cloud Console](https://console.cloud.google.com) → APIs & Services → Credentials
5. Create an API key → add as `GOOGLE_SEARCH_API_KEY` secret

Without this, the agents use DuckDuckGo's instant answer API as fallback (less comprehensive).

### Step 4: Verify Workflows Are Enabled

1. Go to your GitHub repo → **Actions** tab
2. You should see 4 workflows listed
3. If they say "This workflow was disabled" click **Enable workflow** for each
4. To test immediately: Click a workflow → **Run workflow** → **Run workflow** button

### Step 5: Monitor

- Each workflow run appears in the **Actions** tab
- Click any run to see logs (tool calls, token usage, costs)
- Failed runs show error details
- GitHub sends email notifications for failed workflows by default

## Manual Trigger

You can manually run any agent anytime from the Actions tab:
1. Go to **Actions** → select the workflow
2. Click **Run workflow** (top right)
3. Click the green **Run workflow** button

## Cost Estimates

| Agent | Model | Est. Input Tokens | Est. Output Tokens | Est. Cost/Run |
|-------|-------|-------------------|--------------------|--------------:|
| Morning Brief | Sonnet | ~50K | ~8K | ~$0.27 |
| Opportunity Screener | Sonnet | ~80K | ~12K | ~$0.42 |
| Post-Market Scorecard | Opus | ~100K | ~15K | ~$1.73 |
| Trader Agent | Opus | ~80K | ~12K | ~$1.42 |
| **Daily Total** | | | | **~$3.84** |
| **Monthly (22 trading days)** | | | | **~$84** |

*Costs are estimates and vary based on actual tool usage and output length.*

## Troubleshooting

### Workflow not running on schedule?
- GitHub Actions cron can be delayed by up to 15 minutes
- Workflows only run on the default branch (main)
- Check Actions tab → the workflow should show "Scheduled" runs

### Rate limit errors from MMD?
- The scripts include retry logic with exponential backoff
- If persistent, increase the `timeout-minutes` in the workflow file

### Gmail token expired?
- Re-run `setup_gmail_oauth.py` locally and update the GMAIL_TOKEN secret

### Want to change the schedule?
- Edit the `cron` line in `.github/workflows/{agent}.yml`
- Use [crontab.guru](https://crontab.guru) to build cron expressions
- Remember: GitHub Actions cron uses UTC time

## Updating Configs

To change the watchlist, flagged tickers, email recipients, or trader settings:
1. Edit the files in `config/` locally
2. `git commit` and `git push`
3. Next scheduled run picks up the changes automatically
