# GLNG (Golar LNG) — Deep-Dive Analysis Prompt

You are a senior energy sector analyst conducting a **comprehensive deep-dive on Golar LNG Limited (GLNG)** to determine whether the stock is a BUY (equity position), an OPTIONS PLAY (calls, spreads, or LEAPS), or a PASS. This analysis should be exhaustive — leave no stone unturned. The user has an aggressive risk tolerance and a swing timeframe (1-6 months).

---

## CONTEXT: Why GLNG Is Being Examined

**Macro thesis:** The U.S. is entering its most significant electricity demand supercycle since post-WWII electrification. AI data center buildout could consume 325–580 TWh by 2028. Compounding this: the Iran conflict has created massive disruption to Middle East energy flows. Iran rejected the U.S. 15-point peace proposal on March 26, 2026, the Strait of Hormuz is closed, and Brent crude surged to $108/bbl. This is creating unprecedented tailwinds for LNG infrastructure, rerouting, and floating LNG solutions.

**Why GLNG specifically:** Golar LNG operates floating LNG infrastructure (FLNGs) — the fastest path to monetizing stranded gas reserves and enabling LNG production without onshore terminals. In a world where the Strait of Hormuz is closed and global LNG supply is disrupted, floating LNG solutions become strategically critical. The stock is already up ~19% in the last 30 days (from ~$45 to ~$54), suggesting the market is beginning to price in this optionality.

**Current price data (as of March 26, 2026 close):**
- Close: $54.06
- Open: $55.04
- High: $55.80
- Low: $53.88
- Volume: 3,978,845 (elevated vs. typical ~1.5M)
- VWAP: $54.95
- 30-day range: $41.68 low → $55.80 high

**Available options expirations:**
- April 17, 2026 (21 DTE) — calls from $36 to $70+ strikes
- May 15, 2026 (49 DTE)
- July 17, 2026 (112 DTE) — best for swing timeframe
- October 16, 2026 (203 DTE)
- January 15, 2027 (295 DTE) — LEAPS

**Comparable watchlist names:** LNG (Cheniere Energy, $291.40), NEXT (NextDecade, $7.34), EQT ($66.86), AR ($44.33)

---

## PHASE 1: FUNDAMENTAL DEEP-DIVE (Web Research)

Conduct **at minimum 15 web searches** covering ALL of the following. Do NOT skip any category. For each search, extract specific data points, numbers, dates, and quotes.

### 1a. Company Overview & Business Model
- Search: "Golar LNG FLNG business model 2026"
- Search: "Golar LNG Hilli Episeyo FLNG production 2026"
- Search: "Golar LNG Gimi FLNG BP commissioning 2026"
- What does Golar LNG actually do? How do FLNGs work? What is the revenue model (tolling fees vs. commodity exposure)?
- What is the current FLNG fleet status (Hilli Episeyo, FLNG Gimi)?
- What is the FLNG Gimi contract with BP? When does it start generating revenue? What are the terms?
- What is the Mark II FLNG development pipeline?
- What is the relationship with New Fortress Energy (NFE)? Does Golar still have exposure to NFE?

### 1b. Financial Analysis
- Search: "Golar LNG earnings Q4 2025 revenue EBITDA"
- Search: "Golar LNG 2026 guidance revenue forecast"
- Search: "Golar LNG balance sheet debt 2026"
- What were the most recent quarterly earnings (revenue, EBITDA, net income, EPS)?
- What is the 2026 revenue guidance or consensus estimate?
- What is the debt structure? Maturity schedule? Interest coverage?
- What is the free cash flow profile? Is the company FCF positive?
- What is the dividend policy (if any)?
- What is the current market cap, enterprise value, and EV/EBITDA?

### 1c. Competitive Positioning & Industry
- Search: "floating LNG FLNG market 2026 competitors Golar"
- Search: "FLNG demand Iran Strait Hormuz LNG disruption"
- Who are the competitors in floating LNG (Shell Prelude, Petronas PFLNG, Eni Coral)?
- What is Golar's competitive advantage (first-mover, cost, technology)?
- How does the Iran conflict specifically benefit FLNG operators?
- What is the FLNG order backlog globally? Are new FLNGs being ordered?

### 1d. Analyst Coverage & Sentiment
- Search: "Golar LNG GLNG analyst rating price target 2026"
- Search: "Golar LNG GLNG upgrade downgrade March 2026"
- What is the analyst consensus (Buy/Hold/Sell)?
- What is the average and street-high price target?
- Have there been any recent upgrades or downgrades?
- What are the bull and bear cases from the street?

### 1e. Insider Activity & Institutional Ownership
- Search: "Golar LNG insider buying selling 2026"
- Search: "Golar LNG institutional ownership 13F"
- Any insider purchases or sales in the last 90 days?
- What is the institutional ownership percentage?
- Any notable hedge fund positions (13F filings)?
- Short interest — what percentage of float is short?

### 1f. Catalyst Calendar
- Search: "Golar LNG GLNG earnings date 2026 catalyst"
- Search: "Golar LNG Gimi FLNG first gas date"
- When is the next earnings report?
- When is FLNG Gimi expected to achieve first gas/first LNG?
- Are there any pending regulatory approvals, contract announcements, or fleet decisions?
- How do Iran peace talks / escalation milestones affect the stock?

### 1g. Risk Factors
- Search: "Golar LNG risks FLNG execution delays"
- What are the biggest risks (FLNG execution delays, contract cancellations, LNG oversupply, Iran ceasefire)?
- What happens to GLNG if Iran conflict resolves quickly and oil/LNG prices normalize?
- What is the counterparty risk on key contracts (BP, Perenco, etc.)?
- Are there any legal, regulatory, or environmental risks?

---

## PHASE 2: TECHNICAL ANALYSIS (Massive Market Data API)

### 2a. Price Data Pull
Pull the following data from Massive Market Data API and store for SQL analysis:

```
GET /v2/aggs/ticker/GLNG/range/1/day/2025-09-26/2026-03-26 → store_as: glng_6mo
GET /v2/aggs/ticker/GLNG/prev → store_as: glng_latest
GET /v2/aggs/ticker/LNG/range/1/day/2025-09-26/2026-03-26 → store_as: lng_6mo (comparable)
GET /v2/aggs/ticker/SPY/range/1/day/2025-09-26/2026-03-26 → store_as: spy_6mo (benchmark)
```

### 2b. Technical Computation via SQL
Using `query_data`, compute the following metrics:

1. **Moving averages:** 10-day, 20-day, 50-day, 200-day SMA of closing prices
2. **Relative strength vs. SPY:** (GLNG 30d return / SPY 30d return)
3. **Relative strength vs. LNG:** (GLNG 30d return / LNG 30d return) — is GLNG outperforming or underperforming the sector leader?
4. **Volume analysis:** Current volume vs. 20-day average volume — is volume expanding or contracting?
5. **Volatility:** 20-day realized volatility (standard deviation of daily returns × √252)
6. **Support/resistance levels:** Identify recent swing highs and swing lows from 6-month data
7. **Distance from key MAs:** How far is current price from 50-day and 200-day MA? (% above/below)
8. **Daily return distribution:** Average daily return, max up day, max down day in last 30 trading days

### 2c. Technical Assessment
Based on the computed data, provide:
- Is the stock in an uptrend, downtrend, or range-bound?
- Where are the nearest support and resistance levels?
- Is volume confirming the price move?
- Is there a Golden Cross or Death Cross setup?
- What is the risk/reward from current levels to the nearest support/resistance?

---

## PHASE 3: OPTIONS CHAIN ANALYSIS (Massive Market Data API)

### 3a. Pull Options Data
For the **three most relevant expirations** (April 17, July 17, January 15 2027), pull prev-day options data:

```
# April 2026 — near-term momentum plays
GET /v2/aggs/ticker/O:GLNG260417C00050000/prev   (ATM call)
GET /v2/aggs/ticker/O:GLNG260417C00055000/prev   (OTM call)
GET /v2/aggs/ticker/O:GLNG260417C00060000/prev   (OTM call)
GET /v2/aggs/ticker/O:GLNG260417P00050000/prev   (ATM put)
GET /v2/aggs/ticker/O:GLNG260417P00045000/prev   (OTM put)

# July 2026 — sweet spot for swing timeframe
GET /v2/aggs/ticker/O:GLNG260717C00050000/prev
GET /v2/aggs/ticker/O:GLNG260717C00055000/prev
GET /v2/aggs/ticker/O:GLNG260717C00060000/prev
GET /v2/aggs/ticker/O:GLNG260717C00065000/prev
GET /v2/aggs/ticker/O:GLNG260717C00070000/prev
GET /v2/aggs/ticker/O:GLNG260717P00050000/prev
GET /v2/aggs/ticker/O:GLNG260717P00045000/prev

# January 2027 LEAPS — long-duration thesis play
GET /v2/aggs/ticker/O:GLNG270115C00055000/prev
GET /v2/aggs/ticker/O:GLNG270115C00060000/prev
GET /v2/aggs/ticker/O:GLNG270115C00065000/prev
GET /v2/aggs/ticker/O:GLNG270115C00070000/prev
GET /v2/aggs/ticker/O:GLNG270115P00045000/prev
GET /v2/aggs/ticker/O:GLNG270115P00050000/prev
```

Store all with `store_as` for SQL analysis.

**⚠️ RATE LIMIT MANAGEMENT:** Pull options data in batches of 5-6 contracts at a time. Wait 10-15 seconds between batches if you hit 429 errors. Do NOT try to pull all at once.

### 3b. Greeks Computation
For each option contract pulled, compute theoretical Greeks using the `apply` parameter:

```json
{
  "apply": [
    {"function": "bs_delta", "inputs": {"spot": 54.06, "strike": "strike_price", "rate": 0.045, "time": <DTE/365>, "volatility": <realized_vol>}, "output": "delta"},
    {"function": "bs_gamma", "inputs": {"spot": 54.06, "strike": "strike_price", "rate": 0.045, "time": <DTE/365>, "volatility": <realized_vol>}, "output": "gamma"},
    {"function": "bs_theta", "inputs": {"spot": 54.06, "strike": "strike_price", "rate": 0.045, "time": <DTE/365>, "volatility": <realized_vol>}, "output": "theta"},
    {"function": "bs_vega", "inputs": {"spot": 54.06, "strike": "strike_price", "rate": 0.045, "time": <DTE/365>, "volatility": <realized_vol>}, "output": "vega"},
    {"function": "bs_price", "inputs": {"spot": 54.06, "strike": "strike_price", "rate": 0.045, "time": <DTE/365>, "volatility": <realized_vol>, "type": "call"}, "output": "theo_price"}
  ]
}
```

Replace `<DTE/365>` with actual days to expiry / 365 and `<realized_vol>` with the 20-day realized volatility computed in Phase 2.

### 3c. Options Analysis
For each expiration, analyze:

1. **Implied vs. realized volatility:** Is IV elevated relative to historical? Are options expensive or cheap?
2. **Theoretical vs. market price:** Compare `bs_price` output to actual market close. Are options mispriced?
3. **Delta exposure:** What delta are you getting per dollar of premium?
4. **Theta decay profile:** How much are you paying per day in time decay?
5. **Open interest & volume:** Which strikes have the most activity? Where is the smart money positioned?

---

## PHASE 4: STRATEGY CONSTRUCTION

Based on ALL data gathered in Phases 1-3, evaluate and present the following strategies. **For each strategy, provide exact numbers — not vague ranges.**

### Strategy 1: Equity Position (Stock Purchase)
- Entry price and rationale (buy at market, limit order, or wait for pullback?)
- Position size recommendation (as % of portfolio, given aggressive risk tolerance)
- Stop loss level (based on technical support)
- Target price (based on analyst targets + your own DCF/NAV assessment)
- Expected holding period
- Risk/reward ratio
- Dividend income (if applicable)

### Strategy 2: Directional Call Option (Outright Long Call)
- Recommended expiration and strike (and WHY — theta vs. gamma tradeoff)
- Entry price (last traded or estimated)
- Max loss (premium paid)
- Breakeven at expiration
- Target exit price (% gain on premium)
- Greeks at entry (delta, gamma, theta, vega)
- Scenario analysis: What happens if GLNG goes to $60? $65? $70? $50? $45?

### Strategy 3: Bull Call Spread (Defined Risk)
- Long strike and short strike (and WHY this width)
- Net debit (exact price from options data)
- Max gain, max loss, breakeven
- Risk/reward ratio
- When to take profit vs. let it expire
- Scenario analysis at expiration: stock at $50, $55, $60, $65, $70

### Strategy 4: LEAPS (Long-Duration Thesis Play)
- January 2027 call: recommended strike
- Cost of the LEAPS vs. owning 100 shares (capital efficiency)
- Delta — how much equity-like exposure are you getting?
- Break-even analysis
- When would you roll, take profit, or add?

### Strategy 5: Protective Strategies (if already long or planning equity entry)
- Collar (buy put, sell call) — recommended strikes and net cost
- Cash-secured put — if you want to get long at a lower price, which strike and expiration?

---

## PHASE 5: FINAL VERDICT & RECOMMENDATION

After completing ALL phases above, deliver a **clear, opinionated final recommendation** structured as follows:

### PRIMARY RECOMMENDATION
State clearly: **BUY STOCK**, **BUY OPTIONS** (specify which strategy), or **PASS**.

### CONVICTION LEVEL
Score 1-10 across four dimensions:
- **Momentum** (30%): Price action, volume, relative strength
- **Sentiment** (20%): Analyst consensus, insider activity, short interest
- **Valuation** (25%): Relative to peers, to history, to DCF/NAV
- **Catalyst Density** (25%): Near-term catalysts, event calendar, geopolitical alignment

**Weighted composite score: X.X / 10**

### THE TRADE (Exact Specification)
Provide the EXACT trade with ALL of the following fields:
1. **Ticker:** GLNG
2. **Direction:** Long / Short
3. **Vehicle:** Stock / Call / Put / Spread / LEAPS
4. **Expiration:** (if options)
5. **Strike(s):** (if options)
6. **Entry price:** $XX.XX
7. **Stop loss:** $XX.XX
8. **Target 1:** $XX.XX (and when to take partial profit)
9. **Target 2:** $XX.XX (full exit)
10. **Max risk per contract/share:** $XX.XX
11. **Risk/reward ratio:** X:X
12. **Position sizing:** X% of portfolio (given aggressive risk tolerance)

### WHAT WOULD CHANGE THE THESIS
- Bull invalidation: What price or event would make this trade wrong?
- Bear invalidation: What would upgrade this from PASS to BUY?
- Iran-specific scenarios: What happens on ceasefire? On escalation?

### COMPARISON TO WATCHLIST ALTERNATIVES
- Is GLNG a better trade than LNG (Cheniere) right now? Why or why not?
- Is GLNG a better trade than NEXT (NextDecade)? Why or why not?
- Does GLNG deserve to be ADDED to the watchlist? Which sub-sector?

---

## OUTPUT FORMAT

Draft the full analysis as an **HTML email** using the `gmail_create_draft` tool. Send to the recipients in `config/email-distro.json`. Subject line: **"GLNG Deep-Dive — [BUY/PASS] — [Date]"**

Format with:
- Executive summary at top (3-4 sentences, the verdict)
- Color-coded tables for price data, options chains, and scenario analysis
- Bold the final recommendation
- Include AI-generated research disclaimer at bottom

---

## IMPORTANT INSTRUCTIONS

1. **Use extended thinking** — this analysis requires deep reasoning. Think through each phase carefully before writing.
2. **Do NOT fabricate data** — if a web search doesn't return specific numbers, say so. If an API call fails, retry once then note the gap.
3. **Be opinionated** — the user wants a clear recommendation, not a wishy-washy "it depends." Take a stance and defend it.
4. **Manage API rate limits** — batch your MMD calls 5-6 at a time. Wait between batches.
5. **Cross-reference everything** — if the fundamentals say BUY but the technicals say OVERBOUGHT, address the conflict directly.
6. **Think about timing** — the user's preferred timeframe is 1-6 month swing trades. Don't recommend day trades or 5-year holds.
7. **Think about the Iran variable** — this is the single biggest driver of LNG/energy names right now. Your thesis MUST address both escalation and de-escalation scenarios.
