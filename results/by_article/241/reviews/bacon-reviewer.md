# Bacon Decomposition Reviewer Report — Article 241 (Soliman 2025)

**Verdict:** PASS
**Date:** 2026-04-19
**Re-run reason:** Updating for post-fix context; Bacon results unchanged (run on full panel, independent of TWFE filter).

## Applicability
- treatment_timing = "staggered", data_structure = "panel", allow_unbalanced = false → APPLICABLE.
- Note: metadata has `run_bacon: false` (template cannot run Bacon on the filtered TWFE sample while keeping CS on full sample). Bacon.csv was generated via a prior standalone script on the full unfiltered panel. Results are valid and used here.

## Checklist

### 1. Decomposition composition

| Type | Total weight | Notes |
|---|---|---|
| Treated vs Untreated (TvU) | ~98.7% | 8 cohorts vs 2,911 never-treated |
| Later vs Earlier Treated | ~0.7% | Negligible; 28 cohort pairs |
| Earlier vs Later Treated | ~0.6% | Negligible; 28 cohort pairs |

- **TvU dominates at 98.7%.** TWFE estimate is overwhelmingly driven by clean never-treated comparisons. Contamination from forbidden 2x2 comparisons is negligible. PASS.

### 2. TvT (Treated vs Treated) share diagnostic
- Combined TvT weight (Later + Earlier vs Treated) ≈ 1.3%.
- Threshold for concern: TvT share > 30%. At 1.3%, this is well within the safe range. D-ROBUST signal on this sub-criterion.

### 3. Cohort heterogeneity
- Treated-vs-Untreated estimates by cohort:
  | Cohort | Weight | Estimate |
  |---|---|---|
  | 2007 | 3.9% | -101.2 |
  | 2008 | 8.5% | -38.3 |
  | 2009 | 19.7% | -40.7 |
  | 2010 | 29.2% | -33.3 |
  | 2011 | 15.8% | -77.8 |
  | 2012 | 16.4% | **+3.2** |
  | 2013 | 4.3% | -64.9 |
  | 2014 | 1.0% | -34.6 |
- The 2012 cohort has a positive estimate (+3.19 MME/capita, weight 16.4%). This is directionally opposite to all other cohorts and pulls the TWFE aggregate toward zero.
- This cohort heterogeneity is a design finding: TWFE masks it; CS-DID estimates cohort-specific ATTs and reveals the full picture. NOT an implementation flaw.

### 4. Negative weights / sign reversal risk
- With TvT weight < 2%, negative weighting risk from forbidden comparisons is minimal.
- The positive 2012 cohort estimate within TvU is a genuine effect heterogeneity finding (not a negative weight artifact), since 2012 is being compared against never-treated units.

### 5. Weighted average consistency
- Bacon-weighted sum consistent with TWFE = -33.65 (the Bacon was run on the unfiltered full panel, so it reproduces the unfiltered TWFE, not the filtered -31.52). Internally consistent. PASS.

## Implementation findings
None. Bacon run on full panel is correct; the TvT contamination is negligible.

## Design findings (Axis 3)
- TvT share = 1.3% → ROBUST on this criterion.
- 2012 cohort heterogeneity (+3.19 with 16.4% weight) is a substantive finding about treatment effect heterogeneity across adoption cohorts. Favours using CS-DID to disaggregate.

**Overall:** PASS
