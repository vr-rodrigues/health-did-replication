# Bacon Decomposition Reviewer Report — Article 253 (Bancalari 2024)

**Verdict:** WARN

**Date:** 2026-04-18

## Applicability
- treatment_timing = "staggered": YES
- data_structure = "panel": YES
- allow_unbalanced = false: YES (balanced panel enforced)
- `run_bacon = false` in metadata: Bacon was skipped by the analyst. However, bacon.csv IS present in results (the decomposition was computed). APPLICABLE — reviewing from available data.

## Checklist

### 1. Decomposition structure
The bacon decomposition (bacon.csv) contains 111 pairwise comparisons across 11 cohorts (2005-2015) plus the never-treated group (99999).

**Component summary by type:**
- **Treated vs Untreated (TVU):** 11 pairs (one per cohort vs never-treated). This is the "clean" component.
- **Later vs Earlier Treated (LvE):** Uses later-adopting cohorts as treated, earlier-adopting as controls. These are forbidden comparisons under TWFE when effects are heterogeneous.
- **Earlier vs Later Treated (EvL):** Uses earlier-adopting cohorts as treated, later-adopting as controls. Also potentially contaminated.

### 2. Weight distribution analysis
TVU pairs (clean comparisons):
- Cohort 2007 vs NT: estimate=3.096, weight=0.0463 (largest TVU weight)
- Cohort 2009 vs NT: estimate=3.583, weight=0.0572 (largest TVU weight)
- Cohort 2005 vs NT: estimate=0.842, weight=0.0045
- Cohort 2015 vs NT: estimate=5.120, weight=0.0015

Selected "forbidden comparison" pairs (LvE/EvL):
- Cohort 2006 vs 2005: estimate=-3.267, weight=0.00361 (Later vs Always Treated — NEGATIVE WEIGHT CANDIDATE)
- Cohort 2006 vs 2007: estimate=-3.176, weight=0.000701 (Earlier vs Later — negative, later cohort used as control)
- Cohort 2007 vs 2005: estimate=-0.525, weight=0.0368 (Later vs Always Treated)
- Cohort 2012 vs 2011: estimate=-3.992, weight=0.00222 (Earlier vs Later — large negative estimate)
- Cohort 2014 vs 2007: estimate=7.046, weight=0.0082 (Earlier vs Later — large positive)
- Cohort 2015 vs 2013: estimate=5.431, weight=0.000117 (Later vs Earlier — tiny weight)

### 3. Forbidden comparison concern (LvE/EvL)
With 11 cohorts covering 2005-2015, the majority of pairwise comparisons are LvE or EvL type. Many estimates in these pairs are:
- Large in magnitude (range: approximately -8 to +7 across all pairs)
- Sign-discordant with the TVU estimates (many forbidden pairs show negative estimates while TVU are all positive)
- This pattern is consistent with TWFE weighting contamination under heterogeneous, growing effects

### 4. Negative-weight assessment
The "Later vs Always Treated" pairs (cohorts treated vs 2005 as pseudo-control) show systematically negative estimates:
- Cohort 2006 vs 2005: -3.267 (weight 0.36%)
- Cohort 2007 vs 2005: -0.525 (weight 3.68%)
- Cohort 2009 vs 2005: -0.705 (weight 4.55%)
- Multiple later cohorts vs 2005: all negative
- This implies cohort 2005 (always-treated in practice given its 2005 initiation date) is being used as a control for later cohorts. This is a textbook forbidden comparison and introduces negative-weight bias.

### 5. Impact on TWFE estimate
The TWFE (+0.74) sits well below the CS-NT (+2.35-2.97) and CS-NYT (+2.51-2.95), consistent with TWFE being attenuated by negative-weight forbidden comparisons. The paper itself acknowledges this (notes: "Paper finds CS ATT = +1.79 vs TWFE +0.74 (TWFE attenuated)").

The Bacon decomposition confirms this mechanically: forbidden LvE/EvL comparisons with negative estimates (especially those using cohort 2005 as control) pull the TWFE estimate downward.

### 6. Verdict reasoning
The Bacon decomposition reveals meaningful negative-weight contamination from forbidden comparisons. While the direction of the overall effect is unambiguous (positive across all TVU pairs), the TWFE point estimate (+0.74) is mechanically attenuated relative to the true ATT. The cohort 2005 "always-treated" problem is acute given 11 cohorts and growing effects. This warrants a WARN rather than PASS.

**Verdict: WARN** — Forbidden LvE/EvL comparisons with negative estimates; cohort-2005-as-control pattern attenuates TWFE by ~1-2 units relative to the CS-DID ATT.

_Full data path: `results/by_article/253/bacon.csv`_
