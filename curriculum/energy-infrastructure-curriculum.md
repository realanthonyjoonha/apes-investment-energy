# Energy Infrastructure & Supply Chain Curriculum

## Module 1: How the U.S. Electricity Grid Works
Status: NOT STARTED
- The physical grid: generation → high-voltage transmission → substations → distribution → consumption
- ISOs and RTOs: the organizations that operate regional grids
  - PJM: largest U.S. grid, serves 67M people across 13 states + DC, critical for Data Center Alley (Northern Virginia)
  - ERCOT: Texas (isolated grid, no federal regulation, 137 GW pending interconnection)
  - MISO: Midwest/South (LRTP Tranche 1: 18 projects, $10.3B)
  - CAISO: California (renewable-heavy, storage leader)
  - SPP, NYISO, ISO-NE: regional operators with distinct market structures
- Wholesale electricity markets: how power is bought and sold — day-ahead vs. real-time markets, locational marginal pricing (LMPs)
- Capacity markets: how PJM and others pay generators to be available — the $333/MW-day record clearing price and what it signals
- Ancillary services: frequency regulation, spinning reserves, voltage support — revenue streams beyond energy sales
- The difference between regulated utilities (guaranteed return, rate base model) and independent power producers (market-exposed, merchant generation)
- Allowed ROE for utilities: average 9.73% — how rate cases work and why they matter
- Why understanding grid structure matters for this thesis: every bottleneck in the grid = an investable opportunity

## Module 2: The Interconnection Crisis — The #1 Binding Constraint
Status: NOT STARTED
- What interconnection means: the process of connecting a new power source (generator, data center, solar farm) to the grid
- The queue crisis in numbers: ~2,300 GW of total active capacity across ~10,300 projects (LBNL 2025)
- Historical completion rates: only 13% of capacity submitted 2000-2019 reached commercial operation, 77% withdrawn
- Timeline explosion: PJM interconnection expanded from <2 years (2008) to 8+ years (2025) — median time nationally doubled to 4+ years
- Why the queue is so backlogged: speculative requests, study bottlenecks, cascading restudies when projects drop out, insufficient transmission
- FERC Order 2023 reforms: cluster-based interconnection studies (replacing serial queue), financial penalties for speculative projects, first reformed cycle opens April 2026
- Natural gas queue capacity surged 72% YoY to 136 GW — gas is flooding into the queue because it's the only thing that can get built fast
- PJM capacity crisis: December 2025 auction closed 6,600 MW short of reserve margin — what this means for reliability and pricing
- Behind-the-meter (BTM): the hyperscaler escape valve — ~40 projects / 48 GW of BTM capacity announced by end-2025
- How BTM works: data centers build their own power plants on-site, bypass the interconnection queue entirely, natural gas turbines as primary solution
- Why BTM changes the investment thesis: shifts value from grid-connected utilities to gas turbine manufacturers (GEV), gas suppliers (EQT, ET), and BTM developers
- ERCOT vs. PJM vs. MISO: comparing interconnection processes, timelines, and which markets are most accessible for new generation
- The DOE/LBNL finding that matters: "No examples of grid-aware flexible operation at data centers exist today" — data centers are pure demand, not flexible load

## Module 3: The Transformer Supply Chain Crisis
Status: NOT STARTED
- What transformers do in the grid: step up voltage at generation (GSU transformers), transmit at high voltage, step down for distribution — every electron passes through multiple transformers
- The crisis in numbers:
  - Large power transformer lead times: 128 weeks (~2.5 years)
  - Generator step-up transformer lead times: 144 weeks (~2.8 years)
  - Up from ~50 weeks in 2021 — nearly tripled
  - Wood Mackenzie: 30% supply shortfall for power transformers, 47% shortfall for GSUs in 2025
- Demand surge: GSU demand up 274% since 2019, power transformer demand up 116%
- Why supply can't catch up: transformers are custom-engineered (not commodities), take 12-18 months to build, require specialized materials and skilled labor
- The aging fleet: 50%+ of ~40M U.S. distribution transformers are beyond design life — maintenance/replacement competes with new capacity
- Import dependency: U.S. imports 80% of power transformer supply — geopolitical and tariff vulnerability
- GOES (grain-oriented electrical steel): ~25% of large power transformer production cost, nearly doubled in price, Cleveland-Cliffs is the only domestic supplier
- Price escalation: 77-95% increases since 2019, further 20-30% expected (tariffs + structural deficits)
- New manufacturing capacity announced ($1.8B since 2023): Eaton $340M South Carolina plant, Siemens Energy $150M North Carolina facility, Hitachi Energy Virginia expansion
- Why deficits persist into the 2030s despite new capacity: demand growth outpacing supply additions, long factory ramp-up times, skilled labor shortages
- Investment implications: transformer manufacturers and their suppliers have pricing power for years — how this flows to Eaton (ETN), GE Vernova (GEV), Hubbell (HUBB)
- The Duane Arnold restart constraint: target restart Q1 2029 but constrained by transformer delivery in 2028 — transformers are literally gating nuclear restarts

## Module 4: Transmission Expansion — The $360B Opportunity
Status: NOT STARTED
- Why new transmission matters: connects generation to load centers, reduces congestion, enables renewable integration, improves reliability
- The building drought: new high-voltage transmission construction fell to just 55 miles in 2023 (down from ~3,300 miles/year 2011-2020)
- Where the money goes today: annual spending >$25B/year but 90% funds maintenance/replacement, not new capacity — the grid is being maintained, not expanded
- DOE National Transmission Needs Study: regional capacity must more than double by 2035, interregional transfer capacity must grow 5x
- Investment need: $360B+ through 2035, potentially $2.2T by 2050
- HVDC (High-Voltage Direct Current) technology: why it's superior for long-distance transmission, lower losses, ability to run underwater/underground, Hitachi Energy's monopoly-like position
- Landmark projects in progress:
  - SunZia (Pattern Energy): 550 miles, 3 GW HVDC, ~$11B — largest clean energy infrastructure project in U.S. history, energization targeted early 2026
  - CHPE (Transmission Developers/Blackstone): 339 miles underwater NYC, 1,250 MW HVDC, ~$6B — 99% trenching complete, on schedule May 2026, delivers ~20% of NYC electricity
  - TransWest Express (Anschutz): 732 miles, 3,000 MW HVDC, ~$3B — under construction, targeting 2027
  - MISO LRTP Tranche 1: 18 projects, 2,000+ miles, $10.3B (benefit-to-cost ratio ≥2.6:1)
- FERC Order 1920: 20-year regional transmission planning across seven benefit categories — how this unlocks long-term project justification
- Permitting challenges: why it takes years to site and permit a transmission line (environmental review, eminent domain, multi-state coordination, NIMBY opposition)
- Who builds transmission: Quanta Services (PWR) as the dominant T&D contractor, MYR Group, MasTec, Primoris
- Total U.S. utility capex: projected at record $208B for 2025 (up from $140B in 2020), $1.1T projected 2025-2029
- Global context: grid investment expected to top $470B for first time in 2025

## Module 5: Grid-Enhancing Technologies — The Near-Term Relief Valve
Status: NOT STARTED
- Why GETs matter now: new transmission takes years to build, but existing lines can be upgraded in months
- Dynamic Line Rating (DLR): using real-time weather data (wind, temperature, solar heating) to calculate actual line capacity vs. conservative static ratings — can boost capacity up to 40% in 3-12 months
- Advanced reconductoring: replacing existing conductor wire with modern high-capacity materials (carbon-core, high-temperature) on existing towers and rights-of-way — can double line capacity in 1-3 years
- Topology optimization: software-based rerouting of power flows across the network to reduce congestion — deployable in weeks with no physical construction
- Power flow controllers: hardware devices that direct electricity along specific paths to reduce bottlenecks
- The RMI analysis: GETs deployed in PJM alone could enable 6.6 GW of new capacity + $1B/year in savings — massive ROI on relatively small investments
- Why GETs aren't widely deployed yet: utility incentive structures (capex bias favors building new over optimizing existing), lack of regulatory mandates, limited vendor ecosystem
- FERC's role in GET adoption: potential mandates, cost allocation reforms, performance incentives
- Companies in the GET space: LineVision (DLR sensors), SmartWires (power flow controllers), CTC Global (advanced conductor), VEIR (high-temperature superconductor)
- How GETs interact with the interconnection queue: can GETs unlock enough capacity to de-bottleneck the queue? Partially — they buy time but don't solve the structural deficit
- GETs as a bridge strategy: 3-12 months for DLR, 1-3 years for reconductoring, buying time while major transmission projects advance on 5-10 year timelines
- Investment implications: mostly private/early-stage companies, but benefits flow to utilities (higher throughput) and grid contractors (installation work)

## Module 6: Midstream Infrastructure — Pipelines, Processing & the Gas Highway
Status: NOT STARTED
- What midstream does: gathering, processing, transporting, and storing natural gas and NGLs between the wellhead and end markets (power plants, LNG terminals, industrial users)
- The business model: toll-road economics — midstream companies are paid to move gas regardless of commodity price (fee-based contracts, take-or-pay provisions)
- Key pipeline systems serving the AI power demand thesis:
  - Transco (Williams): largest U.S. gas pipeline system, runs from Gulf Coast through Appalachia to Northeast, backbone of East Coast gas delivery
  - Mountain Valley Pipeline (EQT ownership): connects Marcellus gas to Southeast markets, recently completed after years of legal battles
  - South System (Kinder Morgan): Gulf Coast system feeding power plants and LNG terminals
- Williams Companies (WMB) deep-dive: $3.1B in DC-linked power projects, Transco system, growing gas gathering in Haynesville and Northeast, stable fee-based earnings
- Kinder Morgan (KMI) deep-dive: $9.3B backlog, South System Expansion 4 ($3.5B / 1.3 Bcf/d), Mississippi Crossing (2.1 Bcf/d), largest natural gas pipeline network in North America
- Energy Transfer (ET) deep-dive: 5.5 GW in DC behind-the-meter deals (CloudBurst 1.2 GW, Fermi America 2 GW, Oracle/VoltaGrid 2.3 GW), connection requests from 40+ DCs across 10 states, Lake Charles LNG
- DT Midstream (DTM) deep-dive: pure-play natural gas midstream, 95% demand-based contracts, $3.4B backlog, underappreciated DC exposure
- Targa Resources (TRGP) deep-dive: NGL-focused midstream, Permian Basin dominant, benefits from increased associated gas production as oil producers ramp
- ONEOK (OKE) deep-dive: major NGL pipeline operator, Rocky Mountain/Mid-Continent/Permian systems, benefits from increased production activity
- How pipeline capacity constraints create opportunity: Appalachian gas stuck behind insufficient takeaway capacity, premium pricing for constrained supply, new pipeline projects as catalysts
- Midstream valuation: EV/EBITDA (8-12x typical), distributable cash flow yield, distribution growth, leverage ratios, contract duration and quality
- The MLP vs. C-corp structure: why most midstream companies converted to C-corps, tax implications, K-1 vs. 1099

## Module 7: Midstream-Data Center Convergence — A New Revenue Category
Status: NOT STARTED
- The thesis: midstream companies are becoming data center power suppliers — a completely new business line that didn't exist 2 years ago
- Williams Will-Power subsidiary: building behind-the-meter gas power plants for Meta's New Albany, Ohio data center (400→700 MW), first-of-its-kind midstream-to-DC vertical integration
- Energy Transfer's DC pipeline: three major BTM deals (CloudBurst 1.2 GW, Fermi America 2 GW, Oracle/VoltaGrid 2.3 GW), 40+ DC connection requests across 10 states
- How the BTM model works: midstream company supplies gas AND builds the power plant on-site, data center bypasses grid interconnection entirely
- Why midstream has an advantage: they already own the gas supply, the pipeline infrastructure, and the rights-of-way — adding generation is a natural extension
- Meta's gas generation strategy as a case study: Richland Parish (2,260 MW via Entergy), New Albany OH (700 MW BTM via Williams Will-Power), El Paso (366 MW from 813 modular generators)
- xAI Colossus and the Solaris JV: 460 MW gas turbines, dedicated 1.2 GW power plant shipped from overseas — the extreme end of behind-the-meter
- OpenAI/Crusoe Energy: ~1 GW gas-fired generation partnership as part of the $500B Stargate infrastructure ambition
- Revenue modeling: how DC power supply revenue compares to traditional midstream toll-road economics — likely higher-margin, longer-duration contracts
- Risks: construction execution, gas supply reliability commitments, regulatory scrutiny of BTM arrangements, utility pushback on lost customers
- How to evaluate midstream companies with DC exposure: what percentage of future earnings comes from DC deals, pipeline of opportunities, management credibility
- The competitive dynamic: will utilities fight back against BTM? Or will they partner? Dominion's 47.1 GW DC pipeline suggests utilities want the load on their system

## Module 8: Electrical Equipment & Grid Construction Companies
Status: NOT STARTED
- The picks-and-shovels thesis: regardless of which generation technology wins, the grid needs massive physical construction — equipment makers and contractors benefit from all scenarios
- GE Vernova (GEV) deep-dive: the most important stock in the energy infrastructure theme
  - FY2025 revenue $38.1B, orders $59.3B (+34% organic), backlog $150B
  - Gas turbine dominance: DC-focused deals with Chevron/Engine No.1 (4 GW JV), NRG (5.4 GW), NextEra, Crusoe (~1 GW), Duke Energy (11 turbines)
  - Gas turbine backlog grew 62→83 GW in Q4 2025 alone — reservations expected sold out through 2030 by end of 2026
  - Grid Solutions segment: transformer manufacturing, grid automation, HVDC converters
  - Prolec GE acquisition ($5.3B, closing mid-2026): adds DC-specific electrical equipment, transformer capacity
  - Wind segment weakness as the offset: headwind from OBBBA policy cliff on wind credits
- Eaton (ETN) deep-dive: electrical power management for data centers and grid
  - Record results: 23.9% segment margins, guiding 2026 adj EPS $13.00-$13.50
  - DC power distribution: uninterruptible power supplies, switchgear, power distribution units
  - Utility-facing products: transformers, switchgear, reclosers
  - $340M South Carolina transformer plant investment — adding domestic capacity
- Hubbell (HUBB) deep-dive: utility-facing electrical hardware
  - Utility Solutions segment: transmission and distribution components, connectors, insulators, surge arresters
  - Strong pricing power: essential components with limited substitutes
  - Beneficiary of every utility capex dollar regardless of generation type
- Quanta Services (PWR) deep-dive: dominant electrical T&D contractor
  - Record $44B backlog — largest in company history
  - Indispensable role: designs, installs, and maintains transmission lines, substations, distribution networks
  - Labor advantage: 50,000+ skilled workers (electricians, linemen) in an industry with 80,000 vacant positions
  - 800 electricians needed to build one modern data center — labor scarcity gives Quanta pricing power
- Vertiv Holdings (VRT) deep-dive: pure-play data center infrastructure
  - 252% surge in organic orders, $15B backlog
  - Essential as rack power density jumps to 100+ kW (thermal management, power distribution, UPS)
  - Competition from Schneider Electric and Eaton, but market is growing fast enough for all
- The labor bottleneck: 80,000 vacant electrician positions, retirement outpacing entry 1.7:1 in nuclear and 1.4:1 in grids — this is as binding as equipment shortages
- Valuation framework: backlog-to-revenue ratios, book-to-bill ratios, margin expansion potential, labor productivity metrics

## Module 9: The AI-Energy Convergence Valuation Premium
Status: NOT STARTED
- The valuation re-rating: IPPs with nuclear/DC exposure returned avg 71% in 2025 vs 15% for regulated utilities — the largest sector divergence in a generation
- Why the market is repricing energy: data center demand transformed "boring utilities" into growth stories with 10-20 year demand visibility
- Constellation trailing P/E 33-45x: 58-74% premium to regulated utility peers — decomposing what's priced in (nuclear fleet × DC demand × Calpine synergies × TMI restart)
- Vistra trailing P/E 55-63x compressing to ~16x forward: massive earnings growth anticipated from Meta PPA + capacity market tailwinds
- Talen Energy at ~20.6x forward: cheapest forward metrics of the nuclear IPPs, anchored by $18B Amazon PPA — a value play in a momentum sector
- PJM capacity market as a hidden value driver: record $333/MW-day clearing prices, how capacity revenue adds to energy and PPA revenue for generation owners
- NRG's LS Power acquisition valuation: 13 GW of gas assets at ~7.5x 2026 EBITDA, below $1,000/kW (less than half replacement cost) — transaction-based evidence of what generation is worth
- Alphabet's Intersect Power acquisition ($4.75B): signaling hyperscaler vertical integration into generation — what happens when your customer becomes your competitor?
- Capital flows as a signal: $141.9B in power/utility deals in 12 months (5x increase), Brookfield $20B fund, KKR $15B fund — institutional money validating the thesis
- The risk to the premium: what happens if hyperscaler capex gets cut >20%, if AI revenue disappoints, if the "DeepSeek effect" (efficiency reduces aggregate demand) plays out
- Jevons paradox as the bull case for demand: efficiency improvements in AI per-task consumption may actually INCREASE aggregate demand by making AI accessible to more use cases
- Historical analogy: internet infrastructure buildout 1995-2000 created enormous winners (and losers) — what parallels apply and what's different this time
- Framework for determining when to add vs. trim: valuation ceilings, catalyst calendars, earnings quality vs. momentum

## Module 10: Policy, Regulation & Government Levers
Status: NOT STARTED
- OBBBA (One Big Beautiful Bill Act) comprehensive breakdown:
  - Terminated: solar/wind credits (45Y/48E) after Dec 2027, clean hydrogen (45V) after Dec 2025, clean vehicle credits after Sept 2025
  - Preserved: nuclear credits (45U) through 2031, 45X manufacturing to 2032, 45Q carbon capture enhanced
  - Net effect: massive policy tilt from renewables toward nuclear and gas
- FERC's three critical orders:
  - Order 2023: cluster-based interconnection reform with financial penalties — first reformed cycle April 2026
  - Order 1920: 20-year regional transmission planning across seven benefit categories
  - December 18, 2025 co-location order: directed PJM to establish DC co-location rules at power plants — direct catalyst for nuclear-DC deals
- NRC actions in 2025: 13 reactor license renewals (12,000 MW preserved), NuScale uprated 77 MWe design approved, first-ever restart from decommissioning (Palisades) processing
- Executive orders: target quadrupling U.S. nuclear capacity to 400 GW by 2050 — the most pro-nuclear policy stance in decades
- DOE Loan Programs Office: >$300B remaining lending authority across five programs, $118B already deployed (46 active loans, 25 conditional commitments) — the quiet engine behind nuclear restarts and clean energy infrastructure
- State-level dynamics:
  - Virginia's $1.6-1.9B annual DC tax exemption facing legislative scrutiny
  - 20 DC projects worth $98B blocked/delayed in Q2 2025 alone
  - 188 active opposition groups across 17+ states
  - Rate case outcomes in 34 states — each one moves utility stock prices
- Dominion Energy as the state-level case study: 70 GW DC demand pipeline (3x peak load) but residential bills projected +60-93% by 2035 — the ratepayer backlash risk
- Trade policy impact: Chinese BESS at 82%+ tariffs, solar panels at 175%+, rare earth export controls — how trade war reshapes the supply chain
- How to monitor policy: FERC docket tracking, NRC ADAMS filings, state PUC rate case calendars, Congressional energy committee hearings
- Investment implications: policy creates winners (nuclear, gas, domestic manufacturing) and losers (wind, offshore wind, import-dependent solar) — position accordingly

## Module 11: Geopolitical Risk, Commodity Dynamics & Supply Chain Vulnerabilities
Status: NOT STARTED
- The Iran conflict and energy markets: how Middle East disruption flows through global oil and gas pricing, shipping routes, and supply contracts
- Copper as the silent bottleneck: prices up ~40% in 2025, IEA projects 30% supply shortfall by 2035 — every transformer, cable, and motor needs copper
- Rare earth and critical mineral risks: China produces ~60% of rare earths and controls ~90% of processing — export controls as a geopolitical weapon
- GOES (grain-oriented electrical steel): specialized material for transformer cores, Cleveland-Cliffs as sole domestic supplier, near-doubled pricing, single-supplier risk
- Uranium geopolitics: Russia historically ~24% of U.S. enrichment supply, Kazakhstan (Kazatomprom) producing ~43% of global uranium, supply chain restructuring underway
- Natural gas price scenario modeling:
  - $3-3.50/MMBtu: baseline, moderate gas E&P profitability, DC gas generation economics favorable
  - $4-5/MMBtu: supply squeeze scenario, gas E&P windfall profits, DC operators start feeling cost pressure
  - $5+/MMBtu sustained: gas-dependent DC plays face margin compression, gas E&Ps see massive free cash flow, pivot to nuclear/storage accelerates
- Oil price scenario modeling (Iran conflict):
  - $80-90/barrel: baseline elevated, Permian producers profitable, moderate geopolitical premium
  - $90-110/barrel: sustained disruption, Permian producers generate enormous FCF, associated gas production increases
  - $110+/barrel: demand destruction risk, recession fears offset supply premium, volatility spikes
- The "DeepSeek effect" debate: AI efficiency improvements could reduce per-task energy consumption — but Jevons paradox suggests aggregate demand still grows as AI becomes cheaper to use
- Hyperscaler capex as the master variable: if Microsoft/Google/Amazon/Meta/Oracle collectively guide 2027 capex below $500B (vs. current $600-700B trajectory), demand thesis weakens materially
- Threshold alerts that change positioning:
  - Henry Hub >$5 sustained: add gas E&P, trim gas-dependent DC
  - Uranium >$120/lb: trim leveraged nuclear restarts
  - 10Y Treasury >5.5%: reduce rate-sensitive utility exposure
  - 3+ states pass DC moratoriums: reduce AI-energy convergence
  - Transformer lead times <100 weeks: accelerate grid infrastructure timeline
- Hedging strategies: long put spreads on DC-exposed names for AI demand disappointment, long commodity positions for supply squeeze, pair trades for policy neutrality

## Module 12: Portfolio Construction & Risk Management for the Energy Supercycle
Status: NOT STARTED
- The five-pillar framework as portfolio architecture:
  - Natural Gas (#1 near-term): highest conviction, most immediate cash flow — core position
  - Grid Infrastructure (#2 most durable): longest duration tailwind, least dependent on any single demand driver
  - AI-Energy Convergence (#3): highest beta, most dependent on hyperscaler capex continuing
  - Storage/Renewables (#4): selective exposure (First Solar, Tesla Energy), policy-dependent
  - Nuclear (#5): best long-term optionality, worst near-term execution risk — position for 3-5 year payoff
- Position sizing by conviction level: the document's Top 10 conviction rankings as a sizing framework
  - HIGH conviction (larger positions): CEG, GEV
  - MEDIUM-HIGH: VST, PWR, EQT, VRT
  - MEDIUM: CCJ, WMB
  - SPECULATIVE (small positions): IREN, OKLO
- Balancing generation vs. infrastructure vs. convergence exposure: correlation analysis, what happens to each sub-theme in different scenarios
- Options strategies for energy names:
  - LEAPS on high-conviction names (CEG, GEV, EQT) for capital-efficient long exposure
  - Bull call spreads on gas E&Ps targeting Henry Hub squeeze scenario ($4.50-$6.00 range)
  - Straddles/strangles ahead of binary events (earnings, NRC decisions, FERC rulings, PPA announcements)
  - Covered calls on existing positions for income in sideways markets
  - Put spreads as hedges on DC-exposed names against AI demand disappointment
- Pair trade strategies:
  - Long gas/nuclear + short wind/solar manufacturing: neutral to OBBBA-type policy shifts
  - Long domestic producers + short import-dependent names: geopolitical hedge
  - Long generation + short speculative DC developers: captures supply chain value while hedging demand uncertainty
- Commodity hedges: long copper miners (FCX) or uranium miners (CCJ, UEC) for supply squeeze scenarios, natural gas futures for direct commodity exposure
- The monitoring framework as portfolio management discipline:
  - Daily: Henry Hub, uranium spot, copper, 10Y Treasury, key stocks
  - Weekly: EIA storage, Baker Hughes rig count, NRC filings, ISO queue updates
  - Monthly: utility rate cases, DOE announcements, EIA Electric Power Monthly, transformer surveys, 13F filings
- When to add vs. trim: using the threshold alerts as systematic triggers rather than emotional decisions
- The 3-5 year view: what this portfolio looks like if the demand thesis fully plays out vs. if it disappoints — modeling both outcomes to stress-test conviction
- Risk matrix awareness: interconnection delays (4.8/5), trade war escalation (4.2/5), transformer shortage (4.2/5), nuclear cost overruns (4.2/5), China rare earths (4.0/5), AI revenue disappointment (3.5/5)
