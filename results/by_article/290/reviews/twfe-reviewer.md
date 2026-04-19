# TWFE Reviewer Report — Article 290 (Arbogast et al. 2022)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Point estimate fidelity
- beta_twfe (stored) = -0.01824
- beta_twfe (paper target) = -0.01720
- Gap = (-0.01824 - (-0.01720)) / |-0.01720| = 6.05%
- Within 10% tolerance threshold. PASS on fidelity.
- SE stored = 0.006994 vs paper 0.0072 (gap 2.9%). PASS.
- N = 4085 vs paper 4086 (1 obs difference). PASS (rounding/filter).

### 2. Controls and specification
- 8 time-varying state-level controls included: new_redetpause, MedicaidExpansion, cutoffmax, Premlevel_201, Work_Reqs, pov, ur, GSP.
- Unit FE (state) + time FE (newdate) — standard TWFE.
- Cluster: state. Consistent with original paper.
- Note in metadata: IPUMS perwt sums vs Census table estimates explain 6% gap.

### 3. Pre-trend assessment from event study
- TWFE pre-period coefficients (relative to t=-1):
  - t=-6: -0.00666 (se=0.00721)
  - t=-5: -0.00408 (se=0.00246)
  - t=-4: -0.00304 (se=0.00206)
  - t=-3: -0.00293 (se=0.00171)
  - t=-2: -0.00200 (se=0.00134)
- All pre-period coefficients are negative and monotonically growing in magnitude from t=-2 to t=-6.
- This pattern suggests a pre-existing downward trend in Medicaid enrollment that predates treatment adoption — a violation of parallel trends.
- At the conventional significance level, t=-5 is borderline (t-stat = -0.00408/0.00246 = -1.66); t=-6 is (-0.00666/0.00721 = -0.92), not significant.
- Individual pre-periods are not statistically significant at 5%, but the monotonic drift pattern is concerning.

### 4. SA and Gardner cross-validation
- SA pre-trends confirm the pattern: t=-6: -0.00366, t=-5: -0.00363, t=-4: -0.00253, t=-3: -0.00219, t=-2: -0.00156 — monotonically decreasing, very small SE (~0.0006-0.0008).
- SA pre-trend at t=-5 is -0.00363/0.000682 = -5.3 standard errors — HIGHLY SIGNIFICANT.
- SA pre-trend at t=-4 is -0.00253/0.000582 = -4.3 standard errors — HIGHLY SIGNIFICANT.
- Gardner pre-trends are near-zero and not significant (as expected from imputation estimator).
- SA and Gardner diverge substantially in pre-periods, suggesting the TWFE/SA pre-trends reflect genuine pre-existing trends rather than estimation noise.

### 5. Post-period dynamics
- TWFE post-period shows growing negative effects: t=0: -0.0019, t=1: -0.0037, t=2: -0.0075, t=3: -0.0075, t=4: -0.0107, t=5: -0.0296.
- The spike at t=5 (-0.0296) is ~4x larger than t=4, suggesting either a late-treated cohort effect or non-linear adoption dynamics.
- SA post-periods also grow but plateau at -0.012 at t=5 (vs TWFE -0.030) — divergence at t=5.

### 6. Summary
- Point estimate close to paper (6% gap, within tolerance). PASS.
- SA pre-trends are highly significant (t-stats >4 at t=-4 and t=-5) indicating pre-existing negative trend before treatment. WARN.
- Monotonic pre-period drift in TWFE confirms pattern.
- Post-period spike at t=5 warrants attention.

**Overall TWFE Verdict: WARN** (pre-trend drift confirmed by SA; implementation otherwise faithful)
