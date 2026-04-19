# CS-DID Reviewer Report: Article 262

**Verdict:** WARN
**Date:** 2026-04-18
**Article:** Anderson, Charles, Rees (2020) — Hospital Desegregation & Black Postneonatal Mortality

---

## Checklist

### 1. Estimator Configuration

- **CS-NT** (never-treated control group): run_csdid_nt = true. Appropriate — there are counties that were never Medicare-certified in this period.
- **CS-NYT** (not-yet-treated control group): run_csdid_nyt = true. Appropriate for staggered designs.
- **Control variables in CS:** `cs_controls = []` (empty). The CS-DID runs without the time-varying county controls used in TWFE. This is a methodological choice noted as acceptable in the metadata, but introduces asymmetry with TWFE.
- **Group variable:** `gvar_CS` constructed as `ifelse(medicare_any > 0, as.integer(medicare_any), 0)` — maps to first year of Medicare certification. Correct approach for CS-DID group definition.

### 2. ATT Estimates

| Estimator | ATT_simple | SE | t-stat | ATT_dynamic | SE_dyn |
|-----------|-----------|-----|--------|-------------|--------|
| CS-NT | 0.995 | 0.404 | **2.46** | 0.980 | 0.405 |
| CS-NYT | 1.270 | 2.222 | 0.57 | 1.237 | 2.317 |
| CS-NT with controls | 0 | NA | — | 0 | NA |
| CS-NYT with controls | 2.452 | 2.705 | 0.91 | 2.723 | 2.508 |

**Key findings:**
- CS-NT simple ATT is **statistically significant** at 5% (t=2.46), in contrast to the insignificant TWFE.
- CS-NYT has very large SEs — consistent with the metadata note that not-yet-treated units are extremely sparse for late cohorts (1970–1973 < 1% each). The NYT estimator is valid in principle but severely underpowered here.
- CS-NT with controls returns 0/NA — this may indicate a convergence failure or that the controls specification was not run. This is flagged as a potential data issue.
- CS-NYT with controls (2.452, SE 2.705) is not significant but directionally consistent.

### 3. Pre-trend Assessment (CS-NT Event Study)

| Period | CS-NT Coef | SE | t-stat |
|--------|-----------|-----|--------|
| −6 | 0.936 | 1.138 | 0.82 |
| −5 | 1.269 | 1.243 | 1.02 |
| −4 | 0.558 | 1.351 | 0.41 |
| −3 | −0.346 | 1.581 | −0.22 |
| −2 | 0.043 | 1.198 | 0.04 |

No significant pre-trends. **Pre-trends look flat for CS-NT.** However, t=−5 has the largest absolute t-stat (1.02), not quite alarming but slightly elevated — worth monitoring.

### 4. CS-NYT Event Study

| Period | CS-NYT Coef | SE | t-stat |
|--------|------------|-----|--------|
| −6 | −0.272 | 1.586 | −0.17 |
| −5 | 0.715 | 1.343 | 0.53 |
| −4 | −0.590 | 1.651 | −0.36 |
| −3 | −0.175 | 1.405 | −0.12 |
| −2 | −0.556 | 1.461 | −0.38 |

Post-treatment CS-NYT: t=0 (1.714, SE 1.343), t=1 (−0.440, SE 1.998), t=2 (2.579, SE 2.454), t=3 (4.225, SE 4.589), t=4 (0.890, SE 5.787), t=5 (−0.308, SE 3.431). The CS-NYT post-treatment pattern is extremely noisy and non-monotone, consistent with near-empty not-yet-treated pools for cohorts 1970–1973.

### 5. Cohort Imbalance Concern (WARN)

The metadata notes: 1967 cohort = 85% of treated units; 1970–1973 cohorts < 1% each. This creates **severe cohort imbalance** in CS aggregation:

- CS-NT simple ATT is dominated by the 1967 cohort's ATT, which may not represent the population-level average treatment effect across all cohorts.
- The aggregated "simple ATT" implicitly up-weights later cohorts that have very few observations, potentially unstable.
- More precisely: the CS-NT simple ATT weights cohort-time pairs by cohort size. With 85% in the 1967 cohort, the simple ATT should be dominated by 1967 — which is actually a well-identified comparison. The concern is the reverse: the dynamic ATT equally weights each time period, regardless of cohort composition, potentially mixing very noisy late-cohort estimates into the aggregate.

### 6. Missing Controls Issue

`att_cs_nt_with_ctrls = 0` and `se_cs_nt_with_ctrls = NA` is anomalous. A value of exactly 0 with NA SE typically indicates the model did not converge or controls were dropped. This warrants investigation — the with-controls CS-NT specification may have failed silently.

---

## Summary

CS-NT delivers the most credible estimate (0.995, SE 0.404, t=2.46) and is statistically significant, providing stronger evidence than TWFE for the desegregation effect. CS-NYT is underpowered due to near-empty not-yet-treated pools. The cs_nt_with_ctrls returning 0/NA is a data integrity flag. The cohort imbalance (85% in 1967) means the aggregate CS-NT ATT is dominated by one cohort.

**Verdict: WARN** — CS-NYT severely underpowered (SE 5x larger than CS-NT), cs_nt_with_ctrls anomalous (0/NA), and cohort imbalance means aggregate ATT is dominated by a single cohort group.
