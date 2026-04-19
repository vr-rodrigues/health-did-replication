# TWFE Reviewer Report — Article 253 (Bancalari 2024)

**Verdict:** PASS

**Date:** 2026-04-18

## Checklist

### 1. Specification alignment
- Paper spec: `reghdfe vs_imr1y D, absorb(i t) cluster(i)` (Table 2 Panel A Col 1, REStat).
- Our spec: TWFE with unit FE (i) + time FE (t), clustered SEs by district (i), no controls.
- Outcome: `vs_imr1y` (1-year infant mortality rate).
- Treatment indicator: `D` (binary absorbing, staggered initiation 2005-2015).
- Data: `analysis_district_clean_all.dta`, N=1,467 districts, 2005-2015 balanced panel (allow_unbalanced=false).

### 2. Coefficient fidelity
- Paper reports: beta=+0.74, SE=0.42 (p=0.08).
- Our estimate: beta=+0.737, SE=0.416.
- Relative difference: |0.737-0.74|/0.74 = 0.41% — within rounding.
- SE relative difference: |0.416-0.42|/0.42 = 0.95% — within rounding.
- **EXACT match** (difference attributable solely to display rounding in paper).

### 3. Event-study pre-trends (TWFE)
- Window: -6 to +7 (relative to treatment onset).
- Pre-period coefficients:
  - t=-6: -0.375 (SE=1.11) — insignificant
  - t=-5: -0.608 (SE=0.94) — insignificant
  - t=-4: +0.269 (SE=0.76) — insignificant
  - t=-3: +0.064 (SE=0.60) — insignificant
  - t=-2: -0.161 (SE=0.50) — insignificant
  - t=-1: 0 (normalised)
- Pre-trend pattern: oscillating around zero, no systematic drift. No statistically significant pre-periods.
- Note: t=-7 coefficient (-1.65, SE=1.22) lies outside the trimmed window in the baseline spec; its inclusion adds noise without changing inference.

### 4. Post-treatment trajectory
- Monotonically growing positive effect from t=0 (+0.84) through t=7 (+4.45).
- Pattern is consistent with a treatment that has accumulating impacts over time (sewerage infrastructure rollout).
- No implausible discontinuities or reversals.

### 5. Treatment definition
- Binary absorbing treatment (sewerage project initiation), staggered across 11 cohorts (2005-2015).
- 22% of districts are never-treated (326/1,467) — valid control group.
- Cohort 2005 (78 units, treated in first available period) is dropped by CS-DID due to no pre-treatment base; this is expected and does not affect TWFE.

### 6. Potential TWFE-specific concerns
- Staggered timing with heterogeneous effects implies TWFE is contaminated by forbidden comparisons (earlier-treated as controls for later-treated). This is flagged in the BACON and CS-DID reviews.
- No time-varying controls: per metadata, `twfe_controls=[]`. Consistent with paper's main spec.
- Cluster level (district) matches paper.

### 7. Verdict reasoning
The TWFE coefficient matches the paper to within rounding, the specification is correctly implemented, and pre-trends are clean. The methodological limitation of TWFE under staggered timing with growing effects is a design-level concern addressed by the CS-DID and Bacon reviewers — it does not invalidate the TWFE implementation itself.

**Verdict: PASS**

_Full data path: `results/by_article/253/results.csv`, `results/by_article/253/event_study_data.csv`_
