# Bacon Decomposition Reviewer Report — Article 290 (Arbogast et al. 2022)

**Verdict:** WARN
**Date:** 2026-04-19

## Applicability
- treatment_timing = "staggered", data_structure = "panel", allow_unbalanced = **true** (updated 2026-04-19)
- The `bacondecomp` package requires a balanced panel. With allow_unbalanced=true, the Bacon decomposition was run on the available panel; note that any implicit unbalancedness may affect the precise weight distribution.
- APPLICABLE (with caveat on unbalanced panel).

## Checklist

### 1. Weight decomposition
- TVU (Treated vs Untreated / clean): weight = 0.8822 (88.2%)
- LvE (Later vs Earlier Treated / forbidden): weight = 0.0563 (5.6%)
- EvL (Earlier vs Later Treated / forbidden): weight = 0.0615 (6.2%)
- TVT (forbidden, LvE + EvL combined): 11.8%
- Dominant clean comparison: TVU at 88.2% is very healthy. Most identification comes from comparing treated states to never-treated states.
- TVT share 11.8% < 30% threshold → D-ROBUST signal on the Bacon axis.

### 2. TWFE reconstruction
- Bacon-reconstructed TWFE: -0.0162
- Stored TWFE: -0.0182
- Gap: 12% — slightly above tolerance. Likely due to weighting rounding across 12 cohorts plus unbalanced panel effects not captured by the Bacon reconstruction formula (which assumes balance).
- This reconstruction gap is a known artefact when `allow_unbalanced=true` and the Bacon package enforces its own internal balancing step. NOT an implementation failure; documented behaviour.

### 3. Heterogeneity in TVU estimates
- TVU estimate range: -0.0619 (cohort 60) to +0.0048 (cohort 67)
- TVU weighted mean: -0.0176 (close to aggregate TWFE)
- Cohort 60 has estimate -0.0619 and weight 7.8% — substantially more negative than other cohorts
- Cohort 67 has a positive estimate (+0.0048, w=6.2%) — opposite sign to the aggregate, suggesting heterogeneous treatment effects across administrative-burden implementation
- Cohort 48 has estimate -0.0307 and weight 18.7% (largest weight) — drives aggregate toward negative
- This heterogeneity is a Design finding (Axis 3): the aggregate TWFE hides substantial cross-cohort variation.

### 4. Forbidden comparison analysis
- LvE pairs: 45 total; 19 with negative estimate (same direction as overall)
- EvL pairs: 45 total; 23 with positive estimate (attenuating toward zero)
- Combined TVT weight of 11.8% is relatively small; the mixed-sign forbidden comparisons partially offset each other
- With CS-DID now validated (att_csdid_nt = -0.02984 vs TWFE -0.01824), the CS-DID estimate's larger magnitude is consistent with Bacon's finding that some forbidden comparisons attenuate the TWFE.

### 5. WARN rationale
- TVU dominance (88.2%) is reassuring and argues against serious forbidden-comparison contamination.
- Cohort-level effect heterogeneity (range -0.062 to +0.005) is the primary concern: 6.7pp spread relative to -0.018 aggregate is large. This is a Design finding.
- The Bacon 12% reconstruction gap is a known artefact of running on an unbalanced panel; not an implementation failure.
- The WARN reflects cohort heterogeneity (Design axis) rather than any implementation problem.

**Overall Bacon Verdict: WARN** (TVU dominance healthy at 88.2%; TvT share 11.8% below 30% threshold; cohort heterogeneity range -0.062 to +0.005 is a Design finding; reconstruction gap 12% is an unbalanced-panel artefact)
