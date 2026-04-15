# MT4-ETF-Synth

**Real-Time Visualization Engine for Synthetic Leveraged ETF and ETP Price Models in MetaTrader 4**

[\![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
\![Language: MQL4](https://img.shields.io/badge/Language-MQL4-blue)
\![Platform: MetaTrader 4](https://img.shields.io/badge/Platform-MetaTrader%204-green)

---

## Overview

MT4-ETF-Synth is an open-source suite of seven MQL4 custom indicators for MetaTrader 4 (MT4) that renders synthetic real-time price models of seven UCITS-regulated leveraged ETFs and ETPs directly within the MT4 chart environment, using live Nasdaq 100 and S&P 500 CFD data as the underlying feed.

The suite is the software artifact accompanying the paper:

> I. Fumanal-Andrés, "MT4-ETF-Synth: A Real-Time Visualization Engine for Synthetic Leveraged ETF and ETP Price Models in MetaTrader 4", *SoftwareX*, 2025.

---

## Instruments Covered

| Indicator file | Product | Underlying | Leverage (L) | CFD symbol | Colour |
|---|---|---|---|---|---|
| `EQQQ_Synth.mq4` | EQQQ | Nasdaq 100 | +1× | USATec | Lime |
| `3QQQ_Synth.mq4` | 3QQQ | Nasdaq 100 | +3× | USATec | Dodger Blue |
| `QSL5_Synth.mq4` | QSL5 | Nasdaq 100 | +5× | USATec | Orange |
| `3QSS_Synth.mq4` | 3QSS | Nasdaq 100 | −3× | USATec | Red |
| `VUAA_Synth.mq4` | VUAA | S&P 500 | +1× | USA500 | Lime |
| `DBPG_Synth.mq4` | DBPG | S&P 500 | +2× | USA500 | Dodger Blue |
| `US9S_Synth.mq4` | US9S | S&P 500 | −3× | USA500 | Red |

---

## Mathematical Model

The synthetic ETP price at intraday time *t* within trading day *d* is:

```
P_ETP(t) = B_ETP^(d-1) × ( P_CFD(t) / B_CFD^(d-1) )^L
```

where `B_CFD` and `B_ETP` are the CFD and ETP prices at the previous daily rebalancing boundary (22:00 CET), and `L` is the signed leverage factor. At each rebalancing event the bases are updated to the closing values.

A **seed-anchored backward reconstruction** method aligns each synthetic series to the current real market price supplied by the user at initialization, ensuring historical consistency across sessions.

---

## Installation

1. Open **MetaEditor 4** (Tools → MetaQuotes Language Editor in MT4).
2. Copy the desired `.mq4` file(s) into your MT4 `MQL4/Indicators/` folder.
3. In MetaEditor, open the file and press **F5** (or Compile) to compile it into a `.ex4` binary.
4. In MT4, open the chart for the relevant CFD symbol:
   - **USATec** for Nasdaq 100 indicators (EQQQ, 3QQQ, QSL5, 3QSS)
   - **USA500** for S&P 500 indicators (VUAA, DBPG, US9S)
5. Drag the compiled indicator from the Navigator panel onto the chart.
6. Set the `Seed` parameter to the **current real market price** of the product (check your broker platform).
7. Leave `RebalHour = 21` for summer time (UTC); change to `22` in winter (CET = UTC+1).

---

## Parameters

| Parameter | Default | Description |
|---|---|---|
| `Seed` | varies | Current real market price of the ETF/ETP. Used to anchor the synthetic series at bar 0. |
| `RebalHour` | 21 | UTC hour of the daily rebalancing boundary. 21 = 22:00 CET (summer); use 22 in winter. |

---

## Important Notes

- Each indicator **must be attached to the correct CFD chart** (USATec or USA500). Do not attach a Nasdaq indicator to USA500 or vice versa.
- The synthetic model does not incorporate management fees, bid-ask spread effects, or intraday tracking error relative to the official NAV. For intraday decision-making these effects are negligible.
- Multi-day cumulative values may drift slightly from the real product NAV due to fee drag and replication imperfections.
- All indicators use 1-minute (M1) bar data.

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## Author

**I. Fumanal-Andrés**  
Department of Software Engineering, UNED, Madrid, Spain  
ifumanal1@alumno.uned.es
