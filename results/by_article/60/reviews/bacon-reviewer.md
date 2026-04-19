# Bacon Decomposition Reviewer Report — Article 60 (Schmitt 2018)

**Verdict:** PASS
**Date:** 2026-04-18

## Applicability
- treatment_timing = "staggered", data_structure = "panel", allow_unbalanced = false: APPLICABLE.
- Note: metadata has `run_bacon: false`, but bacon.csv exists with 122 rows of decomposition data. The decomposition was in fact computed. This reviewer uses the available data.

## Checklist

### 1. Composition of TWFE weight
| Component | Weight | Description |
|-----------|--------|-------------|
| Treated vs Untreated (TVU) | 0.9379 (93.8%) | Clean comparisons: treated cohort vs 3032 never-treated |
| Later vs Earlier (LvE) + Earlier vs Later (EvL) | 0.0621 (6.2%) | Forbidden comparisons: one treated cohort as control for another |

- TVU dominates at 93.8%. This is a very favorable composition — the never-treated group (3032 hospitals) is large and provides most of the identifying variation. PASS.
- Forbidden comparisons contribute only 6.2% of weight. The risk that already-treated outcomes contaminate TWFE is minimal.

### 2. TVU estimates by cohort
| Cohort | Estimate | Weight | Comment |
|--------|----------|--------|---------|
| 2000 | +0.1139 | 0.2169 | Largest weight; positive |
| 2001 | +0.0195 | 0.1165 | Positive |
| 2002 | +0.0890 | 0.0985 | Positive |
| 2003 | -0.0121 | 0.0723 | Negative — small |
| 2004 | +0.0110 | 0.0606 | Near zero |
| 2005 | +0.0715 | 0.0310 | Positive |
| 2006 | +0.0092 | 0.0878 | Near zero |
| 2007 | -0.0015 | 0.0656 | Near zero negative |
| 2008 | +0.0949 | 0.0868 | Positive |
| 2009 | +0.1287 | 0.0537 | Positive |
| 2010 | -0.0784 | 0.0482 | Negative — most concerning |

- TVU weighted mean: 0.0531, close to CS-NT ATT of 0.0529. PASS — the decomposition is internally consistent.
- Cohort heterogeneity: estimates range from -0.078 (cohort 2010) to +0.129 (cohort 2009). This is moderate heterogeneity, but most cohorts are positive. The two largest-weight cohorts (2000 at 21.7% and 2001 at 11.6%) are both positive.
- Cohort 2010 is negative (-0.078) but has modest weight (4.8%). Cohorts 2007 and 2003 are near zero.

### 3. Negative-weight risk assessment
- With 93.8% TVU weight and only 6.2% forbidden comparisons, the TWFE estimate is overwhelmingly a clean estimand.
- The TVU weighted mean (0.053) is nearly identical to CS-DID ATT (0.053), confirming that the TWFE staggered-adoption bias is negligible here.
- Even if forbidden comparisons were corrupted, their 6.2% share cannot materially shift the overall estimate.

### 4. Treatment timing distribution
- 11 cohorts spanning 2000–2010. The earliest cohort (2000) has the largest weight (21.7%), consistent with it having the longest post-treatment window.
- No evidence of a single dominant cohort driving the result.

### 5. Conclusion
The Bacon decomposition is highly favorable for Schmitt (2018). The TWFE estimate is 93.8% clean TVU variation, with the TVU weighted mean matching CS-DID almost exactly. Cohort heterogeneity exists (range -0.08 to +0.13) but does not materially distort the TWFE. This is one of the stronger Bacon profiles in the study sample.

**Verdict: PASS**
