# TWFE Reviewer Report: Article 1094

**Verdict: WARN**
**Date:** 2026-04-18
**Paper:** Fisman & Wang (2017) — "The Distortionary Effects of Incentives in Government: Evidence from China's Death Ceiling Program"

---

## 1. Specification Alignment

- Outcome: `exceedquota` (binary LPM, I(Deaths/Ceiling > 1))
- Treatment indicator: `post = I(year > effective_year)` — strict inequality correctly implemented
- Unit FE: `provinceind` (province x industry = 245 units)
- Time FE: `year`
- Additional FE: `industry` (redundant given provinceind absorbs it, but consistent with original)
- Clustering: province level (31 clusters)
- Controls: none (`escalonada_sem_controles` group)
- Matches paper's Table 2, Col 1 specification

## 2. Coefficient Comparison

| Source | beta | SE | N |
|--------|------|----|---|
| Paper Table 2 Col 1 | -0.051 | 0.040 | 1755 |
| Our TWFE | -0.047 | 0.041 | 1756 |
| Gap | 7.8% | — | 1 obs |

Gap is within 10% tolerance. Notes attribute the 1-obs N gap to a Stata merge dropping 1 observation that R retains. SEs are virtually identical (0.040 vs 0.041). Assessment: WITHIN TOLERANCE; gap is a software/merge artifact, not a specification error.

## 3. Pre-Trend Assessment (TWFE event study)

Pre-period coefficients (t=-5 to t=-2, base t=-1):

| Period | Coef | SE | p approx |
|--------|------|----|----------|
| t=-5 | -0.030 | 0.047 | 0.52 |
| t=-4 | +0.019 | 0.055 | 0.73 |
| t=-3 | -0.038 | 0.054 | 0.48 |
| t=-2 | +0.066 | 0.053 | 0.21 |

All pre-period coefficients are statistically insignificant. No strong evidence of pre-trends. The t=-2 coefficient (+0.066) is relatively large relative to post-period effects but remains insignificant.

## 4. Post-Treatment Dynamics (TWFE)

| Period | Coef | SE |
|--------|------|----|
| t=0 | -0.056 | 0.053 |
| t=1 | +0.016 | 0.066 |
| t=2 | +0.029 | 0.063 |
| t=3 | -0.073 | 0.064 |
| t=4 | -0.035 | 0.077 |

Post-period TWFE coefficients are noisy and sign-inconsistent (positive at t=1, t=2; negative at t=0, t=3, t=4), suggesting weak or heterogeneous treatment effects under TWFE. No sustained treatment effect is visible.

## 5. Staggered Treatment Heterogeneity Concern

- Treatment timing is staggered (adoption 2005–2012 across 19 provinces, 7 cohorts)
- TWFE with staggered adoption can produce weighted averages with potentially negative weights
- `allow_unbalanced=true` means the bacon decomposition was run but the unbalanced panel structure means some 2x2 estimates are imprecise
- Cohort-specific 2x2 estimates in bacon.csv range from -0.309 to +0.113 (treated vs untreated), indicating substantial cross-cohort heterogeneity
- This is the primary methodological concern: TWFE aggregates heterogeneous cohort-level effects into a single coefficient that may not represent a well-defined causal parameter

## 6. Summary

**Verdict: WARN**

TWFE coefficient is close to the paper's published value (within 8%). Pre-trends are uniformly insignificant under TWFE. However, post-period dynamics are noisy and sign-inconsistent under TWFE, and the staggered design with 7 adoption cohorts creates heterogeneity bias risk. The null finding is consistent across TWFE and CS-NT (both insignificant), so no reversal of qualitative conclusion occurs.
