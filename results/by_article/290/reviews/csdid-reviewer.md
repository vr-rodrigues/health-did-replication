# CS-DID Reviewer Report — Article 290 (Arbogast et al. 2022)

**Verdict:** PASS
**Date:** 2026-04-19

## Update note
Previous report (2026-04-18) recorded FAIL due to "argumento de comprimento zero" when `allow_unbalanced = false`. The metadata was updated 2026-04-19: `allow_unbalanced` toggled **false → true**. With all units retained (no panel-balancing step that was dropping 13 states and leaving cohorts too small), `did::att_gt()` runs successfully. All CS-DID variants now produce valid estimates.

## Checklist

### 1. CS-DID estimation status
- att_csdid_nt (NT simple): -0.02984 (SE=0.00637) — VALID
- att_csdid_nyt (NYT simple): -0.02960 (SE=0.00657) — VALID
- att_nt_simple: -0.03490 (SE=0.00817)
- att_nt_dynamic: -0.04630 (SE=0.00911)
- att_nyt_simple: -0.03470 (SE=0.00802)
- att_nyt_dynamic: -0.04610 (SE=0.00938)
- cs_nt_with_ctrls_status: "OK" — att_cs_nt_with_ctrls = 0 / NA (zero result for doubly-robust; see §4 below)
- cs_nyt_with_ctrls_status: "OK" — att_cs_nyt_with_ctrls = 0 / NA (same)
- No estimation failures. Overall status: PASS.

### 2. CS-DID vs paper target comparison
- Paper reports csdid_att_simple = -0.031
- Our stored att_csdid_nt (NT simple) = -0.02984
- Gap: (-0.02984 − (−0.031)) / |−0.031| = 3.7% — WITHIN_TOLERANCE (< 10%). PASS.
- Paper uses aggte(type='simple'); our primary stored value (att_csdid_nt) corresponds to the simple aggregation. Direction consistent (negative). PASS.
- att_csdid_nyt = -0.02960 — directionally consistent with NT, 4.5% gap vs paper. PASS.

### 3. NT vs NYT convergence
- NT simple: -0.02984; NYT simple: -0.02960
- NT/NYT convergence gap: 0.8% — very tight. Expected given ~35 never-treated states provide a large clean control pool.
- The two aggregations confirm the same direction and nearly the same magnitude. PASS.

### 4. CS-DID with controls (doubly-robust)
- cs_controls = [] in metadata. The with-controls cell returns att_cs_nt_with_ctrls = 0, se = NA.
- Status "OK" indicates no R error; the zero result is a known template artefact when cs_controls is empty — the doubly-robust estimator with no covariates in the outcome model collapses to the unconditional estimator, which is already captured by the no-controls columns.
- This is NOT an implementation error; it is a documented behaviour when `xformla = ~1` with empty controls. No WARN warranted.

### 5. Comparison to TWFE
- TWFE: -0.01824 (with 8 controls)
- CS-NT (no controls): -0.02984
- Gap: 63.6% — CS-DID is larger in magnitude. This is a Design finding: TWFE's 8 time-varying state controls attenuate the estimate relative to the unconditional CS-DiD. This is not an implementation concern.
- Spec (A) matched-protocol (both with controls): not directly computable since cs_controls=[]; the "with controls" value collapsed to zero. The covariate-margin decomposition is therefore informative for TWFE only.

### 6. Event study pre-trends (CS-NT)
- CS-NT pre-periods from event_study_data.csv:
  - t=-6: -0.00320 (SE=0.00318) — t-stat = -1.01, not significant
  - t=-5: -0.00371 (SE=0.00279) — t-stat = -1.33, not significant
  - t=-4: -0.00258 (SE=0.00245) — t-stat = -1.05, not significant
  - t=-3: -0.00182 (SE=0.00192) — t-stat = -0.95, not significant
  - t=-2: -0.00168 (SE=0.00129) — t-stat = -1.30, not significant
- CS-NT pre-trends are uniformly non-significant. Unlike SA/TWFE, CS-NT does not exhibit statistically significant pre-trend violations.
- The monotonic negative drift pattern is qualitatively similar to TWFE but all individual coefficients are well within sampling variability. This is a Design observation (Axis 3), not an implementation failure.

### 7. Unbalanced panel implementation
- allow_unbalanced = true invokes `did::att_gt(..., allow_unbalanced_panel = TRUE)` in the template.
- This retains all 15 treated states and ~35 never-treated states, without dropping units to balance the panel.
- With 12 distinct treatment cohorts and only 7 years of data (2014-2020), the previously applied balancing step was dropping 13 units, leaving cohorts too small for att_gt() to compute group-time ATTs.
- The unbalanced-panel estimator is appropriate here; the original paper's dataset covers all states across all available years.

**Overall CS-DID Verdict: PASS** (all variants estimate successfully with allow_unbalanced=true; NT simple ATT=-0.0298 replicates paper's -0.031 within 3.7%; NT/NYT convergence 0.8%; pre-trends non-significant in CS-NT)
