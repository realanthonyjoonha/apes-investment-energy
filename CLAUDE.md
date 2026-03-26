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
1. **Morning Brief** — 6 AM, Sonnet 4.6, daily sector briefing + flagged ticker deep-dives
2. **Opportunity Screener** — 12 PM, Sonnet 4.6, discovers NEW tickers not on watchlist
3. **Post-Market Scorecard** — 5 PM, Opus 4.6, recap + conviction scoring (1-10 across Momentum, Sentiment, Valuation, Catalyst Density)
4. **Trader Agent** — 8 PM, Opus 4.6, specific trade proposals with full thesis, risk/reward, options analysis
5. **Tutor Agent** — on-demand interactive, Opus 4.6, works through curriculum files

## Configuration Files
All in `/config/`:
- `watchlist.json` — master ticker list by sub-theme and sub-sector
- `flagged-tickers.json` — tickers getting extra attention (update frequently, keep to 3-5)
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
- `energy-generation-curriculum.md` — Nuclear, natural gas, oil & gas, renewables learning modules
- `energy-infrastructure-curriculum.md` — Grid, transmission, midstream, AI power demand learning modules

## Key Conventions
- Config changes: edit locally, git push, next scheduled run picks up changes
- Flagged tickers: keep to 3-5 at a time to manage output size
- Trader agent: max 5 ideas/day, configurable in trader-mode.json
- Tutor sessions: run during off-peak hours to avoid rate limit conflicts with automated agents
- All automated agent emails include AI-generated research disclaimer
- Risk tolerance: aggressive | Preferred timeframe: swing (1-6 months)

## Data Sources
- Massive Market Data API (quotes, fundamentals, options, technicals)
- Web search (news, analyst actions, catalyst calendar, EIA/FERC/NRC filings)
- Gmail (email delivery for reports)
