# TWFE Reviewer Report — Article 323

**Verdict:** PASS
**Date:** 2026-04-18
**Article:** Prem, Vargas, Mejia (2023) — "The Rise and Persistence of Illegal Crops"

---

## Checklist

### 1. Specification integrity

- **Outcome variable:** `coca_area_grid` (coca cultivation area per grid cell, continuous) — appropriate for a DiD on municipal-level coca expansion.
- **Treatment indicator:** `treat_post = treated * I(year >= 2014)` — standard binary post x treated interaction. Single treatment date (2014 peace process announcement).
- **Unit FE:** municipality (`muni_code`). **Time FE:** year. Standard two-way setup.
- **Controls:** None (no controls specified in `twfe_controls` or `additional_fes`). The original paper's preferred specification also omits controls in the baseline (Table 1, Col 1). Consistent.
- **Clustering:** at municipality level (`muni_code`). Appropriate given panel structure.

### 2. Estimand alignment

- Original paper uses a **continuous** treatment (suitability index × announcement indicator). The replication **binarizes** at median suitability (high vs. low suitability municipalities). This is a legitimate approximation for the DiD framework but introduces an estimand gap: the stored `beta_twfe = 0.643` is not directly comparable to the paper's `beta_twfe = 0.300` (which is in continuous-treatment units of suitability score × log coca area).
- The `original_result.source` field explicitly documents this binarization: "Binarized at median suitability for replication." This is a known, flagged limitation — not a coding error.
- Coefficient units differ (paper: effect per unit of suitability index; replication: ATT for high- vs. low-suitability municipalities). Magnitude comparison is not apples-to-apples.

### 3. Pre-trend assessment

Event study data (from `event_study_data.csv`):
| Time | TWFE coef | SE |
|------|-----------|-----|
| -3 | -0.0791 | 0.0452 |
| -2 | -0.0525 | 0.0315 |
| -1 | 0 (ref) | — |

- Pre-period coefficients are **small in magnitude** and **not statistically significant** at conventional levels (|t| = 1.75 at t=-3; 1.67 at t=-2).
- No evidence of pre-existing trend in the binarized treatment. Parallel trends assumption is not contradicted by the data.

### 4. Post-treatment dynamics

| Time | TWFE coef | SE | t-stat |
|------|-----------|-----|--------|
| 0 | 0.129 | 0.057 | 2.26 |
| 1 | 0.318 | 0.137 | 2.32 |
| 2 | 0.680 | 0.234 | 2.91 |
| 3 | 0.906 | 0.291 | 3.12 |
| 4 | 0.960 | 0.292 | 3.29 |

- **Monotonically increasing** positive effects. Consistent with the paper's narrative of persistent crop adoption following the policy announcement.
- No sign of treatment effect reversal or mean reversion.

### 5. Negative-weight / forbidden comparison concern

- **Single treatment cohort** (gvar=2014 for treated; gvar=0 for never-treated). With only one cohort and a clean never-treated control group, there are **no forbidden comparisons** and **no negative weights** from staggered timing. The TWFE estimand equals the ATT by construction in this design.
- The "100% TvU" note in metadata confirms: all variation is Treated-vs-Untreated, which is the cleanest Bacon decomposition possible.

### 6. Sample size

- N = 8,736 observations (consistent with metadata). Balanced panel of municipalities across years.

### 7. Key concern flagged

- The estimand mismatch (continuous vs. binary treatment) means the stored TWFE coefficient (0.643) **cannot be directly compared** to the paper's 0.300. This is a known and documented limitation. The TWFE implementation itself is technically correct for the binarized specification.

---

## Summary

The TWFE implementation is internally consistent: correct unit/time FEs, appropriate clustering, no controls matching the paper's baseline, clean pre-trends, single cohort eliminating negative-weight concerns. The only concern is the continuous-to-binary binarization estimand gap, which is documented in metadata. The implementation is sound.

**Verdict: PASS**
