# Iran Enrichment Strike — 7-Ticker Ranked Analysis

## CORE THESIS
The United States will carry out military strikes on Iranian uranium enrichment facilities within the next 1-2 weekends (March 28 – April 6, 2026), representing a MAJOR escalation beyond the current conflict. The Strait of Hormuz is already closed. Iran will retaliate — potentially via missile strikes on Gulf oil infrastructure, cyber attacks on US critical infrastructure, and proxy activation. This is the NEXT LEG that the market has NOT fully priced in.

**The question:** Which of these 7 tickers — each representing a different escalation beneficiary — offers the best risk/reward for a SHORT-TERM swing trade (1-4 weeks) on stock or options, and which have already run too far?

---

## THE 7 TICKERS (One Per Escalation Category)

| # | Ticker | Category | Why This Name |
|---|--------|----------|---------------|
| 1 | **LEU** | Uranium Enrichment | Only US HALEU producer. Iran's enrichment destroyed = global SWU supply shock. $2.7B DOE backing. $2.3B backlog. Palantir AI partnership for enrichment expansion. |
| 2 | **FANG** | Oil E&P (Permian) | Pure-play Permian Basin. 54% oil skew. Hedging via puts at $50-$53 leaves ALL upside open above that. Most leveraged to crude spike to $130+ Brent. |
| 3 | **FRO** | Tanker/Shipping | Frontline — largest independent tanker company. VLCC rates hit all-time high $423,736/day. Up 51% YTD. Direct beneficiary of Hormuz closure + Cape of Good Hope rerouting. |
| 4 | **CRWD** | Cybersecurity | CrowdStrike — Iran has already launched cyber attacks (Handala Hack wiped 200K devices at Stryker, AWS DC attacks in UAE/Bahrain). "The Iran war trade investors are MISSING." Net New ARR +73% YoY. |
| 5 | **RTX** | Defense/Missiles | Raytheon — makes the Tomahawk cruise missiles used in Iran strikes. Pentagon signed deal to increase production 2-4x. $45B emergency defense supplemental approved. Already +22% in March. |
| 6 | **GLNG** | Floating LNG | Golar LNG — FLNG monopoly. Goldman strategic review (sale/merger). $17B EBITDA backlog. Hormuz closure = FLNG demand surge for emergency LNG capacity. |
| 7 | **NEM** | Gold Mining | Newmont — world's largest gold miner. Gold at $5,100-$5,200, forecasts to $6,000-$6,500 on further escalation. Gold "hasn't moved since Iran conflict" — potential laggard catch-up trade. |

---

## PHASE 1: MARKET DATA COLLECTION (Massive Market Data API)

For EACH of the 7 tickers, pull the following data. This is the PRIMARY data source — do NOT skip any ticker.

### 1a. Current Price & Recent Action
```
For each ticker (LEU, FANG, FRO, CRWD, RTX, GLNG, NEM):
  GET /v2/aggs/ticker/{TICKER}/prev → store_as: {ticker}_prev
```
Extract: close, open, high, low, volume, VWAP. Calculate day change %.

### 1b. 30-Day Price History (Pre-Conflict vs. Post-Conflict)
```
For each ticker:
  GET /v2/aggs/ticker/{TICKER}/range/1/day/2026-02-23/2026-03-27 → store_as: {ticker}_30d
```
From this data, compute via SQL (`query_data`):
- **30-day return** (how much has it already run?)
- **Since-conflict return** (use Feb 28 as conflict start — the day US strikes began)
- **Average daily volume** vs. current volume (is volume expanding?)
- **Max drawdown in 30 days** (how much could it pull back on de-escalation?)
- **Intraday volatility** (average daily range as % of close)

### 1c. 6-Month Price History (Longer-Term Trend)
```
For each ticker:
  GET /v2/aggs/ticker/{TICKER}/range/1/day/2025-09-27/2026-03-27 → store_as: {ticker}_6mo
```
From this, compute:
- **6-month return** (total appreciation)
- **Distance from 6-month high** (how close to peak?)
- **Distance from 6-month low** (how far from bottom?)
- **50-day and 200-day moving average** (trend direction)
- **Is the stock extended?** (>20% above 200-day MA = stretched)

### 1d. Relative Performance
Using SQL, compute:
- **Each ticker's 30d return vs. SPY 30d return** = relative strength ratio
- **Rank all 7 tickers by relative strength** (best to worst)
- **Rank all 7 tickers by distance from 6-month high** (closest to peak = most "priced in")

### 1e. Options Data (For Top 3-4 Names Only)
After ranking, for the **top 3-4 names** that look most attractive, pull options data:
```
For each top name, pull ATM and OTM calls for the next monthly expiration + 2-month out:
  GET /v2/aggs/ticker/O:{TICKER}{EXPIRY}C{STRIKE}/prev
```
Compute:
- Premium cost as % of stock price (how expensive is the option?)
- Breakeven at expiration
- Estimated delta (using `bs_delta` apply function)
- Risk/reward at various price targets

**⚠️ RATE LIMIT MANAGEMENT:** Batch API calls 5-6 at a time. Wait 30 seconds between batches. If you hit 429 errors, wait 60 seconds and retry. Do NOT blast all calls at once.

---

## PHASE 2: FUNDAMENTAL & NEWS RESEARCH (Web Search)

For EACH of the 7 tickers, conduct **at minimum 2 targeted web searches** (14+ total). Focus on:

### For each ticker, search for:
1. **"{TICKER} stock analyst rating price target March 2026"** — Is the street bullish or has it already been priced in?
2. **"{TICKER} Iran war catalyst upside risk 2026"** — What is the specific Iran-related driver for this name?

### Additional targeted searches:
3. **"LEU Centrus HALEU production expansion timeline 2026"** — How fast can LEU scale?
4. **"FANG Diamondback hedging strategy oil price upside 2026"** — Confirm the hedge book leaves upside open
5. **"FRO Frontline tanker rate forecast Q2 2026"** — Are rates sustainable or peaking?
6. **"CRWD CrowdStrike Iran cyber threat federal contracts 2026"** — Is Iran cyber creating new federal demand?
7. **"RTX Raytheon Tomahawk production ramp backlog 2026"** — How much is already in the stock?
8. **"GLNG Golar strategic review Goldman Sachs timeline 2026"** — Any update on deal process?
9. **"NEM Newmont gold production costs margins 2026"** — What are margins at current gold prices?
10. **"uranium enrichment global capacity without Iran Russia SWU 2026"** — How tight does the enrichment market get?

---

## PHASE 3: THE OVERVALUATION TEST

This is the CRITICAL phase. For each ticker, answer these questions using the data gathered:

### Overvaluation Scorecard (Score 1-10, where 10 = extremely overvalued)

| Factor | Question | Scoring |
|--------|----------|---------|
| **Run-Up** | How much has the stock already gained since Feb 28 (conflict start)? | >30% = 8-10, 20-30% = 6-7, 10-20% = 4-5, <10% = 1-3 |
| **Distance from High** | How close is the stock to its 6-month or all-time high? | Within 5% = 8-10, 5-15% = 5-7, >15% below = 1-4 |
| **Analyst Target** | Is the stock above or below consensus PT? | Above PT = 8-10, At PT = 5-7, Below PT = 1-4 |
| **Volume Trend** | Is volume declining from the initial surge? | Declining = higher overvaluation risk |
| **Extension from 200-day MA** | How far above the 200-day moving average? | >30% = 8-10, 20-30% = 6-7, 10-20% = 4-5, <10% = 1-3 |

**Overvaluation Score = Average of all 5 factors**
- Score 7-10: OVERVALUED — the Iran move is already priced in. Risk of sharp pullback on any de-escalation.
- Score 4-6: FAIRLY VALUED — some upside remains but risk/reward is balanced.
- Score 1-3: UNDERVALUED — the market has NOT fully priced in the next escalation leg. This is where the opportunity is.

---

## PHASE 4: UPSIDE RANKING & TRADE CONSTRUCTION

### Step 1: Rank All 7 Tickers
Create a final ranking table with these columns:

| Rank | Ticker | Category | Current Price | Since-Conflict Return | Overvaluation Score (1-10) | Remaining Upside to Target | Escalation Sensitivity | FINAL SCORE | Verdict |
|------|--------|----------|---------------|----------------------|---------------------------|---------------------------|----------------------|-------------|---------|

**FINAL SCORE formula:**
- Remaining Upside (30%) — how much further can it go?
- Inverse Overvaluation (30%) — lower overvaluation = better (use 10 minus overvaluation score)
- Escalation Sensitivity (20%) — how directly does a US strike on enrichment facilities benefit this specific name?
- Catalyst Clarity (20%) — how clear and specific is the near-term catalyst?

### Step 2: For the Top 3 Names, Build Specific Trades

For each of the top 3 ranked tickers, provide TWO trade ideas:

**Trade A: Stock Position**
- Entry price (market or limit)
- Stop loss (with rationale — technical level or % based)
- Target 1 (partial profit)
- Target 2 (full exit)
- Position size (% of portfolio, aggressive risk tolerance)
- Holding period (1-4 weeks)
- Risk/reward ratio

**Trade B: Options Play**
- Contract: expiration, strike, call/put
- Entry price (premium)
- Max risk (premium paid)
- Breakeven at expiry
- Target exit (premium target, not held to expiry)
- Scenario analysis: What happens if thesis plays out this weekend? Next weekend? Doesn't play out?
- Greeks at entry (delta, theta — compute via `bs_delta`, `bs_theta`)

### Step 3: Portfolio-Level Analysis
- If you allocate across all top 3 trades, what is the total portfolio exposure?
- What is the correlation between the trades? (Are they all just "oil goes up" or genuinely diversified?)
- What is the max portfolio drawdown if the thesis is WRONG (Iran ceasefire, de-escalation)?
- What is the portfolio gain if the thesis is RIGHT (enrichment strikes + further escalation)?

---

## PHASE 5: DE-ESCALATION HEDGE

The user's thesis is AGGRESSIVE and event-driven. Smart risk management requires addressing the downside:

1. **What happens to each of the 7 tickers if Iran ceasefire is announced this weekend instead?**
   - Estimate the % drawdown for each ticker on a ceasefire announcement
   - Which names have the most downside risk on de-escalation?
   - Which names have a fundamental floor regardless of Iran? (these are the safest)

2. **Suggested hedge:**
   - If you're long the top 3 names, what put or collar would protect the downside?
   - Cost of the hedge vs. the potential upside

---

## OUTPUT FORMAT

Draft the full analysis as an **HTML email** via `gmail_create_draft`. Recipients from `config/email-distro.json`.

**Subject line:** "Iran Escalation Trades — Top 7 Ranked — [Date]"

Structure:
1. **Executive Summary** (3-4 sentences — the thesis, the top pick, the key risk)
2. **Market Data Dashboard** (table: all 7 tickers with price, returns, volume)
3. **Overvaluation Heatmap** (color-coded table showing which are priced in vs. not)
4. **Final Ranking** (1-7, with verdicts)
5. **Top 3 Trade Details** (exact entries, stops, targets, options)
6. **De-Escalation Risk** (what happens if wrong)
7. **Disclaimer**

Be OPINIONATED. The user does not want "it depends." They want: "LEU is the #1 trade because X, and here's exactly how to play it."

---

## IMPORTANT INSTRUCTIONS

1. **The overvaluation analysis is the most important part.** The user explicitly wants to know which names have already run too far. Do NOT recommend buying something that's already up 50% with no remaining upside.
2. **Short-term timeframe:** 1-4 weeks. Do not recommend 6-month holds. This is an EVENT-DRIVEN trade.
3. **Be specific on options:** Exact expiration, exact strike, exact premium. No vague "consider buying calls."
4. **Address the binary risk:** This is a thesis that either happens (strikes this weekend/next) or doesn't. The trade construction must reflect this binary nature.
5. **Use Massive Market Data API as PRIMARY source** for all pricing and technical analysis. Web search is for fundamental/news context only.
6. **Manage rate limits** — batch 5-6 API calls, wait between batches.
