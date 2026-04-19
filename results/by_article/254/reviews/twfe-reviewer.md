# TWFE Reviewer Report — Article 254

**Article:** Gandhi et al. (2024) — The Effect of Medicaid Reimbursement Rates on Nursing Home Staffing
**Verdict:** WARN
**Date:** 2026-04-18

---

## Checklist

### 1. Treatment variable construction
- The paper's main specification uses a **continuous treatment**: `illinois * (mcaid_share2019/100)`, interacted with `post`. Our reanalysis discretizes this into a binary treatment: high-Medicaid IL facilities (above-median Medicaid share, n=342 CCNs) vs. non-IL controls. This is an analyst-constructed approximation, not the paper's main estimand.
- The treatment timing is single (Q3 2022, first post-bubble quarter). There is no staggered adoption problem for TWFE in this design.
- The bubble period (Jan–Jun 2022) is correctly excluded per original authors' specification.

### 2. Fixed effects and clustering
- The original paper uses facility FE (absorbed via `areg` / `reghdfe`) and week FE, clustering by CCN. Our implementation follows this: unit FE = `ccn`, time FE = `wk_end_mdy`, cluster = `ccn`. This is correctly specified.

### 3. TWFE point estimate and standard error
- TWFE (pooled): beta = 5.491, SE = 0.581. This represents the average effect across high-Medicaid IL facilities relative to non-IL controls in the post period.
- High-Medicaid subgroup: beta = 8.843, SE = 0.685.
- Low-Medicaid subgroup: beta = 1.720, SE = 0.894.
- The gradient (high > pooled > low) is internally consistent with the dose-response hypothesis.

### 4. Parallel trends plausibility
- The event study (event_study.pdf) shows approximately flat pre-trends across ~28 pre-treatment weeks for all four estimators (TWFE, CS-NT, SA, Gardner). Pre-period coefficients are close to zero and visually indistinguishable from zero. This supports the parallel trends assumption.
- The CS-NT event study only has 3 pre-periods (quarterly aggregation) vs. 9+ weekly pre-periods in TWFE, limiting pre-trend resolution for CS-NT but not for TWFE.

### 5. Treatment effect dynamics
- Post-treatment effects show a monotonically increasing trajectory from ~5 units at week +1 to ~11 units at week +25. This is consistent with gradual adjustment of nurse staffing levels (ramp-up effect), not an instantaneous jump.
- The dynamic pattern is broadly consistent across all estimators, suggesting TWFE is not distorted by heterogeneous treatment timing (as expected for a single-adoption design).

### 6. Specification concerns
- **WARN — Discretization mismatch:** The stored `beta_twfe` (5.491) reflects a binary high/low split, not the paper's continuous-treatment DiD coefficient. The two are not directly comparable. This is noted in metadata.json `notes` field, but the analyst-created binary treatment introduces an approximation that may understate or overstate the true ATT for the paper's actual estimand.
- The control group (non-IL nursing homes nationwide) is plausible as a comparison group but is not strictly a "never-treated" group in a staggered sense — they are simply states that did not receive the Illinois Medicaid rate reform.
- No controls are included in either TWFE or CS-NT (as per the original paper's main specification for this subsample analysis). This is consistent with metadata.json `twfe_controls: []`.

### 7. Pre-trend tests
- Visual inspection: clean. Formal pre-trend test statistics are not stored in results.csv but the event study plot strongly suggests no violation.

---

## Summary
TWFE is internally consistent and the event study pre-trends are clean. The main concern is the **discretization of the continuous treatment** for our stored beta: the paper's causal parameter is a continuous dose-response coefficient, while we store a binary-split ATT. The result is directionally valid and internally coherent but is not a direct replication of the paper's headline number. The dynamic effects are plausible and consistent across estimators.

**Verdict: WARN** — One methodological concern: discretization mismatch between the paper's continuous treatment specification and the stored binary-treatment TWFE beta.

---

*Full report for audit trail. See also: [reviews/csdid-reviewer.md](csdid-reviewer.md)*
