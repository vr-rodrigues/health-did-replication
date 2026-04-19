# TWFE Reviewer Report — Article 133 (Hoynes et al. 2015)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Treatment variable specification
- Treatment variable: `Post_avg` = `treat1 * after`, where `treat1` identifies EITC-eligible families and `after = 1(1994–1998)`.
- This is a correctly specified interaction indicator for a difference-in-differences design with a single treatment cohort (1994 expansion).
- Single timing: no staggered adoption concerns. **PASS**

### 2. Fixed effects and controls
- Unit FE: `stateres` (state of residence). **PASS**
- Time FE: `effective` (year). **PASS**
- Additional FE: `parvar` (parity × marital × education cell). **PASS**
- Controls: 10 covariates (`treat1`, `after`, `other`, `black`, `age2`, `age3`, `high`, `racemiss`, `hispanic`, `hispanicmiss`). **PASS**
- Weights: `cellnum` (cell size). **PASS**

### 3. Coefficient magnitude and comparison
- Our TWFE estimate: beta = -0.3868 (se = 0.0826)
- Paper's reported TWFE: beta = -0.3549 (se = 0.0746)
- Absolute difference: 0.0320 pp (low birthweight rate in pp)
- Relative divergence: ~9.0%
- Divergence plausibly explained by sample composition differences or weighting implementation; same sign and significance. **WARN** (>5% but <15% divergence threshold; see fidelity axis)

### 4. Pre-trend assessment (from event_study_data.csv)
- t = -3: coef = +0.094, se = 0.095 → t-stat ≈ 0.99, p ≈ 0.32. Not significant.
- t = -2: coef = +0.061, se = 0.068 → t-stat ≈ 0.90, p ≈ 0.37. Not significant.
- Both pre-period coefficients are positive (slight upward pre-trend for treated relative to control), but statistically indistinguishable from zero at conventional levels.
- No formal joint pre-trend test available in stored data; visual evidence suggests mild but non-significant pre-trend. **WARN** (positive pre-trends could indicate slight violation of parallel trends; magnitudes are small relative to post-period effects)

### 5. Post-period pattern
- Coefficients grow monotonically in absolute value: t=0: -0.132, t=1: -0.226, t=2: -0.290, t=3: -0.445, t=4: -0.564. This increasing effect over time is plausible for a policy affecting income, consistent with the paper's narrative.

### 6. Model coherence
- Single-cohort design: TWFE collapses to a clean 2×2 DID. No contamination from heterogeneous timing. **PASS**
- Clustering at state level. **PASS**

## Summary of flags
- WARN on coefficient divergence (~9%) from the paper's reported value.
- WARN on mild positive pre-trends (t=-3, t=-2), though not statistically significant.

## Overall TWFE verdict: WARN
