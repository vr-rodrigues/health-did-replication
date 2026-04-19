# CS-DiD Reviewer Report: Article 234 — Myers (2017)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Group-time ATT identification
- CS-DID group variable (`gvar_CS`) identifies first-treatment cohort (binary discretization of continuous treatment).
- 9 treatment cohorts (1942–1956), 3 never-treated states (29, 31, 56).
- The discretization from continuous to binary for CS identification is a legitimate and necessary methodological choice — CS-DID requires a binary "ever treated" group variable.

### 2. Comparison group
- Never-treated (NT): att_csdid_nt = +0.00267, se = 0.00970 — null.
- Not-yet-treated (NYT): att_csdid_nyt = +0.00368, se = 0.00888 — null.
- Both comparison groups yield consistent null results. PASS.

### 3. Simple vs dynamic aggregation
- att_nt_simple = -0.01270, se = 0.01544 — null.
- att_nt_dynamic = -0.03261, se = 0.02430 — null but larger in magnitude.
- att_nyt_simple = -0.00661, se = 0.01329 — null.
- att_nyt_dynamic = -0.02245, se = 0.02091 — null.
- WARN: Dynamic (event-study) aggregation yields larger negative point estimates than simple aggregation, especially for NT (-0.033 vs -0.013). This could indicate heterogeneous treatment timing effects, but all are within noise.
- The sign of simple/dynamic aggregation (negative) is opposite to the aggregate CSDID ATT (positive +0.00267). This apparent inconsistency arises because the ATT aggregates group-time cells differently than the event-study dynamic aggregation.

### 4. Unbalanced panel handling
- `allow_unbalanced: false` for main spec but `cs_allow_unbalanced: true` for CS-DID.
- This asymmetry is by design — CS-DID can accommodate unbalanced panels with appropriate adjustments.
- The 49-state × 24-cohort panel is balanced after pre-aggregation, so this should not cause issues.

### 5. Controls
- `cs_controls: []` — no controls in CS-DID, consistent with no TWFE controls.
- `cs_cluster: state` — appropriate.

### 6. Pre-trends (CS-NT event study)
- CS-NT pre-period coefficients:
  t=-6: +0.0036, t=-5: -0.0055, t=-4: -0.0045, t=-3: +0.0086, t=-2: -0.0107
- No systematic trend. All pre-periods small relative to SEs (~0.013). PASS.

### 7. Sign divergence from TWFE
- TWFE: -0.0033 (negative).
- CSDID-NT aggregate: +0.0027 (positive).
- CSDID-NYT aggregate: +0.0037 (positive).
- The sign reversal is consistent with the Bacon decomposition showing "Earlier vs Later Treated" weights pulling the TWFE negative. However, all estimates are statistical zeros.
- WARN: Sign reversal across estimators, even if all null, signals heterogeneous treatment effects across cohorts.

### 8. Discretization of continuous treatment
- WARN: Converting continuous epillconsent18 to binary for gvar_CS means CS-DID estimates the effect of "ever having any pill consent" not the dose-response. This is a different estimand from TWFE.
- The comparison is therefore not apples-to-apples — TWFE estimates slope w.r.t. continuous dose, CS-DID estimates binary adoption ATT.

## Summary
- Null results confirmed under both NT and NYT comparison groups.
- Pre-trends clean.
- Sign reversal vs TWFE and dynamic vs simple aggregation inconsistency both warrant noting.
- Fundamental estimand mismatch (continuous TWFE vs binary CS) is a structural design issue.

**Verdict: WARN** — sign reversal vs TWFE, dynamic/simple aggregation inconsistency, and estimand mismatch (continuous vs binary) all merit flagging, though all estimates are null.
