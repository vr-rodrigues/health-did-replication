# CS-DID Reviewer Report — Article 61 (Evans & Garthwaite 2014)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Data structure compatibility
- Data structure: `repeated_cross_section`. CS-DID (Callaway-Sant'Anna) is designed for panel data. Application to RCS requires aggregation to pseudo-panels, which the template performs.
- `allow_unbalanced = true` — the RCS aggregation may produce imbalanced pseudo-panels across periods.

### 2. Treatment timing
- Single adoption timing: all treated units adopt in 1995.
- `gvar_CS` is constructed as: `ifelse(kids > 1, 1995, 0)` — this assigns the 1995 cohort to all individuals with 2+ kids. With single timing, there is only one cohort (g=1995) plus the never-treated (g=0, i.e., 1-child households).
- With only one cohort, the CS-DID ATT collapses to a single group-time ATT — no staggered-timing heterogeneity bias to worry about, but also no real advantage over TWFE.

### 3. Control variables
- `cs_controls = []` while `twfe_controls = ["twoplus_kids", "eitc_expand"]`. The CS-DID is run without controls, creating a comparison asymmetry with the TWFE baseline. The doubly-robust CS-DID with controls returned status "OK" but a value of 0 — an anomaly that suggests numerical collapse (likely collinearity or degenerate conditioning given the single-cohort RCS structure).
- `att_cs_nt_with_ctrls = 0` and `att_cs_nt_with_ctrls_dyn = 0` — these zeros are almost certainly a computational failure, not a true zero effect.

### 4. ATT estimate comparison
- `att_csdid_nt` (simple) = 0.006514 vs `beta_twfe` (stored, incorrect spec) = 0.01032
- Relative gap: 37% smaller under CS-DID
- The correct TWFE (no FE) = 0.009483; relative gap to CS-NT = 31% smaller
- Direction is consistent (positive), but magnitude diverges meaningfully

### 5. Standard errors
- `se_csdid_nt` = 0.01375, substantially larger than `se_twfe` = 0.00786. The CS-DID estimate is not statistically significant at conventional levels (t ≈ 0.47), while the TWFE is borderline (t ≈ 1.31 using stored incorrect beta; t ≈ 1.21 with correct beta and paper SE).
- This SE gap is consistent with the RCS → pseudo-panel efficiency loss.

### 6. Pre-trend test
- No pre-trend test available from outputs (no event study). Cannot assess parallel trends in CS-DID framework.

### 7. Never-treated vs not-yet-treated
- `run_csdid_nyt = false` — only never-treated comparison group run.
- With single timing, the NYT group is not meaningfully distinct from NT (no units are "not-yet-treated" in steady state). Correct decision.

## Summary of concerns
- WARN: `att_cs_nt_with_ctrls = 0` is almost certainly a numerical failure (degenerate doubly-robust estimator in RCS single-cohort context with collinear controls), not a genuine zero effect.
- WARN: Large SE inflation (75% wider than TWFE SE) results in CS-DID being statistically inconclusive while TWFE is marginally significant — direction agreement masks a precision gap that matters for inference.
- NOTE: Single-timing design limits CS-DID's conceptual value-add here; with one cohort there is no staggered-timing heterogeneity to purge.

## Verdict rationale
WARN for two reasons: the doubly-robust with-controls variant returned a degenerate zero (numerical anomaly), and the SE inflation makes the CS-DID estimate non-significant while TWFE is marginally positive.
