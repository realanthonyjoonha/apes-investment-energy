# Investment Research & Learning System

## Project Overview
Claude-powered investment research system with 5 agents covering three sub-themes within the Energy, AI Power & Supply Chain sector:
- **AI Power Demand** (DC infrastructure, utilities with DC exposure, DC power solutions | tickers: VRT, APLD, IREN, CRWV, D, AEP, PPL, SO, BE | ETFs: XLU)
- **Energy Generation** (nuclear operators/development/fuel, natural gas E&P, oil & gas E&P, renewables & storage | tickers: CEG, VST, TLN, SMR, OKLO, BWXT, CCJ, LEU, EQT, EXE, CTRA, CRK, LNG, AR, RRC, CNX, OXY, DVN, FANG, COP, HES, FSLR, TSLA, GWH | ETFs: URA, XLE)
- **Energy Infrastructure & Supply Chain** (grid construction, grid equipment, midstream | tickers: PWR, ETN, HUBB, GEV, WMB, KMI, ET, DTM, TRGP, OKE | ETFs: GRID)

## Macro Thesis
The U.S. is entering its most significant electricity demand supercycle since post-WWII electrification. AI data center buildout could consume 325–580 TWh by 2028. Hyperscaler capex is accelerating toward $600–690B in 2026, but the grid cannot deliver power fast enough. This mismatch creates a multi-decade investment supercycle across nuclear, natural gas, grid infrastructure, storage, and AI-energy convergence — with an addressable market exceeding $1.4T through 2030 in U.S. utility capex alone. Compounding this: Middle East geopolitical disruption (Iran conflict) is creating additional tailwinds for U.S. domestic energy producers and LNG exporters.

## Pillar Rankings (Risk-Adjusted)
1. Natural Gas — #1 near-term (only scalable answer at speed)
2. Grid Infrastructure — #2 most durable (bottleneck and opportunity)
3. AI-Energy Convergence — #3 (valuation re-rating underway)
4. Storage/Renewables — #4 (policy cliff under OBBBA)
5. Nuclear — #5 (best long-term optionality, worst near-term execution risk)

## Key Monitoring Variables
- Henry Hub gas price (CME) — daily
- Uranium spot price — daily
- 10Y Treasury yield — daily
- Hyperscaler capex guidance (>20% cut = demand thesis weakens materially)
- PJM/ERCOT interconnection queue updates — weekly
- Transformer lead time surveys (Wood Mackenzie) — monthly

## Threshold Alerts
- Hyperscaler capex cut >20%: reduce AI-energy convergence exposure
- Henry Hub sustained >$5/MMBtu: add gas E&P, trim gas-dependent DC plays
- Uranium spot >$120/lb: trim leveraged nuclear restarts
- 10Y Treasury >5.5%: reduce rate-sensitive utility exposure
- 3+ states pass DC moratoriums: reduce AI-energy convergence
- Transformer lead times <100 weeks: accelerate grid infrastructure

## Agents

### Schedule & Context Chain
Agents run sequentially with context passed forward. Each agent reads the previous agent's report.

| Agent | Time | Days | Receives Context From |
|-------|------|------|-----------------------|
| Morning Brief | 6:00 AM | Mon-Fri | Yesterday's Trader Agent |
| Trader Agent | 7:00 AM | Every day | Today's Morning Brief + Yesterday's Post-Market Scorecard |
| Opportunity Screener | 11:30 AM | Every day | Today's Morning Brief + Today's Trader Agent |
| Post-Market Scorecard | 5:00 PM | Mon-Fri | Today's Morning Brief + Today's Opportunity Screener |
| Tutor | On-demand | Interactive | Curriculum files |

### Agent Descriptions
1. **Morning Brief** — TL;DR executive summary, commodity dashboard, heavy news emphasis, flagged ticker deep-dives, sub-sector performance heat map, off-watchlist movers, "What Changed Since Yesterday," threshold alerts, today's action items
2. **Opportunity Screener** — 3-pass discovery (wide-net → quick screen → deep-dive), supply chain adjacency discovery around flagged tickers, sector rotation awareness, entry level guidance (ideal/aggressive/patient), thesis killers analysis
3. **Post-Market Scorecard** — Sub-sector performance view (not 47-ticker table), flagged ticker deep scoring (3-5 sentences each), conviction scoring (Momentum 30%, Sentiment 20%, Valuation 25%, Catalyst Density 25%), "What Surprised Us" section, new discovery scores, Tomorrow's Setup for Trader Agent
4. **Trader Agent** — Short-term options (1-4 week, earnings/catalyst plays), longer-term LEAPS (3-12 month structural), speculative plays, 60-70% of trades from flagged tickers, 20-25 web searches, IV percentile context, bear case research before every proposal
5. **Tutor Agent** — On-demand interactive, works through curriculum files

## Cloud Infrastructure
- **Host:** DigitalOcean Droplet (209.38.70.60) — Ubuntu 24.04 LTS, SFO3, 1 vCPU, 1GB RAM + 2GB swap
- **Auth:** Claude Max account via OAuth token (no API costs)
- **User:** `trader` (non-root, runs with `--dangerously-skip-permissions`)
- **Runner:** `/home/trader/run-agent.sh` (v6) — two-pass approach: Claude writes research to file via Write tool, Python converts to styled HTML, Resend sends email
- **Logs:** `/home/trader/Trading/outputs/logs/`
- **Reports:** `/home/trader/Trading/outputs/reports/`
- **Tmp:** `/home/trader/Trading/outputs/tmp/` (raw output, research files, prompts)
- **Repo:** Cloned at `/home/trader/Trading/` — auto-pulls latest on each run
- **Timezone:** Pacific (PDT/PST)
- **Cost:** $6/month (free for ~56 more days with DigitalOcean credit)

## Email Delivery
- **Provider:** Resend API (replaced SendGrid due to throttling)
- **Domain:** `apesdegen.com` — verified with DKIM, SPF, MX, DMARC
- **Sender:** `APES Research <research@apesdegen.com>`
- **Delivery:** Individual sends per recipient (not batched) for instant delivery
- **Recipients (9):** anthonyjoonha@gmail.com, jsurja@gmail.com, kylec578@gmail.com, jenningsthomasp@gmail.com, fairfaxaidan@gmail.com, Bsurja@gmail.com, mfcastellanos921@gmail.com, swhastan@gmail.com, jasperkkw@gmail.com

## Configuration Files
All in `/config/`:
- `watchlist.json` — master ticker list by sub-theme and sub-sector (~47 tickers)
- `flagged-tickers.json` — two-section structure:
  - `user_flagged` (7 tickers) — selected by user, NEVER modified by agents: LNG, EQT, STMG, GLNG, VG, ET, USO
  - `claude_suggested` (up to 5 tickers) — AI-managed, any agent can add/remove with evidence + catalyst + timeframe
- `email-distro.json` — email recipients for automated reports (9 recipients)
- `trader-mode.json` — trader agent mode (discovery/analyst/hybrid), picks, risk tolerance

## Prompt Templates
All in `/prompts/`:
- `morning-brief.md` — Morning Brief Agent prompt (~340 lines)
- `trader-agent.md` — Trader Agent prompt (~479 lines)
- `opportunity-screener.md` — Opportunity Screener Agent prompt (~338 lines)
- `post-market-scorecard.md` — Post-Market Scorecard Agent prompt (~508 lines)

## Curriculum Files
All in `/curriculum/`:
- `energy-generation-curriculum.md` — Nuclear, natural gas, oil & gas, renewables learning modules
- `energy-infrastructure-curriculum.md` — Grid, transmission, midstream, AI power demand learning modules

## Key Conventions
- Config changes: edit locally, git push, next scheduled run picks up changes via `git pull`
- Agents can auto-update `flagged-tickers.json` (claude_suggested section only) and push to GitHub
- User flagged tickers (7): immutable by agents, always analyzed first in every report
- Claude suggested tickers (5 max): managed by agents, each change requires evidence + catalyst + timeframe + `suggested_by` field
- Trader agent: short-term + LEAPS split, 60-70% from flagged tickers
- Tutor sessions: run during off-peak hours to avoid rate limit conflicts
- All automated agent emails include AI-generated research disclaimer
- Risk tolerance: aggressive | Preferred timeframe: swing (1-6 months)
- Reports typically 100-150KB HTML, delivered in seconds via Resend
- Runner script uses two-pass approach: Claude writes research to .md file → Python converts to styled HTML → Resend emails individually to each recipient
- If MMD API is unavailable, agents fall back to web-sourced prices (Yahoo Finance, Google Finance)

## Data Sources
- Massive Market Data API — paid tier ($29/mo), real-time quotes, fundamentals, options chains, technicals, Greeks
- Web search — news, analyst actions, catalyst calendar, EIA/FERC/NRC filings, earnings transcripts
- Resend API — email delivery via verified domain apesdegen.com

## Architecture Diagram
```
Local Mac (development & interactive)
  ├── Claude Code (interactive sessions, Tutor, ad-hoc research)
  ├── MCP: Gmail, Calendar, MMD, Chrome, Computer Use
  ├── Git push → GitHub
  └── Dispatch (mobile access for on-the-go research)

DigitalOcean Droplet 209.38.70.60 (automated agents)
  ├── Cron → run-agent.sh (v6)
  ├── Claude Code (--print --dangerously-skip-permissions)
  ├── MCP: Massive Market Data only
  ├── Git pull ← GitHub (syncs configs/prompts before each run)
  ├── Git push → GitHub (pushes claude_suggested ticker changes)
  ├── Write tool → research .md file → format_report.py → HTML
  └── Resend API → research@apesdegen.com → 9 recipients

GitHub (source of truth)
  └── apes-investment-energy repo (configs, prompts, curriculum)
```

## Known Limitations
- Max account supports ONE Claude session at a time — agents must not overlap (35+ min gaps between each)
- `--dangerously-skip-permissions` bypasses all safety checks on the droplet
- MCP tools on droplet are limited to MMD only (no Gmail, Calendar, Chrome)
- Weekend reports use Friday's closing data (markets closed)
- First email from apesdegen.com to a new recipient may land in spam once — mark "not spam" to fix permanently
