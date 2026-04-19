# CS-DID Reviewer Report — Article 47 (Clemens 2015)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Applicability assessment
CS-DID (Callaway & Sant'Anna 2021) is always run. Treatment timing is coded as single cohort: `gvar_CS = 7` (period 7 = year 1996, the first post-treatment wave in the recoded time variable) for treated units, 0 for never-treated. This is a valid single-cohort CS-DID setup; it reduces to a 2×2 ATT for the single group-time pair (g=7, t≥7).

### 2. Data structure concern — repeated cross-section
**WARN flag — repeated cross-section used with CS-DID panel estimator:**
The data structure is `repeated_cross_section`. CS-DID in the `did` package assumes panel data (or at minimum a pseudo-panel structure where `unit_id` tracks the same unit over time). Here `unit_id = state_fips`, so estimation is effectively at the state level — a repeated cross-section collapsed to state×year cells. The individual-level variation within state×year is averaged out before the DiD comparison is made. This is a legitimate approach (the paper's own TWFE uses the same structure), but:
  - The `did` package's influence-function-based SEs assume individual-level panel variation; with state-level effective variation, these SEs may be underestimated (only 3 treated states drive identification).
  - Specifically, our CS-NT SE = 0.01733 vs paper's -0.0148 (SE reported in metadata as 0.0148). The paper's SE for the CS-NT is from a bootstrapped variance estimator. Our IF-based SE of 0.0173 is in the same ballpark (within 17%), suggesting the estimator is consistent but inference should use bootstrap with few clusters.

### 3. Comparison group
- `run_csdid_nt = true`, `run_csdid_nyt = false`. Never-treated comparison is correct given treatment_timing = "single" (all treated states adopt in the same period; there are no "not-yet-treated" units).
- Controls: `cs_controls = []` (empty — no additional covariates passed to CS-DID beyond the conditioning built into the group×time comparisons). This is a deliberate choice: the paper's CS-DID runs without the full demographic control vector used in TWFE, relying instead on the unconditional parallel trends assumption for the CS estimate. This is consistent with the metadata note.

### 4. Point estimate comparison
- Our ATT (CS-NT, simple): -0.12429, SE = 0.01784
- Our ATT (CS-NT, dynamic): -0.12429 (same — single post cohort collapses to single estimate), SE = 0.01752
- Paper's CS-NT: -0.12480, SE = 0.0148
- Gap: 0.4% — well within tolerance. The near-exact match confirms the group-time cell structure is correctly identified.

### 5. Pre-trend from CS-NT event study
The CS-NT event study shows:
- t=-5: coef = -0.0469, SE = 0.0129 (t ≈ 3.6, p < 0.001)
- t=-4: coef = -0.0006, SE = 0.0137 (insignificant)
- t=-3: coef = +0.0211, SE = 0.0160 (insignificant)
- t=-2: coef = +0.0170, SE = 0.0190 (insignificant)

The t=-5 pre-period coefficient is large (-4.7 pp) and statistically significant. This is consistent with the TWFE pre-trend finding and reinforces the parallel trends concern at the earliest horizon. The pattern of a large t=-5 dip followed by return toward zero at t=-4 to t=-2 may reflect NJ's specific market distortions in the late 1980s (the paper discusses this), but it remains a pre-trend flag for the CS estimator as well.

### 6. Direction agreement with TWFE
CS-NT ATT = -0.1243, TWFE beta = -0.0962. CS estimate is approximately 29% larger in magnitude than TWFE. Given the single-cohort design, TWFE and CS-DID should theoretically produce identical estimates if using the same comparison group and no controls. The divergence (~3 pp) reflects:
  - CS-DID uses no controls; TWFE uses the full demographic vector
  - Different weighting schemes (CS uses equal-weight ATT across group-time; TWFE weights by variance)
Both estimates are directionally consistent (negative, significant), and both imply coverage decreased substantially in community-rating states post-regulation.

### 7. Summary
CS-DID correctly implemented as a single-cohort design. Primary WARN: the t=-5 pre-period coefficient is statistically significant in both TWFE and CS-NT event studies, raising a modest parallel trends concern. The repeated cross-section structure means inference should be treated with caution (few effective clusters). Directional conclusion is robust across both estimators.

## References
- results.csv: CS-NT estimates
- event_study_data.csv: CS-NT pre-period pattern
- metadata.json: gvar_CS construction

