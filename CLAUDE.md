# APES Investment Research System

## Project Overview
Claude-powered investment research system with **6 agents** (5 daily automated + 1 on-demand interactive) covering three sub-themes within the Energy, AI Power & Supply Chain sector. The system runs autonomously on a local MacBook Air, generates HTML research reports, and emails them to a distribution list of 11 recipients via Resend.

**Three sub-themes tracked:**
- **AI Power Demand** (DC infrastructure, utilities with DC exposure, DC power solutions | tickers: VRT, APLD, IREN, CRWV, D, AEP, PPL, SO, BE | ETFs: XLU)
- **Energy Generation** (nuclear operators/development/fuel, natural gas E&P, oil & gas E&P, renewables & storage | tickers: CEG, VST, TLN, SMR, OKLO, BWXT, CCJ, LEU, EQT, EXE, CTRA, CRK, LNG, AR, RRC, CNX, OXY, DVN, FANG, COP, HES, FSLR, TSLA, GWH | ETFs: URA, XLE)
- **Energy Infrastructure & Supply Chain** (grid construction, grid equipment, midstream | tickers: PWR, ETN, HUBB, GEV, WMB, KMI, ET, DTM, TRGP, OKE | ETFs: GRID)

## Macro Thesis (Current — Iran Conflict Primary)

**Primary lens (April 2026): Iran-US war.** The Strait of Hormuz is closed (Week 5+), Brent at $117, Qatar's LNG infrastructure damaged (17% global supply offline 3-5 years). Ground invasion assessed at 80% probability. The market is underpricing escalation. All 4 daily agents analyze the energy sector through this conflict lens first.

**Secondary lens (structural): U.S. electricity demand supercycle.** AI data center buildout could consume 325–580 TWh by 2028. Hyperscaler capex accelerating toward $600–690B. Multi-decade investment supercycle across nuclear, natural gas, grid infrastructure, storage, and AI-energy convergence.

The Iran conflict drives daily price action; the AI power demand thesis drives long-term positioning.

## Pillar Rankings (Risk-Adjusted)
1. **Oil & LNG Conflict Plays** — #1 near-term (direct conflict beneficiaries, oil supply disruption)
2. **Natural Gas** — #2 (LNG export premium, only scalable answer at speed)
3. **Grid Infrastructure** — #3 most durable (bottleneck and opportunity)
4. **AI-Energy Convergence** — #4 (valuation re-rating underway, rotation pressure)
5. **Storage/Renewables** — #5 (policy cliff under OBBBA)
6. **Nuclear** — #6 (best long-term optionality, worst near-term execution risk)

## Key Monitoring Variables
- **Iran conflict status** — Hormuz status, military developments, diplomatic signals (DAILY)
- **Brent crude price** — #1 conflict indicator (daily)
- **Henry Hub gas price** (CME) — daily
- **Tanker charter rates** (VLCC) — proxy for Hormuz disruption (daily)
- **TTF / JKM** global gas spreads — drives LNG exporter thesis (daily)
- Uranium spot price — daily
- 10Y Treasury yield — daily
- Hyperscaler capex guidance (>20% cut = AI demand thesis weakens materially)
- PJM/ERCOT interconnection queue updates — weekly
- Transformer lead time surveys (Wood Mackenzie) — monthly

## Threshold Alerts (Conflict-Weighted)

**Conflict thresholds (check first):**
- Brent crude >$130/bbl: demand destruction risk, trim oil-long incrementally
- Brent crude <$90/bbl: de-escalation priced in, conflict thesis weakening
- Strait of Hormuz reopens: collapse oil premium, hedge conflict beneficiaries immediately
- Ground invasion confirmed: accelerate oil/LNG/tanker exposure
- Ceasefire announcement: trim conflict beneficiaries, add structural names

**Energy thresholds:**
- Henry Hub sustained >$5/MMBtu: add gas E&P, trim gas-dependent DC plays
- Uranium spot >$120/lb: trim leveraged nuclear restarts
- 10Y Treasury >5.5%: reduce rate-sensitive utility exposure
- Hyperscaler capex cut >20%: reduce AI-energy convergence exposure
- 3+ states pass DC moratoriums: reduce AI-energy convergence
- Transformer lead times <100 weeks: accelerate grid infrastructure

## Agents & Schedule

The system runs **6 agents** total: 5 automated on cron, 1 on-demand.

### Daily Schedule (Pacific Time)

| Time | Agent | Days | Model | Receives Context From |
|------|-------|------|-------|----------------------|
| 6:00 AM | Morning Brief | Mon-Fri | Opus 4.6 (1M) | Yesterday's Trader Agent |
| 7:00 AM | Trader Agent | Every day | Opus 4.6 (1M) | Today's Morning Brief + Latest Post-Market Scorecard |
| 9:30 AM | War Room Alert #1 | Mon-Fri | Sonnet 4.6 | (none — independent intraday check) |
| 11:30 AM | Opportunity Screener | Every day | Opus 4.6 (1M) | Today's Morning Brief + Today's Trader Agent |
| 12:30 PM | War Room Alert #2 | Mon-Fri | Sonnet 4.6 | (none — independent intraday check) |
| 3:30 PM | War Room Alert #3 | Mon-Fri | Sonnet 4.6 | (none — independent intraday check) |
| **5:00 PM** | **Post-Market Pulse** | Mon-Fri | Opus 4.6 (1M) | Today's Morning Brief + Today's Opportunity Screener |
| **5:30 PM** | **Post-Market Scorecard** | Mon-Fri | Opus 4.6 (1M) | **Today's Pulse (primary)** + Morning Brief + Opportunity Screener |
| On-demand | Tutor Agent | Interactive | Opus 4.6 | Curriculum files |

### Agent Descriptions

1. **Morning Brief (6:00 AM)** — Pre-market briefing through the Iran conflict lens.
   - Section 0: TL;DR (4-6 bullets, 30-second read)
   - Section 0.5: Iran Conflict Dashboard (Hormuz status, military action, escalation assessment)
   - Commodity dashboard (Brent first, then WTI, TTF, JKM, Henry Hub, gold, VIX, 10Y)
   - 25-30 web searches (8-10 Iran/military, then energy markets, then watchlist news)
   - Flagged ticker deep-dives with explicit Iran Sensitivity ratings
   - Sub-sector heat map, off-watchlist movers (tankers, defense, gold, cybersecurity)
   - Threshold alerts, action items
   - **Target: 100-170KB report, 15-25 min runtime**

2. **Trader Agent (7:00 AM)** — 8-12 specific call option trade proposals.
   - Reads Morning Brief from 1 hour earlier as primary context
   - **Section A:** Trade of the Day (single highest-conviction idea)
   - **Section B:** Short-term conflict plays (3-4 trades, 1-4 week expiration)
   - **Section C:** Catalyst plays (2-3 trades around earnings/events)
   - **Section D:** LEAPS (2-3 longer-term structural bets, 6-18 months)
   - **Section E:** De-escalation hedges (1-2 puts/shorts on conflict beneficiaries)
   - **Section F:** "What I'm NOT Trading" (3-5 names with reasons why)
   - Default structure: simple calls at tiered strikes (aggressive/base/speculative/LEAPS)
   - Each trade includes 3-scenario P&L: escalation / status quo / ceasefire
   - 30-35 web searches (8-10 Iran/oil intelligence, 12-15 ticker research, 4-5 options market intel)
   - **Target: 130-200KB report, 20-30 min runtime**

3. **War Room Alert (9:30 AM, 12:30 PM, 3:30 PM)** — Lightweight intraday monitoring on Sonnet.
   - 3-5 minute runtime per check
   - 3-4 quick web searches: Iran news last 2-3 hours, oil moves, watchlist movers
   - Quick MMD pull: Brent, WTI, USO, plus any flagged ticker showing big moves
   - **4-5 paragraph alert** sent regardless of trigger (always sends)
   - Trigger conditions monitored: Brent ±3%, flagged ticker ±4%, breaking military news, threshold breach
   - **Target: 4-8KB report, 2-5 min runtime**

4. **Opportunity Screener (11:30 AM)** — 3-pass discovery system for new conflict beneficiaries.
   - Pass 1: 25-30 web searches across conflict-adjacent sectors (tankers, defense, oil services, cybersecurity, gold miners, refining)
   - Pass 2: MMD validation on 20-40 candidates → cut to 8-12 survivors
   - Pass 3: Deep-dive on each survivor (company overview, thesis, financials, technicals, catalyst, entry guidance)
   - Every discovery rated for Iran Sensitivity (HIGH/MED/LOW)
   - Entry guidance with escalation/de-escalation scenario pricing
   - Thesis Killers section
   - Can update `claude_suggested` tickers in flagged-tickers.json
   - **Target: 100-150KB report, 18-25 min runtime**

5. **Post-Market Pulse (5:00 PM)** — Fast end-of-day market recap (NEW — split from old Scorecard).
   - 10-15 minute runtime target
   - ~30 MMD API calls (commodities, sector ETFs, flagged tickers, sub-sector samples)
   - 6-8 web searches (Iran daily recap, market recap, top movers)
   - Output: Iran conflict end-of-day status, commodity dashboard, sector ETFs, sub-sector performance, top 5 gainers/losers, "What Surprised Us," threshold alerts, notes for Scorecard
   - Does NOT score tickers — that's the Scorecard's job
   - **Target: 50-80KB report**

6. **Post-Market Scorecard (5:30 PM)** — Deep conviction scoring on flagged tickers (NEW — focused split).
   - 20-25 minute runtime target
   - Reads today's Pulse as primary foundation (does not duplicate market recap)
   - ~40 MMD API calls (deep data on 12 flagged tickers only — prev + 20-day + 60-day each)
   - 12-15 web searches (per-ticker news, catalyst calendar, after-hours earnings)
   - 4-dimension scoring: Momentum (30%), Sentiment (20%), Valuation (25%), Catalyst Density (25%)
   - Iran Sensitivity rating + De-escalation Risk for every ticker
   - Sub-theme composite rankings
   - **Tomorrow's Setup** — explicit focus list for next morning's Trader Agent
   - Can update `claude_suggested` tickers
   - **Target: 80-120KB report**

7. **Tutor Agent (on-demand)** — Interactive curriculum sessions on energy markets.

## Infrastructure (Current — Local Mac Primary)

**Primary host: MacBook Air (local)**
- **OS:** macOS
- **Auth:** Claude Max 20x ($200/mo plan) via OAuth
- **Sleep prevention:** `caffeinate -s` running as launch agent (`~/Library/LaunchAgents/com.trading.caffeinate.plist`)
- **Permissions:** `/usr/sbin/cron` granted Full Disk Access in System Settings → Privacy & Security
- **Cron jobs:** Mac user crontab (see Schedule above)
- **Runner:** `/Users/anthonyha/Trading/run-agent.sh` (v9)
- **War Room runner:** `/Users/anthonyha/Trading/run-war-room.sh` (v2)
- **MCP servers:** Massive Market Data (paid tier), plus Gmail/Calendar/Chrome/Computer Use available for interactive sessions
- **Logs:** `/Users/anthonyha/Trading/outputs/logs/`
- **Reports:** `/Users/anthonyha/Trading/outputs/reports/`
- **Tmp:** `/Users/anthonyha/Trading/outputs/tmp/` (research files, prompts, raw output)
- **Repo:** `/Users/anthonyha/Trading/` — auto-pulls latest on each agent run
- **Timezone:** Pacific (PDT/PST)

**Backup host: DigitalOcean Droplet (209.38.70.60)**
- Ubuntu 24.04 LTS, SFO3, 1 vCPU, 1GB RAM + 2GB swap
- Cron disabled (kept as warm backup)
- Same Claude Code + MMD MCP setup
- Can be reactivated if Mac fails
- **Cost:** $6/month

## Runner Script v9 — Reliability Features

The `run-agent.sh` script (v9) implements multiple reliability layers:

1. **Lock file** — prevents overlapping runs of the same agent (`outputs/tmp/{agent}.lock`)
2. **30-min Claude timeout** — kills hung Claude processes (background+kill pattern, macOS compatible)
3. **Stdout capture** — Claude's text response IS the deliverable (no Write tool dependency)
4. **Auto-retry** — if first attempt produces <20KB, runs once more
5. **Auth failure detection** — scans output for "Invalid API key" / "please run /login" and replaces with admin alert
6. **Admin-only routing on failure** — failed reports go ONLY to anthonyjoonha@gmail.com (not full distro)
7. **Test mode** — `SEND_TARGET=admin` env var routes successful runs to admin only (for testing)
8. **Git pull retry + recovery** — retries 3 times, then stash + reset --hard if conflicts
9. **Git push retry** — rebases on conflict, pushes again
10. **Min size validation** — `MIN_VALID_SIZE=20000` bytes; below = `[FAILED]` admin alert

## Email Delivery
- **Provider:** Resend API (replaced SendGrid due to throttling)
- **Domain:** `apesdegen.com` — verified with DKIM, SPF, MX, DMARC
- **Sender:** `APES Research <research@apesdegen.com>`
- **Delivery:** Individual sends per recipient (not batched) for instant delivery
- **Free tier limits:** 100 emails/day, 3,000/month (current usage ~75/day, 1,800/month — well under limits)
- **Recipients (11):**
  - anthonyjoonha@gmail.com (admin/reply-to)
  - jsurja@gmail.com
  - kylec578@gmail.com
  - jenningsthomasp@gmail.com
  - fairfaxaidan@gmail.com
  - Bsurja@gmail.com
  - mfcastellanos921@gmail.com
  - swhastan@gmail.com
  - jasperkkw@gmail.com
  - surken00@gmail.com
  - ishantrip@gmail.com

## Configuration Files
All in `/config/`:
- **`watchlist.json`** — master ticker list by sub-theme and sub-sector (~47 tickers)
- **`flagged-tickers.json`** — two-section structure:
  - **`user_flagged` (9 tickers)** — selected by user, NEVER modified by agents: LNG, EQT, STMG, GLNG, VG, ET, USO, XOP, XLE
  - **`claude_suggested` (5 max)** — AI-managed, any agent can add/remove with evidence + catalyst + timeframe
  - Current claude_suggested: FRO (tankers), DVN (Permian E&P), OXY (oil leverage), HAL (oilfield services Q1), GEV (grid Q1)
- **`email-distro.json`** — 11 email recipients
- **`trader-mode.json`** — trader agent mode (discovery/analyst/hybrid), picks, risk tolerance

## Prompt Templates
All in `/prompts/`:

**Daily automated:**
- `morning-brief.md` (~400 lines) — Iran conflict primary lens
- `trader-agent.md` (~600 lines) — 8-12 trades, simple calls at tiered strikes
- `opportunity-screener.md` (~370 lines) — Conflict discovery priority
- `post-market-pulse.md` (~180 lines) — Fast market recap (NEW)
- `post-market-scorecard.md` (~280 lines) — Scoring-only (REWRITTEN, smaller)
- `war-room-alert.md` (~150 lines) — Sonnet intraday checks

**Custom on-demand prompts:**
- `glng-deep-dive.md` — Golar LNG deep-dive analysis template
- `iran-escalation-trades.md` — Iran thesis trade ideas
- `iran-strike-7-ticker-analysis.md` — 7-ticker ranked Iran beneficiary analysis

## Scripts
All in `/scripts/`:
- **`send_email.py`** — Resend API client, supports `--admin-only` flag for testing/failure routing
- **`format_report.py`** — Markdown → styled HTML email converter

## Curriculum Files
All in `/curriculum/`:
- `energy-generation-curriculum.md` — Nuclear, natural gas, oil & gas, renewables learning modules
- `energy-infrastructure-curriculum.md` — Grid, transmission, midstream, AI power demand learning modules

## Key Conventions
- **Source of truth: GitHub.** Edit prompts/configs locally → push → next agent run picks up via `git pull`
- **Agents can auto-update `flagged-tickers.json`** (claude_suggested section only) and push to GitHub
- **User flagged tickers (9):** immutable by agents, always analyzed first
- **Claude suggested tickers (5 max):** managed by agents, each change requires evidence + catalyst + timeframe + `suggested_by` field
- **Trader Agent:** simple calls at tiered strikes (aggressive/base/speculative/LEAPS), 60-70% of trades from flagged tickers
- **Post-Market split:** Pulse (5:00 PM) does fast recap, Scorecard (5:30 PM) does deep scoring — Scorecard reads Pulse as primary context
- **Risk tolerance:** aggressive | **Preferred timeframe:** swing (1-6 months)
- **Reports:** typically 50-200KB HTML, delivered in seconds via Resend
- **MMD API fallback:** if API is down, agents fall back to web-sourced prices (Yahoo Finance, Google Finance)
- **Auth refresh:** Claude Code OAuth tokens expire periodically — when they do, run `claude login` in Terminal manually
- **Mac sleep:** disabled via caffeinate launch agent (survives reboots)
- **All emails include AI-generated research disclaimer**

## Data Sources
- **Massive Market Data API** — paid tier ($29/mo), real-time quotes, fundamentals, options chains, technicals, Greeks
- **Web search** — news, analyst actions, catalyst calendar, EIA/FERC/NRC filings, earnings transcripts
- **Resend API** — email delivery via verified domain apesdegen.com

## Architecture Diagram

```
MacBook Air (PRIMARY — runs 24/7 with caffeinate)
  ├── Cron → run-agent.sh (v9) + run-war-room.sh (v2)
  ├── Claude Code (--print --dangerously-skip-permissions)
  │   ├── Opus 4.6 (1M context) for main agents
  │   └── Sonnet 4.6 for War Room Alert
  ├── MCP: Massive Market Data (cron) + Gmail/Calendar/Chrome (interactive)
  ├── Sleep prevention: ~/Library/LaunchAgents/com.trading.caffeinate.plist
  ├── Cron has Full Disk Access (System Settings → Privacy)
  ├── Git pull ← GitHub (syncs configs/prompts before each run)
  ├── Git push → GitHub (pushes claude_suggested ticker changes)
  ├── stdout capture → research .md file → format_report.py → HTML
  └── Resend API → research@apesdegen.com → 11 recipients

DigitalOcean Droplet 209.38.70.60 (BACKUP — cron disabled)
  ├── Same setup as Mac, ready to reactivate if Mac fails
  └── $6/mo, idle but maintained

GitHub apes-investment-energy (SOURCE OF TRUTH)
  ├── prompts/ (8 templates)
  ├── config/ (4 files)
  ├── scripts/ (2 helpers)
  ├── curriculum/ (2 learning modules)
  └── run-agent.sh + run-war-room.sh
```

## Daily Email Flow Example

```
6:00 AM   MORNING BRIEF runs
          ↓ (saves report, emails distro)
7:00 AM   TRADER AGENT runs
          ↓ (reads Morning Brief context)
9:30 AM   WAR ROOM ALERT #1 (intraday pulse)
11:30 AM  OPPORTUNITY SCREENER runs
          ↓ (reads Morning Brief + Trader Agent)
12:30 PM  WAR ROOM ALERT #2
3:30 PM   WAR ROOM ALERT #3
5:00 PM   POST-MARKET PULSE runs
          ↓ (reads Morning Brief + Opp Screener)
5:30 PM   POST-MARKET SCORECARD runs
          ↓ (reads Pulse as PRIMARY foundation, then MB + OS)
          ↓ (writes "Tomorrow's Setup" → next morning's Trader)
6:00 AM   MORNING BRIEF runs again (next day)
          ↑ (reads yesterday's Trader Agent report)
```

**8 emails per day on weekdays** (Morning Brief, Trader Agent, 3× War Room, Opp Screener, Pulse, Scorecard) × 11 recipients = ~88 sends/day. Well under Resend's 100/day free tier.

## Monthly Cost

| Service | Cost |
|---------|------|
| Claude Max 20x subscription | $200/mo (already paying) |
| Massive Market Data API | $29/mo (paid tier, real-time) |
| DigitalOcean Droplet (backup) | $6/mo |
| Resend email | Free (under 3,000/mo limit) |
| apesdegen.com domain | ~$10/year |
| **Total recurring** | **~$235/mo** |

## Known Limitations & Risks

- **Mac is single point of failure** — if power, wifi, or hardware fails, agents stop running. Droplet exists as backup but requires manual reactivation.
- **Claude auth expires periodically** — must manually run `claude login` when this happens. No automatic refresh. Auth failure detection in runner sends admin alert when this occurs.
- **Concurrent session behavior unclear** — Max 20x supports concurrent sessions per docs but `claude --print --dangerously-skip-permissions` may have edge cases. Avoid using Claude Code interactively during scheduled agent windows (6:00-6:30 AM, 7:00-7:30 AM, 11:30-12:00 PM, 5:00-6:00 PM).
- **No external watchdog** — there's no system that alerts you if reports stop arriving. Reliability depends on noticing missing emails.
- **Weekend reports use Friday's closing data** — markets are closed Saturday/Sunday but agents still run on weekends (Trader Agent, Opportunity Screener).
- **First email from apesdegen.com to a new recipient may land in spam once** — recipients should mark "not spam" once and it's resolved permanently.
- **`--dangerously-skip-permissions`** bypasses all permission checks — necessary for unattended operation but means Claude has full tool access without approval.
- **STMG ticker** — currently in `user_flagged` but MMD has limited data on this ticker. Reports will note "data unavailable" for STMG until verified.

## Testing & Debugging

- Run any agent manually with admin-only routing for testing:
  ```
  SEND_TARGET=admin /Users/anthonyha/Trading/run-agent.sh post-market-pulse post-market-pulse.md
  ```
- Check agent logs: `/Users/anthonyha/Trading/outputs/logs/{agent}_{timestamp}.log`
- Check raw output: `/Users/anthonyha/Trading/outputs/tmp/{agent}_{timestamp}_research.md`
- Check rendered HTML: `/Users/anthonyha/Trading/outputs/reports/{agent}_{timestamp}.html`
- Verify auth: `echo "test" | claude --print --dangerously-skip-permissions`
- Check cron is firing: look for `morning-brief_*.log` files at expected times
- Check Resend delivery: https://resend.com/logs (requires Resend dashboard login)
