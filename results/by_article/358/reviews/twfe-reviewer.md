# TWFE Reviewer Report: 358 — Bargain, Boutin, Champeaux (2019)

**Verdict:** PASS
**Date:** 2026-04-19
**Axis classification:** Implementation = PASS; Design finding = D-NA

## Checklist

### 1. Design applicability
- 2x2 DiD (two time periods: 2008 and 2014; single treatment event: 2011 Arab Spring).
- TWFE with two periods is algebraically equivalent to a clean DiD estimator. No negative-weighting or heterogeneous-timing pathology is possible. No forbidden comparisons.
- The paper uses `areg` with municipality FE and clustered SEs at municipality level (ID_2). Our `feols` with same FE and cluster structure is the correct replication.

### 2. Coefficient fidelity
- Paper Table 1 Column 4: beta = 4.181, SE = 1.058.
- Our result: beta = 4.18087, SE = 1.05256.
- Coefficient gap: 0.003% (EXACT under any tolerance threshold).
- SE gap: 0.3% (attributable to feols small-sample degrees-of-freedom adjustment vs. Stata areg; not a concern).

### 3. Fixed-effects structure
- Spec C (headline): TWFE with 30 controls (the paper's full specification). Municipality FE + post indicator absorbed.
- Spec B (no controls): beta = 4.951 (+18.5% vs Spec C); confirms the 30 controls matter for magnitude but not for direction.
- No spurious additional FEs detected.

### 4. Cluster level
- Cluster at ID_2 (municipality, N=272). Matches paper exactly. No ambiguity.

### 5. Pre-trend testability
- Structural constraint: 2 time periods → 0 pre-periods available. Pre-trend testing is architecturally impossible, not a replication flaw.

### 6. Event study
- `has_event_study=false` in metadata. No event study in original paper. None run by template.

### 7. Implementation verdict
- All structural checks PASS. Coefficient reproduced exactly. No implementation concerns.

### 8. Spec A note (for context)
- Spec A (TWFE with 30 ctrls + CS-NT with 30 ctrls): TWFE side produces 4.181 as expected.
- The CS-NT side of Spec A collapses to 0 (Pattern 42 — see csdid-reviewer report). This is an estimator behavior finding, not a TWFE implementation issue.
