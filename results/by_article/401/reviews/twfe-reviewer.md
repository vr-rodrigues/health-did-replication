# TWFE Reviewer Report: Article 401 — Rossin-Slater (2017)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Coefficient fidelity
- Our TWFE estimate: beta = -0.0285 (SE = 0.0076)
- Paper's Table 3 col 5: beta = -0.0281 (SE = 0.0088)
- Difference: -0.0004 (1.4% gap); SE gap explained by paper including state-specific linear time trends (tt_state_*) which are NOT replicated here
- **Status: PASS** (gap within tolerance, source explained in metadata notes)

### 2. Event study pre-trend pattern
Pre-period TWFE coefficients (reference = t=-1):

| Period | Coef   | SE     |
|--------|--------|--------|
| t=-6   | +0.027 | 0.017  |
| t=-5   | +0.010 | 0.020  |
| t=-4   | +0.018 | 0.015  |
| t=-3   | +0.021 | 0.013  |
| t=-2   | +0.014 | 0.013  |

All pre-period coefficients are positive and form a mild upward-sloping pre-trend. None are statistically significant individually (SEs = 0.013-0.020), but the systematic positive pattern raises concern about differential pre-trends that could inflate the post-treatment effect in absolute terms.

Post-treatment pattern: t=0: -0.018, t=1: -0.020, t=2: -0.012, t=3: -0.008, t=4: -0.012, t=5: +0.007 — effect fades and returns toward zero by t=5.

**Status: WARN** — consistent mild positive pre-trend across all 5 pre-periods

### 3. All-eventually-treated design contamination
- All 44 states eventually adopt hospital paternity programs (cohorts 1990-1999)
- TWFE uses earlier-treated units as implicit controls for later-treated units
- This creates "forbidden comparisons" (de Chaisemartin & d'Haultfoeuille 2020, Goodman-Bacon 2021): earlier-treated states serve as controls at a point when their treatment effect may be non-zero
- No pure never-treated comparison group exists
- With 8 staggered cohorts (1990-1999) and cohorts 1990 and 1993 having only 1 state each, extreme imbalance affects decomposition weights

**Status: WARN** — all-eventually-treated; forbidden comparisons are the only source of identification

### 4. High-dimensional controls
- 33 time-varying controls included in TWFE
- Many are policy-endogenous (wage_withhold, new_hires, license_revoke, joint_custody, waiver, tanf, eitc) — these may be post-treatment variables that absorb treatment variation
- cs_controls = [] (no controls in CS estimator) — creates a specification gap between TWFE and CS-DID estimates

**Status: WARN** — potential over-control / post-treatment variable bias

### 5. Summary
The TWFE coefficient is well-replicated numerically. However, the all-eventually-treated design, mild systematic pre-trends, and inclusion of potentially endogenous controls jointly warrant a WARN verdict.

## References
- Full results: `results/by_article/401/results.csv`
- Event study data: `results/by_article/401/event_study_data.csv`
