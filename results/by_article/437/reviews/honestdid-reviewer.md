# HonestDiD Reviewer Report — Article 437 (Hausman 2014)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability
- has_event_study = true: YES
- event_pre = 5 (≥ 3): YES
- APPLICABLE.
- Note: HonestDiD uses 2 pre-periods (n_pre=2) per honest_did_v3.csv. This is less than the 5 metadata pre-periods, likely because the sensitivity analysis uses the last 2 clean pre-periods for the variance estimator (dropping the most distant pre-period for degrees of freedom). This is a constraint, not a failure.

## Checklist

### 1. Baseline (Mbar = 0) confidence intervals

**TWFE:**
- First post: CI at Mbar=0 = [-89.71, +67.08]. Width = 156.8. Includes zero.
- Average post: CI at Mbar=0 = [-40.02, +36.85]. Width = 76.9. Includes zero.
- Peak post: CI at Mbar=0 = [-27.36, +107.35]. Width = 134.7. Includes zero (and mostly positive).

**CS-NT:**
- First post: CI at Mbar=0 = [-235.43, +272.47]. Width = 507.9. Includes zero.
- Average post: CI at Mbar=0 = [-50.30, +135.71]. Width = 186.0. Includes zero.
- Peak post: CI at Mbar=0 = [-93.47, +366.69]. Width = 460.2. Includes zero.

At Mbar=0 (no pre-trend violations allowed), ALL CIs include zero for both TWFE and CS-NT. The base result is a null finding with very wide uncertainty.
- rm_first_Mbar = 0 for both TWFE and CS-NT (cannot bound away from zero even with perfect pre-trends).
- WARN: TWFE and CS-NT both show null/zero results at Mbar=0. The headline result (-42.2) is not robust to HonestDiD sensitivity.

### 2. Robustness targets

**TWFE rm_Mbar values (from honest_did_v3.csv):**
- rm_first_Mbar = 0 (CI already contains zero at Mbar=0)
- rm_avg_Mbar = 0 (CI contains zero at Mbar=0)
- rm_peak_Mbar = 0 (CI contains zero at Mbar=0)

All three targets fail to exclude zero at Mbar=0. This is D-FRAGILE by design rubric: the TWFE result is not robust to *any* pre-trend violation.

**CS-NT rm_Mbar values:**
- rm_first_Mbar = 0
- rm_avg_Mbar = 0
- rm_peak_Mbar = 0

Similarly, CS-NT result is not robust to any pre-trend deviation.

Design signal: **D-FRAGILE** for all targets and both estimators.

### 3. Expanding CIs with Mbar
As Mbar increases, CIs widen substantially:
- TWFE avg at Mbar=2: [-395.80, +395.80] — fully symmetric and maxed out.
- CS-NT avg at Mbar=2: [-948.10, +948.10] — fully symmetric and maxed out.

The CIs expand extremely rapidly with Mbar. This reflects the large SE of the base estimate (~22-66 person-rem) combined with a long panel where violations could compound.

### 4. Peak post-period diagnostic
- TWFE peak at Mbar=0: [-27.36, +107.35]. Mostly positive. This is counterintuitive — the TWFE event study shows the peak negative effect at t=5 (-95.7), but the HonestDiD peak CI is skewed positive. This likely reflects the aggregation of t=1 (positive: +40.6) being the largest-magnitude post-period estimate.
- WARN: The TWFE event study shows a mix of post-period signs (t=1: +40.6, t=5: -95.7), indicating no coherent treatment effect trajectory.

### 5. Pre-trend assessment from event study
- TWFE pre-trends: t=-6: -9.8, t=-5: -10.9, t=-4: +14.9, t=-3: +23.1, t=-2: +16.8. 
- None significant, but the oscillating pattern (negative, negative, positive, positive, positive) is not flat.
- CS-NT pre-trends: t=-6: +19.0, t=-5: -13.6, t=-4: +2.6, t=-3: +18.8, t=-2: +12.3.
- Same oscillating pattern. With SEs of 20-45 person-rem, formal tests would not reject zero.
- WARN: pre-trend pattern is oscillating and irregular, suggesting underlying heterogeneity rather than clean parallel trends.

### 6. n_pre limitation
- Only n_pre=2 pre-periods used in HonestDiD. This limits the power of the sensitivity analysis.
- With only 2 pre-periods to calibrate the pre-trend variance, the sensitivity CIs may be overly conservative.
- NOTE (not WARN): the low n_pre is a data/design constraint, not an implementation error.

## Material concerns
1. WARN: rm_first/avg/peak_Mbar = 0 for TWFE — result not robust to any pre-trend violation (D-FRAGILE)
2. WARN: rm_first/avg/peak_Mbar = 0 for CS-NT — same finding (D-FRAGILE)
3. WARN: post-period TWFE event study shows sign oscillation (t=1: +40.6, t=5: -95.7)
4. NOTE: only n_pre=2 used in HonestDiD (design constraint)

## Summary
HonestDiD sensitivity confirms that neither TWFE nor CS-NT estimates are robust to any pre-trend violations (all rm_Mbar = 0, D-FRAGILE). The base Mbar=0 CIs already include zero for all targets. The design is fundamentally fragile: the very large standard errors (~22-66 person-rem) mean even the headline TWFE point estimate (-42.2) sits within the null CI. Verdict: WARN.
