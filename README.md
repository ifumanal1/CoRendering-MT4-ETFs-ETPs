# Real-Time Co-Rendering Engine for MT4: Synthetic ETFs and ETPs for Nasdaq and S&P 500

This repository contains the full open-source implementation of a real-time visualization engine for MetaTrader 4 (MT4).  
The system renders Nasdaq 100 (USATec) and S&P 500 (USA500) index CFDs together with synthetic price models of seven European ETFs and ETPs:

- **Nasdaq 100:** EQQQ (1×), 3QQQ (3×), QSL5 (5×), 3QSS (–3×)  
- **S&P 500:** VUAA (1×), DBPG (2×), US9S (–3×)

The synthetic instruments incorporate **daily rebalancing at 22:00 CET**, **seed‑anchored historical reconstruction**, and **tick‑level intraday updates**.  
This enables MT4 users to analyze ETF/ETP-equivalent price action with higher granularity than typical brokerage platforms.

---

## 🔧 Features

- Real-time synthetic price computation for 7 ETFs/ETPs  
- Daily rebalancing model consistent with UCITS leveraged products  
- Seed‑based historical reconstruction  
- Modular MQL4 implementation  
- Independent sub-window rendering for each instrument  
- Zero external dependencies (MT4-native)

---

## 📦 Repository Structure


