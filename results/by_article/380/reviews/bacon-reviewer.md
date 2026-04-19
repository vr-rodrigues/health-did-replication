# Bacon Decomposition Reviewer Report — Article 380
## Kuziemko, Meckel & Rossin-Slater (2018)

**Verdict:** WARN
**Date:** 2026-04-18

---

## 1. Decomposition Summary

The Bacon decomposition decomposes the TWFE estimate (+0.068) into weighted averages of 2x2 DD comparisons across groups and time periods.

### Treated vs. Untreated (clean comparisons)

| Treated cohort | Estimate | Weight |
|---|---|---|
| 23961 vs never | -0.077 | 0.232 |
| 23979 vs never | -0.070 | 0.232 |
| 23989 vs never | -0.208 | 0.244 |
| 23952 vs never | +0.278 | 0.106 |
| 23976 vs never | -1.306 | 0.039 |
| **Total clean weight** | | **~0.855** |

### Within-treated comparisons (Later vs Earlier / Earlier vs Later)

| Pair | Estimate | Weight | Type |
|---|---|---|---|
| 23979 vs 23961 | -0.172 | 0.013 | Later vs Earlier |
| 23989 vs 23961 | +0.155 | 0.018 | Later vs Earlier |
| 23952 vs 23961 | +0.453 | 0.003 | Earlier vs Later |
| 23976 vs 23961 | +0.300 | 0.002 | Later vs Earlier |
| 23961 vs 23979 | -0.065 | 0.013 | Earlier vs Later |
| 23989 vs 23979 | -0.449 | 0.006 | Later vs Earlier |
| 23952 vs 23979 | +0.800 | 0.008 | Earlier vs Later |
| 23976 vs 23979 | -2.644 | 0.000 | Earlier vs Later |
| 23961 vs 23989 | +0.082 | 0.023 | Earlier vs Later |
| 23979 vs 23989 | -0.477 | 0.012 | Earlier vs Later |
| 23952 vs 23989 | +0.850 | 0.012 | Earlier vs Later |
| 23976 vs 23989 | -1.930 | 0.002 | Earlier vs Later |
| 23961 vs 23952 | +0.010 | 0.004 | Later vs Earlier |
| 23979 vs 23952 | +1.008 | 0.010 | Later vs Earlier |
| 23989 vs 23952 | +0.890 | 0.012 | Later vs Earlier |
| 23976 vs 23952 | +0.815 | 0.002 | Later vs Earlier |
| 23961 vs 23976 | +2.200 | 0.002 | Earlier vs Later |
| 23979 vs 23976 | -1.473 | 0.000 | Later vs Earlier |
| 23989 vs 23976 | -0.870 | 0.001 | Later vs Earlier |
| 23952 vs 23976 | +2.999 | 0.001 | Earlier vs Later |
| **Total within-treated weight** | | **~0.145** |

---

## 2. Cohort Heterogeneity Assessment

**Treated-vs-untreated range:** -1.306 to +0.278. This is a wide range — a 1.584 percentage-point spread — relative to the static TWFE estimate of +0.068. The dominant clean comparison estimates are all negative (3 of 5 with the highest weights), while one is positive and one is extreme (-1.306 for cohort 23976).

**Cohort 23976** is notable:
- vs never-treated: -1.306 (weight 0.039)
- vs earlier cohorts 23961, 23979, 23989: +0.300, -2.644, -1.930 (very extreme)
- This cohort appears highly anomalous, potentially a late-adopter with unusual mortality patterns

**Sign of aggregate TWFE (+0.068):** The aggregate TWFE is positive despite most clean comparisons being negative. This occurs because the positive cohort 23952 estimate (+0.278) combined with "Earlier vs Later" contamination (23961 vs 23976: +2.200; 23952 vs 23976: +2.999) pulls the weighted average positive. This is concerning — the positive TWFE is partly driven by treated-vs-treated comparisons using already-treated counties as controls.

---

## 3. Forbidden Comparison Contamination

The "Earlier vs Later Treated" comparisons (earlier-treated units used as controls for later-treated units during their pre-treatment period) include large and extreme estimates (+2.200, +2.999, +0.800, +0.850). While their individual weights are small (0.001-0.012), they collectively contribute to the upward bias in the TWFE aggregate. The presence of such extreme values suggests treatment effect heterogeneity across cohorts is substantial.

---

## 4. Weight Distribution

- Clean (treated vs untreated) weight: ~85.5% — good
- Within-treated (potentially contaminated) weight: ~14.5%
- The high clean weight suggests TWFE is not severely contaminated by forbidden comparisons in aggregate

---

## 5. Verdict Rationale

**WARN** on two grounds:
1. Very high heterogeneity across cohorts in the clean 2x2 DDs (range: -1.306 to +0.278): the TWFE aggregate does not represent any single well-defined ATT, and the positive aggregate conceals negative point estimates for most high-weight cohorts
2. Cohort 23976 is anomalous with extreme within-treated estimates, suggesting it may be an outlier that disproportionately influences the aggregate through nonlinear weighting

The ~85% clean weight is reassuring but does not eliminate the concern that TWFE is averaging over fundamentally heterogeneous effects.

---

*Full data: `results/by_article/380/bacon.csv`*
