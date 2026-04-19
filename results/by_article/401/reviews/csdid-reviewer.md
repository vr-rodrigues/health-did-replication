# CS-DID Reviewer Report: Article 401 — Rossin-Slater (2017)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Estimator applicability
- Data structure: repeated_cross_section (RCS); treatment_timing: staggered
- CS-DID is applicable to RCS data via the "repeated cross-sections" variant (Callaway & Sant'Anna 2021, Section 4)
- CS-NYT (not-yet-treated) is appropriate here because all 44 states eventually adopt
- CS-NT (never-treated) is conceptually inappropriate: there are no never-treated units
  - Our att_csdid_nt = -0.0026 (SE 0.0138) — appears degenerate/near-zero, reflecting the absence of a valid comparison group
  - This estimator should be interpreted with extreme caution

**Status: WARN** — CS-NT is invalid (no never-treated units); estimate is effectively meaningless

### 2. Magnitude divergence between TWFE and CS-NYT
- TWFE ATT: -0.0285
- CS-NYT ATT: -0.0024 (se=0.0157)
- Ratio: TWFE is ~12x larger in magnitude than CS-NYT
- CS-NT ATT: -0.0026 (se=0.0138) — essentially zero

This is a substantial and substantively important divergence. Possible explanations:
a) Heterogeneous treatment effects across cohorts, with TWFE weighting earlier cohorts more
b) The absence of controls in CS estimator (cs_controls = []) vs 33 controls in TWFE — the marriage outcome is heavily confounded by demographics and economic conditions
c) Forbidden comparisons in TWFE inflating the static ATT estimate

The dynamic CS-NT estimates are also near-zero across all post-periods. The Gardner/BJS event study also shows non-negligible post-period effects (t=1: -0.023, t=2: -0.014) that are larger than CS-NYT.

**Status: WARN** — large TWFE/CS-DID divergence (12x); no-controls CS-DID under-specifies the model

### 3. Pre-trend test (CS estimators)
CS-NT pre-periods from event_study_data.csv:

| Period | CS-NT Coef | CS-NT SE |
|--------|------------|----------|
| t=-6   | +0.023     | 0.028    |
| t=-5   | -0.043     | 0.025    |
| t=-4   | +0.013     | 0.024    |
| t=-3   | +0.012     | 0.018    |
| t=-2   | +0.024     | 0.018    |

CS-NT shows mixed pre-trend (large negative at t=-5: -0.043). CS-NYT also shows elevated pre-period coefficients (t=-2: +0.038, t=-5: -0.024). These are noisy but warrant attention.

**Status: WARN** — elevated CS-NT pre-period at t=-5 (-0.043, SE=0.025) and t=-2 (+0.024, SE=0.018)

### 4. Controls specification gap
- TWFE uses 33 time-varying controls (demographics, economic conditions, policy variables)
- CS estimator uses no controls (cs_controls = [])
- This asymmetric specification is a primary driver of the 12x magnitude gap
- Ideally, key controls (unemp_rate_lag1, pov_rate_lag1) should be included in CS estimator

**Status: WARN** — controls asymmetry inflates TWFE/CS gap

### 5. Summary
Three WARNs: (1) CS-NT is invalid for all-eventually-treated design; (2) 12x magnitude gap between TWFE and CS-NYT driven partly by controls asymmetry; (3) CS pre-trend noise particularly at t=-5. The true ATT for married_tobiodad appears closer to zero than TWFE suggests once heterogeneous treatment timing is properly accounted for.

## References
- Full results: `results/by_article/401/results.csv`
- Event study data: `results/by_article/401/event_study_data.csv`
