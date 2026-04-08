# Hormuz Losers Research Prompt

## Purpose

A deep research agent that identifies, ranks, and analyzes every ticker that has been **negatively impacted** by the US-Iran War and the Strait of Hormuz disruption. This is the inverse of the existing watchlist (which is built around beneficiaries — oil, LNG, tankers, defense, grid). Output is a structured loser-side report that the Trader Agent and Opportunity Screener can chain off when looking for short candidates, hedges, oversold rebound plays, or names to remove from the long book.

This prompt is **research-only**. It does not generate trade ideas, recommendations, strikes, or position guidance. It surfaces facts, mechanism-of-impact, and quantified damage so the user can form their own view.

---

## Inputs

Read before starting:

1. `~/Desktop/Trading/CLAUDE.md` — project context, macro thesis, threshold framework
2. `~/Desktop/Trading/config/watchlist.json` — long-side universe (for cross-reference; the loser universe is mostly NOT on this list)
3. `~/Desktop/Trading/config/flagged-tickers.json` — current high-conviction names
4. The most recent `outputs/reports/morning-brief_*.md` — current state of the conflict (Day count, Hormuz transit volume, latest military events, oil price levels)
5. The most recent `outputs/reports/post-market-scorecard_*.md` — yesterday's market action and "What Surprised Us" section

If any input is missing or unreadable, log the gap clearly in the output and continue with what you have.

---

## Scope: What Counts as a "Hormuz Loser"

A ticker qualifies if it has measurably underperformed since the war began **AND** the underperformance can be traced through a clear causal mechanism to one or more of:

1. **Oil price shock on the cost side** — companies that consume crude or refined products as a major input (airlines, shipping outside of tankers, trucking, chemicals, plastics, paint, packaged goods, fertilizer, asphalt)
2. **Jet fuel and bunker fuel cost** — airlines, marine shipping (non-tanker), cruise lines
3. **Refined product margin compression** — refiners caught between high crude input cost and demand destruction at the pump
4. **Demand destruction from high gasoline prices** — discretionary retail, restaurants, leisure, travel, auto OEMs (demand for new vehicles), used car dealers
5. **Supply chain disruption through Hormuz** — anything dependent on Persian Gulf manufactured exports, petrochemicals, fertilizer (urea, ammonia), aluminum from Bahrain/UAE, or electronics components routed through Jebel Ali
6. **Equity risk-off rotation out of growth/long-duration** — software, unprofitable tech, biotech, SPACs, recent IPOs caught in the broader risk-off shift the conflict triggered
7. **Rate-sensitive sectors hurt by the inflation-driven yield backup** — REITs (especially mortgage REITs), homebuilders, regional banks with duration mismatch
8. **Tourism and travel demand collapse to/from Middle East** — Gulf-exposed hotel chains, cruise operators with Red Sea / Persian Gulf itineraries, MENA-exposed travel platforms
9. **Insurance and reinsurance** — names with concentrated marine, aviation war risk, or Gulf energy facility exposure
10. **EM exposure** — funds, ETFs, and operating companies with concentrated Iran/Iraq/Lebanon/Yemen revenue or assets, plus broader EM ETFs that faced outflows
11. **Currency and import-cost sensitivity** — countries and companies whose cost base inflated as the dollar strengthened in the safe-haven trade (Turkish lira, Indian rupee, Egyptian pound exposure)
12. **Renewables hurt by the carbon-pragmatist policy shift** — solar, wind, battery storage names that have lagged as policy attention rotates back to traditional energy security

Out of scope: anything that is up YTD, anything where the impact is purely speculative without measurable price action, anything where the connection requires more than one analytical hop.

---

## Phase 1 — Universe Construction

Build the candidate loser universe through three complementary sweeps. Target ~80-120 candidates pre-filter, narrowing to the 30-40 with the strongest causal link.

### Sweep A: Sector-by-sector top-down

For each impact category above, run targeted web searches:

- "[sector] stocks down YTD 2026 oil prices"
- "[sector] underperformance Iran war Hormuz"
- "airlines Q1 2026 jet fuel guidance cut"
- "refiner crack spread compression April 2026"
- "homebuilder rate sensitivity 10Y yield 2026"
- "REIT underperformance 2026 yield curve"
- "MENA tourism 2026 cancellations"
- "marine insurance war risk premium spike 2026"
- "EM equity outflows 2026 dollar strength Iran"
- "solar stocks lagging 2026 OBBBA Iran"
- "fertilizer urea Persian Gulf supply 2026"
- "petrochemical Asia margin Hormuz 2026"

Collect every ticker mentioned. Note source, impact mechanism, and any quantified damage.

### Sweep B: Bottom-up performance screen via MMD

Use the Massive Market Data MCP to identify worst performers in candidate universes:

- `/v2/snapshot/locale/us/markets/stocks/gainers` and `/losers` — daily worst performers
- For each loser-candidate sector ETF (XAL airlines, JETS, ITB homebuilders, XHB, IYR REITs, REM mortgage REITs, KRE regional banks, IBB biotech, XLY consumer discretionary, XRT retail, XLB materials, MOO ag, TAN solar, ICLN clean energy, EEM emerging markets, EWZ Brazil, EWW Mexico, TUR Turkey, INDA India), pull prev bar + 5-day + 30-day + YTD performance and rank constituents
- Cross-reference against the war start date (approximately late February 2026, Day 1 of the conflict) to isolate war-attributable underperformance vs. pre-existing weakness

For each candidate that survives the screen, pull:
- Previous day OHLCV
- 30-day daily bars
- YTD return
- Relative performance vs SPY YTD and vs sector ETF YTD
- Current RSI(14), 20-day SMA, 50-day SMA, 200-day SMA, MACD
- Short interest if available
- Options chain front-month IV and skew if liquid

### Sweep C: Existing watchlist cross-check

For every ticker on `watchlist.json`, check if any are actually underperforming relative to their sub-sector. A long-side watchlist name that has lagged is itself a finding worth surfacing — it may indicate a thesis gap or a stealth loser hiding in plain sight.

---

## Phase 2 — Causal Validation

For each candidate that survives the performance filter, validate the causal link with a minimum of 2 independent sources. Reject candidates where the underperformance has a stronger non-Hormuz explanation (e.g. company-specific scandal, idiosyncratic earnings miss, sector-wide weakness predating the war).

Required for each name:

1. **Mechanism** — one-paragraph explanation of how Hormuz / oil shock / risk-off translates to this specific company's earnings, cost structure, or multiple
2. **Quantified damage** — specific data points: e.g. "United Airlines cut Q2 2026 fuel cost guidance higher by $X per gallon, implying $Y in incremental Q2 fuel expense" or "Toll Brothers cancellations rose to X% in March vs Y% in January"
3. **Timeline anchor** — when did the stock peak relative to the war start? When did the deterioration accelerate?
4. **Sources** — minimum 2 reputable sources (company filings, earnings call transcripts, sell-side notes, Reuters/Bloomberg/WSJ, sector trade publications)

---

## Phase 3 — Ranking and Categorization

Group survivors into four buckets:

### Bucket 1: Direct Cost-Side Losers
Companies where the oil/jet fuel/bunker price spike is hitting the income statement RIGHT NOW. Highest signal-to-noise — the damage is visible in current quarter guidance.

### Bucket 2: Demand Destruction Losers
Companies where the second-order effect (consumer pullback from high gas prices, discretionary spending compression) is the mechanism. Slower to show up in numbers but broader sector impact.

### Bucket 3: Risk-Off Multiple Compression
Long-duration / unprofitable / high-multiple names that lost multiple as yields backed up and risk appetite collapsed. The earnings haven't necessarily deteriorated — the multiple has.

### Bucket 4: Supply Chain & Geographic Exposure
Companies with direct Persian Gulf or MENA operations, manufacturing routed through Jebel Ali, marine insurance exposure, or regional revenue concentration.

For each bucket, sort by the magnitude of YTD underperformance vs SPY. Top 10 per bucket.

---

## Phase 4 — Output Structure

Produce a single markdown report titled `Hormuz Losers Research — [Date]`. Sections:

### Section 0: Executive Summary
- Total candidates screened, total surviving validation
- The 5 most damaged names overall (across all buckets) with one-sentence mechanism each
- The most surprising finding (a sector or company the user wouldn't have expected to be on this list)
- A note on which buckets are most exposed to thesis reversal (i.e. if a ceasefire is announced tomorrow, which names rebound hardest?)

### Section 1: Conflict Backdrop
Pull from the latest morning brief — Day count, Hormuz transit % of normal, current Brent/WTI, jet fuel spot, bunker fuel spot, 10Y yield, VIX. One paragraph of context.

### Section 2: Sector Impact Heat Map
A table showing each loser-side sector ETF, its YTD performance, and a one-line summary of the dominant mechanism.

### Section 3-6: The Four Buckets
For each bucket, the top 10 names. For each name include:
- Ticker, company name, market cap
- YTD return, return since war start date, return relative to SPY
- Current price, 30-day high, 30-day low, RSI, distance from 200-day SMA
- Mechanism paragraph
- Quantified damage with specific data points
- Upcoming catalysts (earnings date, sell-side events, regulatory dates)
- Sources

### Section 7: Watchlist Cross-Check
Any existing `watchlist.json` names that are underperforming their sub-sector. Flag for user review.

### Section 8: Reversal Risk Analysis
If the conflict de-escalates (ceasefire, Hormuz reopening, Brent back below $90), which names in the loser universe rebound hardest? Rank top 10. This is the "ceasefire long basket" research output — facts only, no recommendation.

### Section 9: Thesis Killers
Macro scenarios that would invalidate the loser-side framework:
- Oil drops back to $70 on demand destruction or recession fears
- Hyperscaler capex cut would shift the loser map dramatically
- A new conflict zone (Taiwan, Korea) that draws the safe-haven bid away from US dollar
- Domestic policy shift (SPR release, gasoline tax holiday)

### Section 10: Research Gaps & Data Quality Notes
Anything you couldn't verify, any candidates you had to exclude due to data unavailability, any sectors where MMD coverage was thin.

---

## Constraints and Guardrails

- **Research only.** No recommendations, no trade ideas, no strike selection, no position sizing, no buy/sell language. Use neutral framing throughout: "has underperformed" not "is a short," "rebound candidate" not "long candidate."
- **Quantified or it doesn't go in the report.** Every claim needs a number or a primary source. No vibes.
- **At least 25 distinct web searches.** Cite source URLs in each name's research.
- **At least 40 distinct MMD API calls.** Show your data work.
- **No reused content from morning-brief or scorecard.** This is a different angle on the same conflict.
- **Cap report at 8000 words.** Quality over volume.
- **Save to `outputs/reports/hormuz-losers_[YYYY-MM-DD]_[HH-MM].md`.**
- **Do NOT email it to the distro.** Create a Gmail draft to anthonyjoonha@gmail.com only with the full report as the body.

---

## Success Criteria

A successful run produces a report where:

1. Every name in every bucket has a clear, defensible causal link to Hormuz disruption (not just "stock is down")
2. The mechanism analysis is specific enough that the user could explain it to someone else in two sentences
3. The reversal-risk section identifies non-obvious rebound candidates the user hasn't been thinking about
4. The watchlist cross-check surfaces at least one name on the existing long book that's quietly underperforming
5. The data is timestamped and reproducible from MMD pulls
