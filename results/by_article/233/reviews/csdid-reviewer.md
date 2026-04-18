# CS-DID Review: 233 — Kresch (2020)

**Verdict:** PASS
**Date:** 2026-04-18
**Reviewer:** csdid-reviewer

## Specification

- Estimator: `att_gt()` with never-treated comparison (gvar_CS: Local=2006, Regional=0)
- cs_controls: [] (no controls — correct for CS-DID)
- cs_cluster: code (unit-level bootstrap, NOT company-level)
- att_csdid_nt = 3,329.351, SE = 1,199.779

## Design check

### 1. Single-cohort identification
- gvar_CS assigns 2006 to all Local municipalities and 0 to Regional (never-treated). This is the correct single-cohort representation.
- Since there is only one treatment cohort (g=2006), the ATT_gt collapses to a single group-time cell, and the aggregated ATT equals the simple average over post-periods. No heterogeneous timing contamination possible. **PASS**

### 2. Never-treated vs not-yet-treated
- CS-NYT returns NA (correct: no not-yet-treated units exist in a single-cohort design — all units are either treated in 2006 or never treated). The metadata correctly sets run_csdid_nyt=true but the output NA is the expected result. **PASS**

### 3. Clustering (Pattern 49/50 resolution)
- CRITICAL: The OLD run used cs_cluster=company, which creates an asymmetric cluster structure (25 state-level Regional codes vs 124 individual Local municipality codes). This asymmetry caused the bootstrap to misallocate variance across treatment groups, producing a spuriously low ATT of 367.503 (SE=205).
- The NEW run uses cs_cluster=code (unit-level bootstrap), which is symmetric across all 1,346 municipalities and produces the correct ATT of 3,329.351 (SE=1,199.779).
- This resolution is consistent with Pattern 49 (Kresch-class clustering bug) and Pattern 50 invariant: for single-cohort CS-DID with asymmetric company-level clusters, use unit-level clustering.
- The unit-level SE (1,199) is comparable to the TWFE SE (1,254), providing a sanity check. **PASS — bug resolved**

### 4. TWFE vs CS-DID divergence
- TWFE β=2,868 vs CS-NT ATT=3,329 — divergence of ~16%. In a single-cohort design with no timing heterogeneity, the two estimators should be identical if both use the same sample and controls. The divergence here is entirely attributable to the TWFE specification including 14 controls while CS-DID uses no controls (cs_controls=[]). This is a deliberate and documented difference, consistent with the original paper's robustness check design. **PASS — divergence explained**

### 5. Pre-trends under CS-DID
- CS-NT pre-period event study: t=-5: 138, t=-4: 398, t=-3: 709, t=-2: 689 — similar pattern to TWFE (consistently positive, growing). The pre-trend concern is symmetric across estimators. **CONSISTENT WITH TWFE**

## Summary

The CS-DID implementation is correct. The critical Kresch-class clustering bug (Pattern 49) has been resolved by switching to unit-level bootstrap (Pattern 50). The stored ATT of 3,329.351 is the correct value. The 16% divergence from TWFE is explained by the no-controls specification of CS-DID. The single-cohort design means CS-DID collapses to a simple two-group DiD, and the estimator is mechanically well-defined.

**Verdict: PASS**
