# CS-DID Reviewer Report: Article 281 — Steffens, Pereda (2025)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. CS-DID configuration
- Estimator: CSDID with never-treated comparison group (`run_csdid_nt = true`).
- Not-yet-treated estimator: correctly NOT run (`run_csdid_nyt = false`) — appropriate because `treatment_timing == "single"`: with only one treatment cohort (2009), there is no variation in timing to exploit a not-yet-treated control group.
- `gvar_CS`: 2009 for treated states, 0 for never-treated. Correctly structured.
- Controls: none (matching TWFE spec).

### 2. ATT estimates
- `att_csdid_nt = 0.000314` (se = 0.00644): near-zero, statistically insignificant (t ≈ 0.05).
- Simple aggregation: `att_nt_simple = 0.000314` (se = 0.00652), consistent.
- Dynamic aggregation: `att_nt_dynamic = 0.000314` (se = 0.00644), consistent.
- CS-NT event study pre-periods: t=-4: -0.0112 (se=0.0079), t=-3: -0.0019 (se=0.0065), t=-2: -0.0019 (se=0.0050). No pre-period is statistically significant. The pattern is noisier than TWFE but does not show systematic violation.

### 3. TWFE vs CS-DID comparison
- TWFE ATT: 0.00240; CS-NT ATT: 0.000314. The difference is small (0.0021 pp) and both are statistically zero.
- With single-timing design (one cohort only), TWFE and CSDID should be numerically close — the small divergence is expected from different variance estimation approaches and weighting.
- No sign reversal between TWFE and CS-DID: both point in the same direction (positive, negligible).

### 4. Comparison group validity
- Never-treated comparison group: states that never adopted the 2009 ban AND were not excluded as 2008/2010/2011 adopters. This is a valid comparison set.
- With the synthetic panel construction, all synthetic observations for never-treated states serve as controls. The design is internally consistent.

### 5. Flags
- PASS: CS-DID correctly specified for single-timing design.
- PASS: ATT estimates are consistent across simple and dynamic aggregation.
- PASS: No meaningful divergence from TWFE (small, as expected with single cohort).
- NOTE: The synthetic panel structure affects CS-DID inference similarly to TWFE — clustering at `uf` is the correct response, and CS-DID uses influence-function-based SEs clustered at `uf`.

## Summary
The CS-DID implementation is correct and internally consistent with the single-timing design. ATTs from never-treated comparison are near-zero and insignificant, matching the TWFE conclusion. No methodological concerns specific to CS-DID.

Full data: `results/by_article/281/results.csv`, `results/by_article/281/event_study_data.csv`
