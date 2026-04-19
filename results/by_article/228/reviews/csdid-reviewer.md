# CS-DiD Reviewer Report — Article 228
# Sarmiento, Wagner & Zaklan (2023) — Air Quality and LEZ

**Verdict:** PASS
**Date:** 2026-04-18

---

## Checklist

### 1. Control group choice

**CS-NT (never-treated):** `run_csdid_nt: true` — APPLICABLE
**CS-NYT (not-yet-treated):** `run_csdid_nyt: true` — APPLICABLE

The paper's primary CS-DiD specification uses **never-treated** controls (`nevertreated`), which matches our CS-NT run. The NYT option is included for sensitivity. This is correctly specified in metadata.

**PASS**: Control group choice matches the paper's stated primary estimator.

### 2. Cohort identification (gvar)

`gvar_cs: treat_cohort` with staggered adoption cohorts: 2008, 2009, 2010, 2011, 2012, 2013, 2015, 2016 (8 cohorts). The Bacon decomposition confirms all 8 cohorts appear in the data.

**PASS**: Grouping variable correctly identifies first-adoption year per unit.

### 3. CS-DiD estimates

**Never-treated (NT) control group:**
- Simple ATT (aggte="simple"): -1.803 µg/m³ (SE=0.306)
- Dynamic ATT (aggte="dynamic"): -1.954 µg/m³ (SE=0.353)

**Not-yet-treated (NYT) control group:**
- Simple ATT (aggte="simple"): -1.795 µg/m³ (SE=0.313)
- Dynamic ATT (aggte="dynamic"): -1.948 µg/m³ (SE=0.337)

**Key finding**: NT and NYT estimates are virtually identical (within 0.5%). This is a strong validation — it means the NYT control group (later-treated units in their pre-treatment windows) behaves essentially identically to the never-treated group. This directly addresses the core NT vs. NYT robustness concern referenced in Lesson 6.

**PASS**: NT and NYT converge; no anomalous divergence.

### 4. Pre-trends (CS-NT event study)

CS-NT event study pre-period coefficients:
- h=-6: +0.191 (SE=0.721) — not significant
- h=-5: -0.285 (SE=0.448) — not significant
- h=-4: +0.117 (SE=0.447) — not significant
- h=-3: -0.827 (SE=0.386) — **borderline** (|t|=2.14, p≈0.03)
- h=-2: -0.171 (SE=0.357) — not significant

The h=-3 coefficient is -0.827 (SE=0.386), which is marginally significant at the 5% level. However:
- It is isolated (h=-4 and h=-2 are near zero)
- The magnitude is small relative to post-treatment effects (-1.0 to -2.0)
- The notes flag CS-NT/CS-NYT as "slightly noisy at far pre-periods"
- CS-NYT shows similar (|t|<2.5 at h=-3: -0.763/0.379=2.01)

**WARN note but overall PASS**: The h=-3 pre-period is marginally significant in CS-NT. This is a known feature of CS-DiD with staggered designs where short pre-treatment windows for early cohorts create noise. The signal is not consistent across adjacent periods and does not invalidate the design.

### 5. No controls specification

`cs_controls: []` and `xformla=~1` — no covariates. The paper's CS-DiD specification also uses no covariates (the paper's weather controls are in the TWFE only). This correctly matches the paper's primary CS-DiD specification.

**PASS**: Estimand alignment confirmed.

### 6. NT vs. NYT robustness (Lesson 6 focal check)

This paper is explicitly referenced as illustrating the NT vs. NYT distinction. Results:
- CS-NT dynamic: -1.954 (SE=0.353)
- CS-NYT dynamic: -1.948 (SE=0.337)
- Difference: 0.006 µg/m³ (0.3% gap)

This near-perfect convergence indicates that later-treated LEZ cities are valid controls in their pre-treatment windows — no anticipation contamination or differential pre-trends in the NYT pool. The NT and NYT results reinforce each other.

**PASS on NT vs. NYT robustness.**

### 7. Clustering

`cs_cluster: mun_id` — clustering at municipality level (not station level). This is appropriate because LEZ policy is implemented at the city level; stations within the same municipality share the same policy shock. Clustering at a higher level than the unit of observation (station) provides conservative standard errors.

**PASS**: Clustering strategy is appropriate.

### 8. Unbalanced panel note

`allow_unbalanced: true` — CS-DiD with unbalanced panels can introduce complexity in the att_gt estimation. The `did` package handles this via the influence function approach. Results are internally consistent.

**PASS**: No irregularities detected.

---

## Summary

CS-DiD implementation is correctly specified and produces internally consistent results. The near-perfect NT/NYT convergence is a noteworthy positive finding that validates the control group choice. The marginally significant h=-3 pre-period in CS-NT is the only concern, and it is isolated and of modest magnitude. Overall the CS-DiD implementation PASSES.

**Full data path:** `results/by_article/228/results.csv`, `results/by_article/228/event_study_data.csv`
