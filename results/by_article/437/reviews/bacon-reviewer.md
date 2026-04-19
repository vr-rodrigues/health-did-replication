# Bacon Decomposition Reviewer Report — Article 437 (Hausman 2014)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability
- treatment_timing = "staggered": YES
- data_structure = "panel": YES
- allow_unbalanced = true: The panel is unbalanced. Bacon decomposition was run (run_bacon = true in metadata). Results file exists (bacon.csv with 36 pair rows).
- APPLICABLE (with caveat about unbalanced panel).

## Checklist

### 1. Decomposition structure
- Total pairs in bacon.csv: 36 rows.
- Pair types present:
  - "Treated vs Untreated" (TVU): 6 rows (cohorts 2005, 2002, 2001, 2008, 2000, 2003 vs never-treated)
  - "Earlier vs Later Treated" (EvL): multiple rows
  - "Later vs Earlier Treated" (LvE): multiple rows

### 2. TVU vs. TVT decomposition
Computing TVU weight sum: 0.0712 + 0.1126 + 0.2481 + 0.0391 + 0.1344 + 0.0999 = 0.5053 (50.5%)
Computing TVT (EvL + LvE) weight sum: remaining 49.5%

- TVT weight is ~49.5% — significant "forbidden comparison" contamination.
- WARN: nearly half of TWFE weight comes from treated-vs-treated comparisons (forbidden Bacon pairs).

### 3. TVT pair direction (key diagnostic)
Selected TVT estimates (EvL = early treated used as untreated control for late treated):
- (2001 as untreated, 2005): -352.996 with weight 0.0207 — LARGE NEGATIVE
- (2000 as untreated, 2005): -607.764 with weight 0.0124 — LARGE NEGATIVE
- (2001 as untreated, 2008): -502.148 with weight 0.0724 — LARGE NEGATIVE
- (2000 as untreated, 2008): -681.748 with weight 0.0398 — LARGE NEGATIVE

These are "Earlier vs Later Treated" pairs: early-treated units serve as comparison for late-treated units during the late-treated unit's post period. Because personrem has a secular decline and early-treated units (which divested earlier) may be on different trajectories, these comparisons are contaminated by:
1. The secular decline in personrem making early-treated post-period observations lower than the never-treated counterfactual.
2. Early-treated units' personrem declining post-divestiture while they serve as "controls" for late-treated, creating spuriously negative estimates.

- WARN: TVT pairs (EvL) show very large negative estimates (-350 to -680 person-rem) that are economically implausible and likely reflect the secular trend contamination.

### 4. TVU pair estimates
- Cohort 2005 vs never-treated: +227.1 (weight 7.1%) — POSITIVE
- Cohort 2002 vs never-treated: +300.4 (weight 11.3%) — POSITIVE
- Cohort 2001 vs never-treated: -196.2 (weight 24.8%) — NEGATIVE (largest TVU weight)
- Cohort 2008 vs never-treated: +220.9 (weight 3.9%) — POSITIVE
- Cohort 2000 vs never-treated: -372.1 (weight 13.4%) — NEGATIVE (second largest TVU weight)
- Cohort 2003 vs never-treated: +301.3 (weight 10.0%) — POSITIVE

TVU estimates span from -372 to +301 person-rem — extreme heterogeneity across cohorts.
The two largest-weight TVU cohorts (2001 and 2000) are both negative, pulling the TVU-weighted average negative.

- WARN: extreme cohort heterogeneity in TVU estimates (range: -372 to +301 person-rem). The aggregate TWFE (-42.2) masks fundamentally inconsistent cohort-level effects.

### 5. Negative-weight contamination
- The combination of TVT forbidden pairs (49.5% weight) with implausible TVT estimates (-350 to -680) and extreme TVU heterogeneity means TWFE is a weighted average of economically contradictory estimates.
- The TWFE result (-42.2) is not a meaningful causal parameter — it is an artefact of the weighting scheme.
- WARN: TWFE does not estimate a well-defined weighted average treatment effect; it is contaminated by secular trend, composition effects, and forbidden comparisons simultaneously.

### 6. Summary decomposition (approximate)
| Component | Weight | Approx. contribution |
|---|---|---|
| TVU: cohort 2001 | 24.8% | -48.7 |
| TVU: cohort 2000 | 13.4% | -49.9 |
| TVU: cohort 2002 | 11.3% | +33.9 |
| TVU: cohort 2003 | 10.0% | +30.1 |
| TVU: cohort 2005 | 7.1% | +16.1 |
| TVU: cohort 2008 | 3.9% | +8.6 |
| TVT (EvL+LvE) | 49.5% | ~-28.3 (various) |
| **Total (approx)** | **100%** | **~-42** |

## Material concerns
1. WARN: TVT (forbidden) comparisons account for ~49.5% of TWFE weight
2. WARN: TVU cohort-level estimates span -372 to +301 person-rem (extreme heterogeneity)
3. WARN: TVT EvL pairs show -350 to -680 person-rem estimates (secular trend contamination)
4. WARN: TWFE does not estimate a meaningful causal parameter under this decomposition

## Summary
Bacon decomposition reveals severe contamination: ~50% of TWFE weight comes from forbidden treated-vs-treated pairs showing implausibly large negative estimates (-350 to -680 person-rem), while TVU estimates show extreme heterogeneity spanning -372 to +301 person-rem. The TWFE aggregate (-42.2) is an artefact of weighting mechanics, not a reliable causal estimate. Verdict: WARN.
