# CS-DID Reviewer Report — Article 254

**Article:** Gandhi et al. (2024) — The Effect of Medicaid Reimbursement Rates on Nursing Home Staffing
**Verdict:** WARN
**Date:** 2026-04-18

---

## Checklist

### 1. CS-DID applicability
- Treatment timing is single (Q3 2022). Callaway-Sant'Anna is applicable but is operating as a DiD-with-single-cohort estimator rather than in its full staggered-adoption mode. In this setting CS-NT and TWFE are expected to produce similar estimates, which is confirmed: TWFE = 5.491, CS-NT = 5.693 (difference < 0.2 nursing hours/resident, well within sampling uncertainty).

### 2. Comparison group: Never-treated
- `run_csdid_nyt = false` (correct — treatment is non-staggered, so not-yet-treated comparison group is not applicable).
- `run_csdid_nt = true`: Control group is non-Illinois nursing homes. These are "never treated" in the sense that they did not receive the Illinois Medicaid reform. This is the appropriate comparison group.

### 3. Data structure for CS-DID
- CS-DID is run on **quarterly aggregated** data (weekly → quarterly), as noted in metadata `legacy_reason`. This produces only 3 pre-periods and 4 post-periods (vs. 9+ pre-periods for weekly TWFE). The aggregation is necessary for computational tractability but reduces pre-trend resolution.
- The quarterly aggregation introduces a potential smoothing bias if treatment effects are highly non-linear within quarters. The event study plot shows a roughly linear ramp-up, so this is unlikely to be severe.

### 4. Group-time ATT coherence
- With a single cohort (all treated units adopt in Q3 2022), CS-NT reduces to a standard 2x2 DiD, and the aggregate ATT is well-defined.
- ATT (CS-NT) = 5.693, SE = 0.915. This is statistically significant (t ≈ 6.2) and close to TWFE (5.491). The slight upward revision in CS-NT vs. TWFE is consistent with theoretical expectations (NT removes never-treated from comparison group, may clean up composition effects).

### 5. Pre-trend assessment for CS-DID
- The event study plot shows CS-NT pre-trends are flat for the 3 available quarterly pre-periods, consistent with parallel trends.
- The limited number of pre-periods (3) relative to TWFE (9+) is a structural limitation of the quarterly aggregation.

### 6. Concerns
- **WARN — Aggregation from weekly to quarterly:** The CS-DID is run on quarterly aggregated data while the TWFE is run on weekly data. This creates an asymmetry in the comparison. The CS-DID estimate reflects quarterly variation, while the TWFE estimate reflects weekly variation. The estimates are close, suggesting this does not materially distort results, but the aggregation is an analyst choice not validated against the paper's original frequency.
- **WARN — Discretized treatment:** Same as TWFE — CS-DID is estimated on the binary high-Medicaid split, not the paper's continuous treatment. CS-NT ATT is therefore an approximation.
- No controls are included (consistent with metadata), which is appropriate for the binary-split subgroup analysis.

### 7. CS vs TWFE comparison
- Ratio: CS-NT / TWFE = 5.693 / 5.491 = 1.037. The two are virtually identical, as expected for a single-cohort, single-adoption design. This is reassuring: there is no evidence of TWFE bias from treatment effect heterogeneity across groups, since there is only one group-time cohort.

---

## Summary
CS-DID produces an ATT nearly identical to TWFE (within ~3.7%), consistent with the single-cohort design. The main concerns are the quarterly aggregation (limiting pre-period resolution) and the discretized treatment. These are inherited from the study design choices in metadata, not methodological errors in the CS-DID implementation itself.

**Verdict: WARN** — Two concerns: (1) weekly-to-quarterly aggregation for CS vs. weekly for TWFE creates asymmetry; (2) binary treatment discretization is an analyst approximation. Neither invalidates the estimate.

---

*Full report. See also: [reviews/twfe-reviewer.md](twfe-reviewer.md)*
