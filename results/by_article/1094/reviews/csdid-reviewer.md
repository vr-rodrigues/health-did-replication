# CS-DID Reviewer Report: Article 1094

**Verdict: WARN**
**Date:** 2026-04-18
**Paper:** Fisman & Wang (2017) — "The Distortionary Effects of Incentives in Government: Evidence from China's Death Ceiling Program"

---

## 1. Design Consistency

- Treatment timing: staggered (7 cohorts: 2006, 2007, 2008, 2009, 2010, 2011, 2012)
- `gvar_CS = effective_year + 1` — correct, since `post = I(year > effective_year)` means first treated year is effective_year + 1
- Clean never-treated control group: 12 truly never-treated + 4 provinces with effective_year=2012 (after sample window) = 16 control provinces
- `run_csdid_nyt=false`: NYT estimator not run; justified given availability of a clean never-treated group
- Clustering at province level (31 clusters): appropriate

## 2. ATT Results Comparison

| Estimator | ATT | SE | t-stat |
|-----------|-----|----|--------|
| TWFE | -0.047 | 0.041 | -1.15 |
| CS-NT (simple) | -0.029 | 0.035 | -0.83 |
| CS-NT (dynamic) | -0.026 | 0.031 | -0.84 |

Direction: Both estimators agree (negative). Magnitude: CS-NT ATT is ~38–45% smaller in absolute value than TWFE. This divergence is substantively meaningful — TWFE may be inflated in absolute magnitude due to heterogeneity bias, even though both estimates are statistically insignificant.

## 3. Statistical Significance

Neither estimator finds a statistically significant treatment effect at conventional levels. The paper's Table 2 also reports p > 0.05. Qualitative conclusion (null effect) is preserved across estimators.

## 4. Pre-Trend Assessment (CS-NT event study)

| Period | Coef | SE | p approx |
|--------|------|----|----------|
| t=-5 | +0.006 | 0.055 | 0.91 |
| t=-4 | -0.032 | 0.069 | 0.64 |
| t=-3 | -0.103 | 0.069 | 0.14 |
| t=-2 | +0.053 | 0.071 | 0.45 |

The t=-3 coefficient (-0.103, SE=0.069) approaches 1.5 SEs and is nearly as large in magnitude as the post-period ATT estimates. This represents a mild pre-trend concern specific to the CS-NT estimator, though it does not reach standard significance thresholds.

## 5. Post-Period Dynamics (CS-NT)

| Period | Coef | SE |
|--------|------|----|
| t=0 | -0.075 | 0.051 |
| t=1 | +0.024 | 0.054 |
| t=2 | +0.029 | 0.063 |
| t=3 | -0.113 | 0.056 |
| t=4 | +0.022 | 0.045 |

Highly erratic post-period pattern — no sustained negative treatment effect. Sign reversals at t=1, t=2, t=4. Only t=3 approaches significance (p≈0.044).

## 6. SA Estimator Cross-Check

SA estimates are close to CS-NT:
- SA at t=-3: -0.093 (CS-NT: -0.103) — consistent mild pre-trend concern
- SA at t=0: -0.065 (CS-NT: -0.075)
- SA at t=3: -0.119 (CS-NT: -0.113)

SA and CS-NT broadly agree, confirming internal consistency of the CS-NT implementation.

## 7. Magnitude Divergence Concern

The ~38% smaller CS-NT ATT relative to TWFE (-0.029 vs -0.047) is noteworthy for a binary LPM outcome (1.8 pp vs 4.7 pp effect). This suggests TWFE is somewhat inflated by heterogeneity bias. However, since both are insignificant, this does not reverse the qualitative conclusion.

## 8. Summary

**Verdict: WARN**

CS-DID implementation is methodologically sound and correctly specified. The qualitative null conclusion is robust across TWFE and CS-NT. Two concerns flagged: (1) ~38% magnitude divergence between TWFE and CS-NT ATT, suggesting heterogeneity bias in TWFE; (2) mild pre-period t=-3 coefficient under CS-NT (-0.103, SE=0.069) approaching 1.5 SEs.
