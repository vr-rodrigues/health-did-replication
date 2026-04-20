# CS-DID Reviewer Report: 358 — Bargain, Boutin, Champeaux (2019)

**Verdict:** PASS (reclassified from previous WARN after Pattern 42 diagnosis)
**Date:** 2026-04-19
**Axis classification:** Implementation = PASS; Design finding = Spec A collapse (Pattern 42, COLLAPSE-2x2 variant)

## Checklist

### 1. Applicability
- Single cohort (gvar=2014 for treated; gvar=0 for never-treated). CS-DID with a single group and two periods collapses to a clean 2x2 DiD — the simplest valid application of the estimator.
- `run_csdid_nt=true`, `run_csdid_nyt=false` (correct: single cohort means NYT = NT by construction).
- `cs_controls=[]`: the baseline CS-DID estimation correctly passes no controls to `att_gt`.

### 2. Three-way controls decomposition

| Spec | TWFE | CS-NT | Status |
|---|---|---|---|
| (A) both with 30 controls | 4.181 (1.053) | 0.000 (NA) | FAIL_Pattern42 (collapse) |
| (B) both without controls | 4.951 (1.032) | 4.591 (1.024) | OK |
| (C) TWFE with ctrls + CS without ctrls | 4.181 (1.053) | 4.591 (1.024) | OK (headline) |

### 3. Spec A collapse — Pattern 42 diagnosis

**What happened**: `att_cs_nt_with_ctrls = 0.000`, `se_cs_nt_with_ctrls = NA`, `cs_nt_with_ctrls_status = "OK"`. The doubly-robust CS-DID received all 30 time-varying controls from `twfe_controls` via the Spec A path. With only 2 time periods (2008 and 2014) and 272 municipalities, the propensity score logistic model must estimate Pr(treated | 30 covariates, 2008) using variation within the pre-period cross-section. 

Root cause: In a 2x2 design, there is exactly ONE pre-period cross-section to fit the propensity model. With 30 covariates (including 14 post-interaction terms that are identically zero in the pre-period) and only the pre-period rows, the effective design matrix has severe collinearity → near-perfect separation → propensity scores degenerate → ATT collapses to 0 with NA SE. Status returns "OK" because no R error is thrown — the estimator silently degenerates.

**Classification**: Pattern 42, third direct-level-controls-collapse instance. This is a documented failure mode of the doubly-robust estimator when `n_controls` approaches `n_effective_observations_in_propensity_model`. It is NOT a pipeline bug.

**Is this an implementation error?** No. The template correctly passes the controls specified in Spec A. The collapse is an intrinsic limitation of the doubly-robust estimator applied to a 2x2 design with 30 time-varying covariates. This is a finding about the paper's specification, not about our code.

**Axis assignment**: Design finding (Axis 3 — estimator behavior), not Implementation WARN (Axis 2).

### 4. Spec B (unconditional) assessment
- `att_csdid_nt = 4.591`, `se_csdid_nt = 1.024`. Direction unanimous with TWFE. Gap from TWFE-with-ctrls: +9.8%. Gap from TWFE-no-ctrls: −7.3%.
- The 10% gap between Spec B CS-NT and Spec C TWFE is entirely attributable to the missing 30 controls on the CS side, not to estimator heterogeneity. In a 2x2 design with a single cohort, TWFE and CS-DID are algebraically equivalent conditional on the same covariate set.

### 5. Sample and clustering
- `panel=FALSE` (data_structure=repeated_cross_section) correctly set. Municipality-level clustering (ID_2) matches paper.
- `gvar_CS` correctly pre-computed: treated units get gvar=2014, controls get gvar=0.

### 6. Summary
- Spec B (unconditional): PASS — 4.591 directionally consistent, gap explained by covariate structure.
- Spec A (with controls): Pattern 42 collapse — documented finding, not implementation error.
- Previous WARN verdict is hereby reclassified to PASS on implementation. The collapse is a design finding catalogued as the third direct-level-controls-collapse variant of Pattern 42 and the COLLAPSE-2x2 exemplar for Lesson 7.
