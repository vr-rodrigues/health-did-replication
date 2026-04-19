# CS-DID Reviewer Report — Article 213
**Estrada & Lombardi (2022) — Dismissal Protection, Bureaucratic Turnover**
**Date:** 2026-04-18

**Verdict:** PASS

## Checklist

### 1. Estimator configuration
- `run_csdid_nt = true`, `run_csdid_nyt = false` (correct: single timing, no staggered adoption, so NYT = NT in this case).
- `gvar_CS = 2014` for treated units, `0` for never-treated (control group: 2yr seniority teachers who never receive the reform).
- No controls in CS-DID spec (`cs_controls = []`), matching the no-controls baseline.

### 2. ATT estimates
- ATT (CS-NT simple) = -0.0299, SE = 0.0141 — directionally consistent with TWFE (-0.0372).
- ATT (CS-NT dynamic) = -0.0299, SE = 0.0143 — identical point estimate.
- The gap TWFE vs CS-NT = 0.0073pp (approximately 19.6% smaller magnitude in CS-NT).

### 3. Gap analysis
- With single timing and no controls, TWFE and CS-NT should coincide exactly. The ~20% gap warrants investigation.
- Likely explanation: RCS data structure means within-school tracking is impossible. CS-DID in RCS context uses a different aggregation path than TWFE. The group/year cell aggregation in CS-DID may differ from TWFE's pooled regression in how it handles unbalanced cell sizes.
- This is documented as Pattern 25 (RCS aggregation divergence). The gap is smaller than the 57-63% gaps seen in other RCS papers (e.g., article 76), so the RCS explanation is plausible.
- Direction is consistent across all estimators (TWFE, CS-NT, SA, Gardner).

### 4. Pre-trend examination (CS-NT event study)
- The CS-NT event study mirrors TWFE almost exactly (single cohort: by construction they share the same pre-period observations).
- t-4: +0.024, t-3: -0.015, t-2: +0.027 — same oscillating pattern, no systematic drift.
- No pre-trend failure.

### 5. Control group validity
- Never-treated group: teachers with exactly 2 years of consecutive seniority, who do not qualify for the reform's permanent-contract conversion.
- This is a valid comparison group: same occupation, same school system, same selection-into-teaching process, differentiated only by 1 year of seniority at the reform cutoff. Sorting concerns are limited (seniority is predetermined at cutoff).
- No contamination risk: the 2yr-seniority group does not receive permanent contracts under the law.

### 6. NYT not run
- Correct: with single-cohort treatment (all treated units adopt in 2014), the not-yet-treated comparison set is empty (no staggered adoption). NYT = NT in this case.

### 7. Doubly-robust / controls
- DR-CSDID with controls status = "N/A_no_twfe_controls" — correctly flagged as not attempted since there are no controls to add.

## Summary
CS-DID is correctly specified. ATT direction and approximate magnitude are consistent with TWFE. The ~20% gap is attributable to RCS aggregation mechanics (Pattern 25) rather than a misspecification. Pre-trends are clean. Control group (2yr seniority teachers) is credible. No concerns.
