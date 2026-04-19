# TWFE Reviewer Report — Article 242

**Verdict:** WARN
**Date:** 2026-04-18

## Specification

- Outcome: `lnearns_gen1_a1499` (log QWI earnings, general workers aged 14-99)
- Treatment: `ddtquartile1` (top-quartile Rock Productivity Index counties)
- Unit FE: county (`cntyfips2000`)
- Time FE: replaced by `splay1_year_fe` (shale_play × year FEs, 464 categories)
- Controls: 7 baseline-×-year interaction terms (`i(year, X1990)`)
- Weights: `pop2000`
- Cluster: county
- Sample: 2002–2013, `balancesample == 1`, non-missing earnings

## Numerical result

| Statistic | Value |
|---|---|
| beta_twfe | 0.01944 |
| se_twfe | 0.00756 |
| t-stat | 2.57 |
| beta_twfe_no_ctrls | 0.01892 |
| se_twfe_no_ctrls | 0.00726 |

## Checklist

### 1. Specification fidelity
- [PASS] Treatment variable matches `ddtquartile1` per paper's Figure 2 / main DiD specification.
- [PASS] Shale-play×year FEs used instead of standard year FEs — correct per Stata code in notes.
- [PASS] Baseline-×-year interaction controls correctly specified.
- [PASS] Weights and clustering match paper.
- [PASS] Sample filter matches 2002–2013 balanced panel condition.

### 2. Coefficient stability (controls vs no-controls)
- [PASS] beta_twfe = 0.01944 vs beta_twfe_no_ctrls = 0.01892. Difference = 0.00052 (2.7% relative). Controls add minimal confounding correction — stable.

### 3. Staggered adoption concerns for TWFE
- [WARN] Treatment is staggered across 9 cohorts (2001–2012). TWFE with staggered adoption can be contaminated by forbidden comparisons (later-treated vs earlier-treated as controls). The Bacon decomposition confirms substantial heterogeneity across cohort pairs (estimates ranging from -0.19 to +0.20 in "Later vs Earlier Treated" pairs). The aggregate TWFE weight-averages these with potentially wrong-sign weights.
- [WARN] Treatment turns OFF after ~e=6 horizons (see metadata note about Pattern 37). This non-absorbing treatment structure means TWFE is measuring a mixture of adoption and de-adoption effects.

### 4. Fixed-effect structure
- [PASS] The 464 shale_play×year FEs are a demanding specification that absorbs common regional energy-cycle shocks within play areas. This is appropriate and a strength of the design.

### 5. Pre-trend evidence (TWFE event study)
- [PASS] Pre-treatment coefficients: t=-6: 0.001, t=-5: -0.005, t=-4: -0.008, t=-3: -0.008, t=-2: -0.005, t=-1: 0 (reference). All small and not individually distinguishable from zero. Pre-trend looks clean.

## Key concerns

1. **Staggered heterogeneity bias**: TWFE mixes clean and contaminated comparisons in a staggered design. The Bacon decomp shows "Later vs Earlier Treated" weights summing to ~5% of total with highly dispersed estimates (-0.19 to +0.20). While small in aggregate weight, the sign heterogeneity is notable.

2. **Non-absorbing treatment**: ddtquartile1 can switch off. TWFE conflates treatment-on and treatment-off dynamics. This is a design issue, not a TWFE implementation flaw, but it means the TWFE estimand is not a standard ATT.

## Verdict justification

WARN: The TWFE is implemented correctly and numerically stable. However, the staggered, non-absorbing treatment structure means the TWFE estimate conflates heterogeneous cohort-time ATTs and may include contamination from "later-vs-earlier" comparisons. The non-absorbing nature of the treatment is the primary concern.

[Full data: `results/by_article/242/results.csv`, `results/by_article/242/event_study_data.csv`]
