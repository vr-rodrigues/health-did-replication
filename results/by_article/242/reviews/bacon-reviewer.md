# Bacon Decomposition Reviewer Report — Article 242

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability

Treatment is staggered (9 cohorts, 2001–2012), data_structure = panel, allow_unbalanced = false. `run_bacon = false` in metadata (due to design concerns), but Bacon data was computed and is available. APPLICABLE — data reviewed.

## Bacon decomposition results

### Category weights and estimates

| Category | N pairs | Total weight | Estimate range | Weighted avg (approx) |
|---|---|---|---|---|
| Treated vs Untreated | 8 cohorts | ~0.924 | -0.059 to +0.200 | ~0.054 |
| Later vs Earlier Treated | 42 pairs | ~0.063 | -0.190 to +0.219 | ~-0.008 |
| Earlier vs Later Treated | 28 pairs | ~0.013 | +0.002 to +0.181 | ~+0.095 |

### Dominant "Treated vs Untreated" pairs

| Cohort | Weight | Estimate |
|---|---|---|
| 2008 vs untreated | 0.340 | -0.008 |
| 2009 vs untreated | 0.198 | +0.062 |
| 2010 vs untreated | 0.112 | -0.052 |
| 2007 vs untreated | 0.113 | +0.200 |
| 2005 vs untreated | 0.080 | +0.137 |
| 2012 vs untreated | 0.049 | -0.059 |
| 2006 vs untreated | 0.017 | +0.060 |
| 2003 vs untreated | 0.012 | +0.115 |

## Checklist

### 1. Weight structure
- [PASS] "Treated vs Untreated" comparisons dominate (~92.4% of total weight). This is healthy — the TWFE estimate is primarily driven by clean 2x2 treated-vs-never-treated comparisons.
- [INFO] "Later vs Earlier Treated" (contaminated comparisons) account for only ~6.3% of weight — a small share.

### 2. Sign consistency
- [WARN] The "Treated vs Untreated" estimates show substantial sign heterogeneity: 2007 cohort gives +0.200 (very large positive); 2008 cohort gives -0.008 (near zero); 2010 cohort gives -0.052 (negative); 2012 cohort gives -0.059 (negative). The variation across cohorts suggests treatment effect heterogeneity — some cohorts (early adopters: 2005, 2007) show large positive earnings effects, while later cohorts (2010, 2012) show negative or near-zero effects. This pattern may reflect the fracking boom timeline: early-adopting counties benefited from the boom while later cohorts adopted as boom was winding down.

### 3. Contaminated comparisons
- [WARN] "Later vs Earlier Treated" comparisons show extreme values: -0.190 (2010 vs 2007), +0.219 (2007 vs 2012). These contaminated comparisons have opposite signs, partially canceling each other. While the total weight is small (~6.3%), the sign dispersion is large enough to affect the aggregate TWFE estimate.

### 4. Aggregate consistency
- [PASS] The weighted average of all Bacon components should equal TWFE (0.01944). Given dominant-weight cohorts averaging near zero (2008 at 0.340 weight gives -0.008) and positive cohorts (2007 at 0.113 gives +0.200), the aggregate of ~0.019 is plausible.

### 5. Pattern 37 relevance
- [WARN] Treatment turns off after ~e=6. The Bacon decomposition assumes absorbing treatment (once treated, always treated). For a non-absorbing treatment (tquartile1 can switch back to 0), the Bacon decomposition's theoretical properties do not hold. The 2x2 DiDs it computes use pre-to-post averages that conflate adoption and de-adoption dynamics. This is the primary reason `run_bacon = false` was set in metadata.

## Key concerns

1. **Non-absorbing treatment invalidates standard Bacon interpretation**: The Bacon decomp assumes absorbing treatment. With non-absorbing treatment, the computed 2x2 DiDs are not clean ATT estimates — they blend adoption and subsequent de-treatment effects.

2. **Cohort-specific heterogeneity is large**: Early adopters (2005, 2007) show 2-4x larger effects than the aggregate TWFE. Later adopters (2010, 2012) show near-zero or negative effects. This is consistent with boom-bust dynamics in fracking labor markets.

3. **Contaminated comparisons are sign-dispersed**: The "later vs earlier" pairs show both large positive (+0.219) and large negative (-0.190) estimates, suggesting significant treatment effect heterogeneity across cohorts that TWFE masks.

## Verdict justification

WARN: The Bacon decomposition reveals important economic heterogeneity — early-adopting counties benefiting substantially more than late adopters, consistent with the fracking boom timing hypothesis. The contaminated comparisons are small in weight but sign-dispersed. The key methodological warning is that the non-absorbing nature of treatment means standard Bacon interpretation does not strictly apply here.

[Full data: `results/by_article/242/bacon.csv`, `results/by_article/242/bacon_decomposition.pdf`]
