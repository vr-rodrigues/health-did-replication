# TWFE Reviewer Report — Article 213
**Estrada & Lombardi (2022) — Dismissal Protection, Bureaucratic Turnover**
**Date:** 2026-04-18

**Verdict:** PASS

## Checklist

### 1. Specification alignment
- Specification matches paper (Table 2, Col 1): `reg left_school_plus1 treated_post treated i.agno, cluster(clave)`.
- No unit FEs beyond the binary `treated` group indicator — this is intentional and documented in metadata notes. The treated/control split is sharp (3yr vs 2yr seniority), so `treated` acts as a group-level FE, which is correct for this design.
- No time-varying controls in TWFE, consistent with authors' baseline spec.
- Clustering at school (`clave`) level matches original.

### 2. Coefficient plausibility
- beta_twfe = -0.0372, SE = 0.0103; t-stat ≈ 3.63. Statistically significant.
- Direction is correct: permanent contract protection reduces the probability of leaving one's school by ~3.7pp.
- No controls (`twfe_controls = []`) matches `unica_sem_controles` group label.

### 3. Pre-trend inspection (event study)
- t-4: +0.024 (SE 0.020) — not significant
- t-3: -0.015 (SE 0.016) — not significant
- t-2: +0.027 (SE 0.018) — not significant
- Pattern: oscillating, no monotonic drift. Pre-trends do not raise concern.
- Joint pre-trend test: individual t-stats all below 1.6; no systematic violation of parallel trends.

### 4. Treatment indicator construction
- `treated_post` is a valid interaction of the binary group indicator and post-2014 period. Single cohort (gvar=2014 for all treated units), so TWFE = CS-NT ATT for the post-period by construction.
- The `gvar_CS <- ifelse(treated==1, 2014, 0)` preprocessing is consistent.

### 5. Data structure considerations
- RCS (repeated cross-section): individual teachers observed once per year. Unit FE not feasible. The spec using group + year FEs is the correct adaptation.
- Sample filter `sample_turnover == 1 & age < 55` is the authors' own restriction.

### 6. TWFE-specific concerns
- Single timing eliminates staggered-timing bias: TWFE and CS-DID estimate the same object.
- No forbidden comparisons possible with a single cohort.
- Gardner/BJS beta = -0.0372 (identical), confirming no negative-weighting distortion.

## Summary
The TWFE specification is correctly implemented. Pre-trends are clean (oscillating, non-systematic). Single-timing design means TWFE is not subject to heterogeneous-treatment-timing critique. No concerns.
