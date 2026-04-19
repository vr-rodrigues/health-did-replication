# Bacon Reviewer Report: Article 9 — Dranove et al. (2021)

**Verdict:** PASS
**Date:** 2026-04-18

---

## Applicability
- `treatment_timing = staggered`: YES
- `data_structure = panel`: YES
- `allow_unbalanced = false`: YES (balanced 29x26 panel)
- **APPLICABLE**

---

## Checklist

### 1. Decomposition structure
- 10 treated cohorts identified (quarterly: 205, 207, 208, 210, 212, 213, 215, 216, 220, 225).
- 1 never-treated group (coded 99999).
- Total rows: 101 (10 TVU pairs + 91 TVT pairs from 10-choose-2 = 45 cohort pairs × 2 directions).

### 2. Weight distribution

| Component | Weight | % |
|-----------|--------|---|
| Treated vs Untreated (TVU) | 0.785 | 78.5% |
| Treated vs Treated (TVT) | 0.215 | 21.5% |
| **Total** | **1.000** | **100%** |

TVU comparisons dominate at 78.5% — this is a healthy weight structure. The majority of TWFE identification comes from clean comparisons against never-treated states. TVT contamination is present but not dominant.

### 3. TVU estimates by cohort

| Cohort | Estimate | Weight |
|--------|----------|--------|
| 205 | +0.047 | 3.9% |
| 207 | -0.202 | 10.5% |
| 208 | -0.090 | 5.8% |
| 210 | -0.226 | 13.4% |
| 212 | -0.199 | 7.2% |
| 213 | -0.230 | 7.4% |
| 215 | -0.263 | 7.4% |
| 216 | -0.032 | 7.2% |
| 220 | -0.056 | 11.6% |
| 225 | -0.174 | 2.1% |

- 9 of 10 cohorts show negative TVU estimates. Only cohort 205 (the earliest adopter, 3.9% weight) shows a positive estimate (+0.047).
- The positive estimate for cohort 205 may reflect early adoption in states with different trajectories, but its low weight (3.9%) limits its influence on the aggregate.
- TVU weighted average: approximately -0.150 (computed from the table above).

### 4. TVT contamination assessment

Positive "later vs earlier" or "earlier vs later" estimates (which indicate contamination where early-treated units serve as "control" in later-treated units' DiD):
- 220 vs 210: +0.118 (weight 0.77%) — earlier-treated cohort 210 serves as control for later-treated cohort 220, showing positive differential, suggesting cohort 210 continued declining after cohort 220 adopted (a legitimate relative difference, not necessarily invalidity).
- 216 vs 210: +0.178 (weight 0.36%)
- 205 vs 216, 215, 213, 210, 207: several small positive entries with weights < 0.15%.

Positive-TVT total weight: approximately 4–5% of total TWFE weight. This is a minor contamination concern but not alarming given that:
1. TVU comparisons dominate at 78.5%.
2. Many positive TVT comparisons have tiny weights (< 0.2% each).
3. The direction of contamination (some later-vs-earlier comparisons being positive) is consistent with continued treatment effect buildup in early-treated cohorts — an economically interpretable phenomenon, not necessarily a sign of parallel trends failure.

### 5. Negative weights check
TWFE with staggered adoption can assign negative weights to some 2x2 DiDs. In this decomposition, the weights are all non-negative (Bacon decomposition produces only non-negative weights by construction). The concern is whether TVT estimates are systematically opposed in sign to the ATT — which they are not here (the majority of TVT estimates are also negative).

### 6. TWFE estimate vs Bacon-weighted average
- TWFE: -0.176
- CS-NT: -0.208
- The TWFE is smaller in magnitude than CS-NT, consistent with some upward bias from TVT contamination (positive TVT components pulling TWFE toward zero) and potentially from cohort 205's positive TVU estimate.
- The direction of the bias (TWFE undershooting the clean estimator) is expected and interpretable.

---

## Summary
Bacon decomposition reveals a well-structured identification: 78.5% of TWFE weight from clean TVU comparisons, with 9 of 10 cohorts showing negative treatment effects. TVT contamination is present (21.5% of weight) but minor in impact — most TVT estimates are also negative. The one anomalous cohort (205, earliest adopter) has a positive TVU estimate but contributes only 3.9% of total weight. The TWFE underestimates the ATT relative to CS-DID by approximately 15%, consistent with the mild upward contamination. No negative weights detected. This is an acceptable decomposition for a staggered design.

**Verdict: PASS**
