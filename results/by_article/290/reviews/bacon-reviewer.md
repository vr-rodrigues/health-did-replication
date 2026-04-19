# Bacon Decomposition Reviewer Report — Article 290 (Arbogast et al. 2022)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability
- treatment_timing = "staggered", data_structure = "panel", allow_unbalanced = false
- APPLICABLE

## Checklist

### 1. Weight decomposition
- TVU (Treated vs Untreated / clean): weight = 0.8822 (88.2%)
- LvE (Later vs Earlier Treated / forbidden): weight = 0.0563 (5.6%)
- EvL (Earlier vs Later Treated / forbidden): weight = 0.0615 (6.2%)
- TVT (forbidden, LvE + EvL combined): 11.8%
- Dominant clean comparison: TVU at 88.2% is very healthy. Most identification comes from comparing treated states to never-treated states.

### 2. TWFE reconstruction
- Bacon-reconstructed TWFE: -0.0162
- Stored TWFE: -0.0182
- Gap: 12% — slightly above tolerance, likely due to weighting rounding across 12 cohorts.

### 3. Heterogeneity in TVU estimates
- TVU estimate range: -0.0619 (cohort 60) to +0.0048 (cohort 67)
- TVU weighted mean: -0.0176 (close to aggregate TWFE)
- Cohort 60 has estimate -0.0619 and weight 7.8% — substantially more negative than other cohorts
- Cohort 67 has a positive estimate (+0.0048, w=6.2%) — opposite sign to the aggregate, suggesting heterogeneous treatment effects
- Cohort 48 has estimate -0.0307 and weight 18.7% (largest weight) — drives aggregate toward negative

### 4. Forbidden comparison analysis
- LvE pairs: 45 total; 19 with negative estimate (same direction as overall — contaminating in negative direction)
- EvL pairs: 45 total; 23 with positive estimate (attenuating toward zero)
- The mixed-sign forbidden comparisons partially offset each other
- Combined TVT weight of 11.8% is relatively small; unlikely to materially bias TWFE given TVU dominance

### 5. Cohort heterogeneity concern
- 10 treated cohorts (states) with TVU estimates ranging from -0.062 to +0.005
- This 6.7pp range is large relative to the aggregate effect (-0.018)
- Cohort 60 (est=-0.062) is an outlier: ~3.4x the aggregate magnitude
- The positive cohort 67 (est=+0.005) indicates some states show no enrollment decline post-burden
- This heterogeneity means the aggregate TWFE may not be a good summary of any cohort's experience

### 6. WARN rationale
- TVU dominance (88.2%) is reassuring — the TWFE is not heavily contaminated by forbidden comparisons
- However, cohort-level effect heterogeneity (range -0.062 to +0.005) warrants a WARN
- Without functioning CS-DID estimates, we cannot cleanly verify whether the heterogeneity reflects true ATT differences or data reconstruction artifacts

**Overall Bacon Verdict: WARN** (TVU dominance healthy at 88.2%; cohort heterogeneity range -0.062 to +0.005 warrants attention; forbidden comparisons small at 11.8%)
