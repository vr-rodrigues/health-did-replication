# Bacon Decomposition Reviewer Report: Article 2303 — Cao & Ma (2023)

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer axis:** Methodology

---

## Applicability

APPLICABLE: treatment_timing = "staggered", data_structure = "panel", allow_unbalanced = false.

---

## Checklist

### 1. Decomposition structure

- 15,625 pairwise DiD comparisons in the Bacon decomposition (125 cohorts → very large pairwise combination space).
- Two comparison types present: "Later vs Earlier Treated" (LvE) and "Earlier vs Later Treated" (EvL). Note: with 487 never-treated plants, there are also "Treated vs Never-Treated" (TvNT) comparisons — these are the clean comparisons.
- The presence of EvL comparisons confirms **forbidden comparisons**: some treated cohorts serve as controls for earlier-treated cohorts at periods when they are already treated. This is the core Bacon negative-weight concern.

### 2. Cohort heterogeneity

- Point estimates across pairwise comparisons range from approximately −88 (cohort 160 vs cohort 108: −88.2) to +45 (cohort 140 vs cohort 108: +44.8).
- The extreme spread of estimates (range >130 fire events) signals **large treatment effect heterogeneity across cohorts**. Some cohort pairs show large positive estimates (possibly reflecting pre-existing trends or confounding), while the majority are negative.
- This heterogeneity is the mechanism by which TWFE can produce a biased aggregate estimate: the weights placed on early vs late comparisons and TvNT comparisons drive the overall estimate.

### 3. Negative weighting concern

- Individual pair weights are very small (all on the order of 1e-7 to 1e-4), consistent with a large panel (954 plants × 228 months).
- Both LvE and EvL types are present. EvL comparisons, by construction, use already-treated units as controls. In a setting with heterogeneous effects, these EvL weights are negative contributors to the TWFE estimand.
- The overall weighted mean of −4.836 (matching TWFE) is composed of these heterogeneous comparisons. The clean TvNT comparisons (treated vs never-treated) likely dominate given the large NT pool (487 plants), which is reassuring. However, the LvE/EvL pairs add noise and potential bias.

### 4. Treatment vs Never-Treated dominance

- With 487 never-treated plants out of 954 total (51%), TvNT comparisons should carry substantial weight in the Bacon decomposition, partially offsetting the forbidden-comparison contamination. This is a favorable structural feature of this dataset.
- The convergence of TWFE (−4.836) and CS-NT (−5.441) estimates suggests TvNT comparisons dominate and the negative-weight contamination is limited in magnitude.

### 5. Practical significance

- Given that TWFE (−4.836) and CS-NT simple (−5.441) are reasonably close (12% gap), the negative-weight bias in this specific design appears modest. The large NT pool provides a clean anchor.
- Gardner/did2s (an imputation-based estimator robust to treatment-effect heterogeneity) is available from the event study and shows post-treatment effects that are consistently negative, further corroborating the direction.

---

## Summary

**WARN.** The Bacon decomposition confirms staggered adoption with 125 cohorts, producing 15,625 pairwise comparisons with extremely heterogeneous individual estimates (range: approximately −88 to +45). Both LvE and EvL comparison types are present, confirming forbidden comparisons and potential negative weights. However, the large never-treated pool (487/954 = 51%) likely causes TvNT comparisons to dominate the overall TWFE weight, and the close convergence between TWFE (−4.836) and CS-NT (−5.441) suggests practical negative-weight bias is modest. The heterogeneity in cohort-pair estimates is nevertheless large and warrants caution about the interpretation of any single weighted aggregate.

**Flags:**
- 125 cohorts → 15,625 pairwise comparisons; extreme estimate heterogeneity (range >130 units).
- EvL forbidden comparisons confirmed — negative TWFE weights exist.
- Large NT pool (51%) partially mitigates negative-weight concern.
- Convergence of TWFE and CS-NT suggests practical bias is modest, not eliminatory.
