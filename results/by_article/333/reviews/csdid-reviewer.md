# CS-DID Reviewer Report: Article 333 — Clarke & Muhlrad (2021)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. Estimator configuration
- `run_csdid_nt = true`, `run_csdid_nyt = false` (appropriate: single treatment cohort, never-treated controls are the clean comparison group).
- gvar_CS = 207 (numeric, March 2007), gvar_CS = 0 for never-treated states.
- Comparison group: never-treated (12 states). Not-yet-treated comparison not applicable (no staggered adoption).
- No controls in CS-DID specification (matching baseline TWFE).

### 2. ATT estimates
- ATT_csdid_nt (aggregate, default) = -0.0578, SE = 0.0137
- ATT_nt_simple (simple average) = -0.0578, SE = 0.0130
- ATT_nt_dynamic (dynamic) = -0.0578, SE = 0.0130
- All three aggregation methods agree (as expected with single cohort): simple = dynamic = -0.058.
- TWFE = -0.0636. Ratio: CS-DID/TWFE = 0.91. Gap of ~9%, within acceptable range for a single-cohort design.

### 3. Sign and direction
- CS-DID corroborates the TWFE finding: negative effect of ILE on abortion-related mortality. Direction is consistent.

### 4. Single-cohort implications
- With a single treatment cohort and never-treated controls, CS-DID collapses to a clean 2×2 DID (treated cohort vs. never-treated, post vs. pre). No heterogeneous treatment effect weighting concerns.
- The small difference between TWFE (-0.064) and CS-DID (-0.058) likely reflects differences in the exact pre-period used as the baseline: TWFE uses all pre-periods jointly, CS-DID uses t=-1 as the direct comparison period. Given 36 pre-periods and a non-flat pre-trend, this baseline choice matters at the margin.

### 5. Data quality checks
- Metadata notes: "1716 rows with missing abortionRelated (132 per estado) dropped by att_gt." This is 132 months × 13 states = 1716 rows. This implies all states have the same 132 missing months, which is consistent and non-selective. No concern.
- Pattern 43 fix applied: gvar_CS was previously integer (207L/0L) causing Inf→NA truncation in the did package — corrected to numeric. This is already resolved.

### 6. Comparison with paper
- The paper reports ATT from a panel VAR / TWFE framework rather than CS-DID (CS-DID is our addition). The CS-DID ATT = -0.058 is directionally consistent with the paper's -0.064 and within 1 SE.

## Summary
CS-DID is correctly specified for a single-cohort, never-treated design. The ATT = -0.058 corroborates the TWFE result directionally. No methodological concerns with the CS-DID implementation. The 9% gap between CS-DID and TWFE is small and explainable by baseline period differences. PASS.

**Full report saved to:** `reviews/csdid-reviewer.md`
