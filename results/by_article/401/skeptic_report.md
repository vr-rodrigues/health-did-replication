# Skeptic report: 401 — Rossin-Slater (2017)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (NOT_APPLICABLE), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Rossin-Slater (2017) estimates the effect of hospital paternity establishment programs on the probability that mothers marry the biological father of their child, using a staggered DiD across 44 U.S. states adopting between 1990 and 1999. The paper's Table 3 col 5 headline TWFE coefficient is -0.0281 (SE 0.0088), which our replication recovers to within 1.4% (-0.0285; gap explained by omission of state-specific linear time trends as noted in metadata). However, three methodological concerns jointly produce a LOW rating. First, the all-eventually-treated design means TWFE relies entirely on forbidden comparisons (earlier-treated states as controls for later-treated states), and CS-DID using not-yet-treated controls produces an ATT of -0.0024 — roughly 12 times smaller than TWFE, indicating substantial heterogeneous treatment effects and/or the importance of the rich set of controls absent from the CS estimator. Second, all TWFE event-study pre-periods are positive and form a mild upward drift, raising concerns about parallel trends. Third, HonestDiD sensitivity analysis shows the effect is D-FRAGILE: all targets (first post-period, average, peak) fail to exclude zero at Mbar=0, meaning the headline result is not robust even under the assumption of exactly parallel trends. The stored TWFE result should be interpreted with substantial caution; the true ATT for the marriage outcome may be considerably smaller and possibly indistinguishable from zero.

## Per-reviewer verdicts

### TWFE (WARN)
- Coefficient reproduced to within 1.4% (-0.0285 vs -0.0281); SE gap explained by omitted state-specific time trends.
- All 5 pre-period coefficients are positive (range +0.010 to +0.027), forming a mild upward pre-trend pattern inconsistent with strict parallel trends.
- All-eventually-treated design: TWFE relies entirely on earlier-treated states as controls for later-treated states, creating forbidden comparison contamination.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT estimator is conceptually invalid (no never-treated units); ATT = -0.0026 is near-zero and degenerate.
- CS-NYT ATT = -0.0024 vs TWFE -0.0285 — a 12x magnitude gap; strongly suggests forbidden comparison bias in TWFE and/or the importance of controls not included in CS estimator.
- CS-NT event study shows elevated negative pre-period at t=-5 (-0.043, SE=0.025); CS-NYT shows elevated t=-2 (+0.038).

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Bacon decomposition not applicable: data_structure = repeated_cross_section, allow_unbalanced = true, run_bacon = false.
- Informational bacon.csv exists but cannot be used for causal inference on RCS data.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- D-FRAGILE design: rm_first_Mbar = 0, rm_avg_Mbar = 0, rm_peak_Mbar = 0 for TWFE.
- At Mbar=0 (zero pre-trend violations assumed): TWFE first-period CI = [-0.048, +0.012] includes zero; average CI = [-0.030, +0.009] includes zero; peak CI = [-0.041, +0.001] borderline.
- CS-NYT equally fragile: all targets include zero at Mbar=0; peak CI extremely wide ([-0.207, +0.172]).

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design; DID_M not applicable.
- Heterogeneous-treatment concerns fully captured by TWFE and CS-DID reviewers.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF file available (pdf/401.pdf not found); fidelity axis is F-NA.
- Informational: metadata-recorded original result (-0.0281) vs our estimate (-0.0285) would score WITHIN_TOLERANCE if PDF were available.

Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

## Material findings (sorted by severity)

**WARN items:**

- [WARN — CS-DID] 12x magnitude gap between TWFE (-0.0285) and CS-NYT (-0.0024): all-eventually-treated forbidden comparisons inflate TWFE; CS estimator missing 33 controls further complicates comparison. The true effect on married_tobiodad may be near zero.
- [WARN — HonestDiD] D-FRAGILE design: TWFE result not robust at Mbar=0 for any target (first, average, peak). Peak effect borderline (UB=+0.001 at Mbar=0) but immediately loses significance with any pre-trend allowance.
- [WARN — TWFE] Systematic positive pre-trend drift across all 5 pre-periods (+0.010 to +0.027): raises parallel trends concern, though no single period is individually significant.
- [WARN — CS-DID] CS-NT estimator invalid for all-eventually-treated design; near-zero estimate is artifact of no valid comparison group.
- [WARN — TWFE] Potentially endogenous controls: wage_withhold, new_hires, license_revoke, joint_custody, waiver, tanf, eitc are policy variables that may be co-determined with the paternity establishment treatment.

## Rating derivation

| Axis | Score |
|------|-------|
| TWFE | WARN |
| CS-DID | WARN |
| Bacon | NOT_APPLICABLE |
| HonestDiD | WARN |
| de Chaisemartin | NOT_NEEDED |
| **Methodology score** | **M-LOW** (3 WARNs, 0 FAILs) |
| Paper Auditor | NOT_APPLICABLE → F-NA |
| **Combined** | M-LOW × F-NA → use methodology alone → **LOW** |

## Recommended actions

- [Repo-custodian] Add key time-varying controls to cs_controls in metadata (at minimum: unemp_rate_lag1, pov_rate_lag1, gov_dem_lag1) to close the TWFE/CS-DID specification gap and obtain a more comparable CS-DID estimate.
- [User — methodological judgement] Evaluate whether any of the 33 TWFE controls are post-treatment variables (wage_withhold, new_hires, license_revoke are particularly suspect as they are related paternity enforcement policies that may be adopted jointly or sequentially). If so, re-estimate TWFE with pre-determined controls only.
- [Pattern-curator] Consider adding Pattern: "All-eventually-treated + rich controls + CS estimator with no controls = large TWFE/CS-DID gap; gap not necessarily evidence of TWFE bias — also reflects specification asymmetry."
- [User — methodological judgement] The D-FRAGILE HonestDiD result (rm_Mbar=0 for all targets) combined with systematic positive pre-trends suggests the headline effect of -0.0281 likely overstates the true ATT. Any policy or academic citation of this result should note the robustness limitation.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
