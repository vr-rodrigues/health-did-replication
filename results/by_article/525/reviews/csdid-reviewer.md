# CS-DID Reviewer Report — Article 525
# Danzer & Zyska (2023) — Pensions and Fertility: Microeconomic Evidence

**Verdict:** WARN
**Date:** 2026-04-18

---

## Checklist

### 1. Cohort (gvar) construction

- `gvar_CS` is constructed as: `df$gvar_CS <- as.numeric(ifelse(df$TREAT == 1, 1992, 0))`
- Treatment group (rural workers) → gvar = 1992 (first treatment year)
- Control group (urban workers) → gvar = 0 (never treated)
- `as.numeric()` is correctly used (not `as.integer()`), consistent with Pattern 43 resolution rule.
- With `treatment_timing = "single"`, all treated units adopt in the same cohort (1992). This is a degenerate staggered case — there is only one cohort. CS-DID is still valid and well-defined in this case; `att_gt` produces ATT(g=1992, t) for each post-treatment year t.

### 2. CS-DID vs TWFE convergence (single cohort)

- With a single treatment cohort and binary never-treated comparison group, CS-DID (NT) is theoretically equivalent to TWFE in large samples. The two estimators should produce very similar ATT estimates.
- `att_csdid_nt = -0.01404` vs `beta_twfe = -0.00776` — these are 81% apart in absolute value.
- `att_nt_simple = -0.01404` (same as att_csdid_nt — consistent since only one cohort)
- `att_nt_dynamic = -0.01404` (same again — no variation across dynamic horizons when one-period aggregation is used)
- **WARN**: The large gap between CS-DID NT (-0.014) and TWFE (-0.008) is unexpected for a single-cohort design. In theory they should be numerically close. Potential explanations:
  a. The TWFE uses `TREAT` as a covariate (not as a FE), while CS-DID uses it implicitly via the gvar grouping. These are different estimators when TREAT is in the regression.
  b. The CS-DID uses `panel=FALSE` (RCS design, row IDs) and the repeated cross-section DRDID estimator, which may handle the group-time comparison differently from TWFE's within-estimator.
  c. The CS controls list is empty (`cs_controls = []`) while TWFE includes TREAT. This means CS-DID is unconditional (no covariates in the propensity score model), whereas TWFE conditions on TREAT. This is the most likely driver of the 81% gap.
  d. The TWFE includes `TREAT` as a continuous covariate that flexibly controls for baseline rural-urban differences, while CS-DID absorbs this through the group structure itself.

### 3. Never-treated group specification

- Control group correctly identified as urban workers (uwb2 == 1, TREAT == 0, gvar == 0).
- `control_group = "nevertreated"` is the appropriate choice since there is no staggered adoption — all treated units adopt in 1992 and urban workers are pure controls.
- No contamination concern (Pattern 25) since all treated units have gvar = 1992, which is within the data window (syear appears to run from ~1981 to 2014, with gaps).

### 4. RCS / panel=FALSE handling

- `data_structure = "rcs"` — correctly set.
- `construct_vars` creates `df$row_id <- seq_len(nrow(df))` — consistent with Pattern 8 resolution (using row-level IDs for RCS CSDID).
- `panel=FALSE` in `att_gt` is the appropriate choice. The DRDID repeated cross-section estimator is used.
- N = 1,442,376 rows. With panel=FALSE and row IDs, each individual is treated as a unique unit — this is correct for survey cross-sections.

### 5. Base period

- `base_period = "universal"` — consistent with project standard (Pattern 26 mandate).
- For a single-cohort design without an event study, the choice of base_period primarily affects pre-period placebo tests. Since `has_event_study = false`, this has minimal impact on the stored ATT.

### 6. SE comparison

- `se_csdid_nt = 0.00764` vs `se_twfe = 0.00284`
- The CS-DID SE is 2.7× larger than the TWFE SE.
- This is plausible: CS-DID with panel=FALSE and bootstrap SEs is less precise than TWFE with cluster-robust SEs at the state level, especially with N = 1.4M observations spread across only 26 state clusters.
- Both estimates are statistically significant: t_TWFE ≈ 2.73, t_CSDID ≈ 1.84 (marginally significant at 10%).
- The loss of significance in CS-DID is a mild concern but not a FAIL — the RCS estimator naturally has wider CIs.

### 7. cs_nt_with_ctrls

- `att_cs_nt_with_ctrls = 0` (stored as 0, with se = NA, status = "OK")
- The stored value of 0 for `att_cs_nt_with_ctrls` with SE = NA is suspicious. This likely indicates that the with-controls CS-DID either failed silently or was not attempted for this article. The "OK" status in `cs_nt_with_ctrls_status` contradicts the zero estimate.
- **WARN**: A stored ATT of exactly 0 with SE = NA in the with-controls specification is a red flag. This warrants investigation to determine whether the controls specification failed (singularity, propensity score failure, Pattern 42 overfitting with state-level dummies) or whether 0 was stored as a placeholder.

### 8. cs_nyt status

- `cs_nyt_with_ctrls_status = "NOT_ATTEMPTED"` — consistent with `run_csdid_nyt = false` in metadata. Correct, since treatment_timing = "single" (no not-yet-treated comparison needed).

---

## Summary of findings

| Check | Status |
|---|---|
| gvar_CS construction correct | PASS |
| Never-treated group identification | PASS |
| RCS/panel=FALSE handling | PASS |
| base_period="universal" | PASS |
| ATT sign matches TWFE | PASS (both negative) |
| CS-DID vs TWFE magnitude gap (81%) | WARN |
| SE inflation vs TWFE (2.7×) | WARN (expected but notable) |
| att_cs_nt_with_ctrls = 0 with NA SE | WARN |

**Overall Verdict: WARN** — The CS-DID NT estimate is directionally consistent with TWFE (both negative) but substantially larger in magnitude (-0.014 vs -0.008, 81% gap). For a single-cohort design this gap is larger than expected. The most likely cause is the absence of covariates in the CS-DID model while TWFE includes the TREAT group indicator. Additionally, the stored `att_cs_nt_with_ctrls = 0` with SE = NA is unexplained and warrants investigation.
