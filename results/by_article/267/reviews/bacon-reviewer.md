# Bacon Decomposition Reviewer Report — Article 267
# Bhalotra, Clarke, Gomes, Venkataramani (2022)

**Verdict:** WARN

**Date:** 2026-04-18

## Applicability note
- treatment_timing = "staggered", data_structure = "panel", allow_unbalanced = true.
- Per protocol, Bacon is formally SKIPPED when allow_unbalanced=true (cannot cleanly balance).
- However, bacon.csv exists with 57 rows of decomposition output (Bacon was run on the full unbalanced panel).
- This report assesses the existing output informatively; the WARN reflects a methodological finding, not an applicability failure.

## Checklist

### 1. Treated vs Untreated (TVU) component
Main Treated vs Untreated (never-treated comparisons) — dominant component:
- Cohort 2002: estimate = -0.095, weight = 24.0%
- Cohort 2003: estimate = -0.354, weight = 24.1%
- Cohort 2000: estimate = -0.154, weight = 11.4%
- Cohort 2013: estimate = -0.053, weight = 9.9%
- Cohort 2010: estimate = +0.085, weight = 8.6%
- Cohort 2005: estimate = +0.102, weight = 11.8%
- Cohort 2012: estimate = +0.159, weight = 6.3%

**Critical finding: 3 of 7 TVU components are POSITIVE, including the combined weight of 26.7% (cohorts 2005, 2010, 2012).** This is highly anomalous — reserved-seat quotas should reduce maternal mortality, but late-adopting cohorts show positive Bacon components.

### 2. Forbidden comparisons (Earlier vs Later Treated)
- Many Earlier vs Later Treated pairs have negative estimates (correct direction) and small weights.
- However, Later vs Earlier Treated pairs (which are "forbidden" — using early adopters' post-period as control for late adopters) exist throughout.
- Example: 2003 vs 2010 (EvL): estimate = -0.545, weight = 0.12% — extreme value.
- Combined weight of Later vs Earlier Treated pairs: small (< 5% total).
- **Forbidden comparisons: minor concern given small weights.**

### 3. Interpretation of positive TVU components
The positive Bacon components for late-adopting cohorts (2005, 2010, 2012) suggest that these countries experienced *increases* in MMR relative to never-treated countries in the pre-adoption period used as the "untreated period" in the 2x2 DiDs. 

Two explanations:
a) **Heterogeneous effects with anticipation**: late-adopting countries may have experienced reform anticipation effects.
b) **Compositional issue**: late-adopting countries may be systematically different from never-treated countries in MMR trajectory.

Either way, the positive Bacon weights attenuate the TWFE toward zero relative to the true (negative) ATT.

### 4. Aggregate implication
- TWFE = -0.082 is a weighted average that includes both negative (-0.354 for cohort 2003) and positive (+0.159 for cohort 2012) components.
- The negative cohorts (2000, 2002, 2003) represent 59.5% of TVU weight with large negative effects; positive cohorts (2005, 2010, 2012) represent 26.7% with positive effects.
- Net TWFE = -0.082 reflects significant attenuation; CS-NT = -0.112 (37% larger) confirms this direction.

### 5. Always Treated / Uganda
- Uganda adopted in 1989 (before sample start). Bacon shows "Later vs Always Treated" pairs.
- 7 cohorts compared to Uganda as always-treated control. Estimates range widely (-0.277 for cohort 2003 to +0.273 for cohort 2012).
- The always-treated unit adds noise to the decomposition but Uganda represents one country.

## Summary of findings
- Bacon confirms TWFE attenuation from staggered timing heterogeneity.
- Positive TVU components for 3 late-adopting cohorts (combined weight ~27%) drive the attenuation.
- Late-adopter positive components are the key methodological concern; the pattern is consistent with declining treatment-effect heterogeneity by adoption year.
- WARN: the Bacon decomposition reveals substantial within-TWFE heterogeneity that the headline result conceals.

## References to data
- `results/by_article/267/bacon.csv`: full decomposition (57 rows)
- `results/by_article/267/bacon_decomposition.pdf`: visualization
