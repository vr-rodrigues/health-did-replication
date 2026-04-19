# CS-DID Reviewer Report — Article 79 (Carpenter & Lawler 2019)

**Verdict:** WARN

**Date:** 2026-04-18

---

## Checklist

### 1. Data structure compatibility

- `data_structure`: `repeated_cross_section` — CS-DID implemented correctly via `panel=FALSE` (Pattern 8).
- `treatment_timing`: `staggered` — CS-DID is warranted.
- Units: U.S. states (fips, ~51), not counties. This is unusual: CS-DID at the state level with NIS survey data means cohort cells can be very small (1 state = 1 unit per cohort-year cell).

### 2. Comparison group specification

- NT (never-treated): `att_csdid_nt` = 0.1559 (results.csv: `att_nt_simple` = 0.1592), SE = 0.0209.
- NYT (not-yet-treated): `att_csdid_nyt` = 0.0901 (results.csv: `att_nyt_simple` = 0.0954), SE = 0.0203.
- These are meaningfully different: NT ATT (0.159) vs. NYT ATT (0.090), a ~43% reduction.

### 3. NT vs. NYT divergence

The metadata notes document this extensively (Pattern 24):
- NT ATT in R (~0.095-0.159) vs. Stata NT (~0.164): difference explained by early cohorts (MN gvar=1996, RI gvar=1999) classified as "already treated at first period" in R's CS implementation, placing them in the NT pool for Stata but dropping them in R.
- Stata NT shows significant pre-trends (Pre_avg = -0.048, p = 0.001), suggesting parallel trends failure for the NT comparison group.
- NYT comparison group passes the pre-trend check: Pre_avg = -0.022, p = 0.143 (insignificant).
- **The NYT estimator is the more credible one for this design.**

### 4. Event study pre-trends: CS-NT vs CS-NYT

From `event_study_data.csv`:

CS-NT pre-periods:
- t=-6: -0.042 (SE=0.040)
- t=-5: -0.031 (SE=0.033)
- t=-4: -0.040 (SE=0.023)
- t=-3: -0.054 (SE=0.017) — notable magnitude
- t=-2: -0.040 (SE=0.011)

CS-NYT pre-periods:
- t=-6: -0.021 (SE=0.034)
- t=-5: -0.012 (SE=0.027)
- t=-4: -0.011 (SE=0.024)
- t=-3: -0.028 (SE=0.019)
- t=-2: -0.033 (SE=0.010)

CS-NT shows more pronounced and somewhat systematic negative pre-trends, especially at t=-3. CS-NYT pre-trends are smaller in magnitude and less systematic. This confirms the metadata note that NYT is the preferred estimator.

### 5. ATT sign consistency

All three estimators agree on sign and order-of-magnitude:
- TWFE: 0.135
- CS-NT: 0.159 (R simple ATT)
- CS-NYT: 0.090
- SA: ~0.112-0.173 range across post-periods
- Gardner: ~0.072-0.168 range

NYT ATT (0.090) is noticeably smaller than TWFE (0.135), suggesting mild positive contamination in TWFE from comparing across cohorts at different stages of treatment.

### 6. Controls in CS-DID

CS controls reduced to `female + married` (from 71 TWFE controls). The metadata notes that many controls cause singularity in `att_gt` cells, which is a known issue with state-level data where cohort cells have few units. This simplification is justified by practical necessity. The doubly-robust estimator with reduced controls is less efficient but still valid if the propensity score model is not misspecified.

### 7. WARN trigger: NT vs NYT divergence + NT pre-trend failure

The divergence between NT and NYT ATT (43% gap) combined with significant pre-trends in the NT comparison group is a methodological concern. The paper relies on CS-DID but the choice of comparison group matters materially here. The NYT estimator (0.090) is more credible but is substantially smaller than the TWFE headline (0.135).

### 8. Cohort-level heterogeneity

From the NYT event study, post-treatment coefficients are not monotone and decay:
- t=0: +0.104, t=1: +0.118, t=2: +0.101, t=3: +0.059, t=4: +0.088, t=5: +0.082, t=6: +0.181

The drop at t=3–5 followed by a jump at t=6 is unusual and may reflect attrition of specific cohorts or sparse data at longer horizons.

---

## Summary

CS-DID is correctly implemented for a repeated cross-section staggered design. The NYT estimator (ATT ≈ 0.090) is the more credible comparison, as the NT pool has significant pre-trends in Stata (Pattern 24). The 43% ATT gap between NT and NYT, and between NYT and TWFE, indicates meaningful treatment effect heterogeneity across cohorts — an important finding. Controls were necessarily reduced to avoid singularity.

**Verdict: WARN** — NT pre-trend failure (parallel trends concern for NT group); NYT is preferred but yields materially lower ATT than TWFE headline.
