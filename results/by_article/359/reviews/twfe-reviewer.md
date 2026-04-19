# TWFE Reviewer Report — Article 359

**Article:** Anderson, Charles, Olivares, Rees (2019) — "Was the First Public Health Campaign Successful?"
**Reviewer:** twfe-reviewer
**Date:** 2026-04-18
**Verdict:** WARN

---

## Checklist

### 1. Specification fidelity
- TWFE estimate: β = -0.0363 (SE = 0.0333). Original paper reports β = -0.036 (SE = 0.035, Table 3B col 1). Match is essentially exact on the point estimate; SE is marginally tighter in replication (0.0333 vs 0.035), likely due to minor sample or clustering differences. **PASS**
- Controls included: 7 covariates including missing-indicator dummies + city-specific linear trends via `state_city_id[year]`. Matches Table 3B col 1 specification. **PASS**
- Population weights applied. **PASS**
- Clustering at state_fips (42 states). **PASS**

### 2. Pre-trend assessment
- Event study pre-periods (TWFE): t=-6: +0.014, t=-5: +0.017, t=-4: +0.025, t=-3: +0.040, t=-2: +0.014.
- Pre-period coefficients are uniformly positive and growing in magnitude toward t=-3, suggesting an upward pre-trend. This is a concern: cities that adopted reporting mandates earlier may have had differential pre-adoption TB trajectory.
- No formal pre-trend test result stored, but visual pattern suggests **non-parallel pre-trends**. **WARN**

### 3. Treatment effect plausibility
- TWFE post-treatment coefficients: t=0: -0.035, t=1: -0.020, t=2: -0.021, t=3: -0.022, t=4: -0.037, t=5: -0.043.
- Effects are negative throughout post-period, consistent with TB reduction. However, the positive pre-trend inflates (in absolute value) the measured negative effect since TWFE differences out a rising baseline.
- Effect size is modest (-3.6%) and not statistically significant (SE=0.033, t≈-1.1). **WARN**

### 4. Staggered adoption concerns
- 16 cohorts (1900-1917), 91 treated cities, 457 never-treated. Highly staggered.
- TWFE in staggered designs may use already-treated units as controls, potentially contaminating estimates with negative-weight components. This is a known bias source.
- The Bacon decomposition reveals extreme heterogeneity across 2x2 DiD pairs (range: -0.659 to +0.378), confirming that TWFE aggregates very different cohort-specific effects — some strongly positive, some strongly negative. **WARN**

### 5. Data structure
- Data is `repeated_cross_section`, not a true balanced panel. This limits the interpretation of unit-level fixed effects and may affect the validity of city-specific linear trends.
- With 53% fill rate in an unbalanced structure, composition of the sample across years may confound the time fixed effects. **WARN**

---

## Summary

The TWFE estimate (-0.036) matches the paper exactly. However, three methodological concerns arise: (1) positive pre-trends in the TWFE event study suggesting parallel trends assumption may be violated; (2) staggered adoption with extreme Bacon heterogeneity indicating TWFE is averaging very different 2x2 comparisons including potentially sign-reversing components; (3) repeated cross-section data with city-specific linear trends raises specification concerns. The effect is also statistically insignificant.

**Verdict: WARN** — Specification reproduces correctly but pre-trend pattern and staggered-design heterogeneity warrant caution.

