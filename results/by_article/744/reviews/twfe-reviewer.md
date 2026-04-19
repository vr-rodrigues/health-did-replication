# TWFE Reviewer Report — Article 744

**Article:** Jayachandran, Lleras-Muney & Smith (2010) — "Modern Medicine and the 20th Century Decline in Mortality"
**Reviewer:** twfe-reviewer
**Date:** 2026-04-18
**Verdict:** WARN

---

## Checklist

### 1. Estimand clarity
- [PASS] Treatment variable is clearly defined: `treatedXpost37` (MMR disease indicator × post-1937 indicator)
- [PASS] Comparison group is explicit: tuberculosis (disease=4) as never-treated control
- [PASS] Outcome is `lnm_rate` (log mortality rate) — standard log-linearisation

### 2. Fixed effects specification
- [WARN] The FE structure uses `statepost` (state × post-period dummies) rather than standard unit (`state_disease`) + time (`year`) FEs. This is an unusual absorbing structure that conflates state-level heterogeneity with the treatment timing itself. It means that the TWFE is not estimating a standard two-way FE model.
- [WARN] The original Stata spec (`areg ... absorb(statepost)`) creates a FE for each state × post-1937 cell, which effectively differences out state-level pre/post trends rather than state-level levels. This is closer to a triple-differences design than a standard TWFE.
- [PASS] Controls `treatedXyear_c`, `treated`, `year_c` are included per original paper specification

### 3. Control variable handling
- [WARN] `beta_twfe_no_ctrls = 13.616` vs `beta_twfe = -0.281` — the estimate flips sign and explodes in magnitude when the linear trend controls are removed. This extreme sensitivity suggests the result is heavily dependent on the parametric trend-adjustment, which is itself a strong functional-form assumption. The "no-controls" TWFE is nonsensical (positive 13.6 log-point mortality increase), indicating that without the trend controls the parallel trends assumption is badly violated.

### 4. Clustering
- [PASS] Cluster by `diseaseyear` (disease × year) — matches original paper's clustering strategy exactly

### 5. Sample
- [PASS] Panel 1925–1943, two diseases (MMR and TB), single treatment year (1937)
- [PASS] `is.finite(lnm_rate)` filter removes zero-mortality observations appropriately

### 6. Parallel trends
- [WARN] Event study (see `event_study_data.csv`) shows a strong monotonic pre-trend drift in TWFE: coef at t=-12 is -0.259, trending toward zero at t=-3 (+0.013). This U-shaped pre-period pattern in log-mortality differences between MMR and TB diseases is a concern. It may reflect genuine disease-level divergence in trends unrelated to sulfa drugs, or it may be partially absorbed by the `treatedXyear_c` linear trend control (which is designed to do exactly this).
- [NOTE] The fact that the linear trend control is included specifically to handle diverging pre-trends means the TWFE estimate is a residual after partialling out a linear trend — a legitimate but model-dependent approach.

### 7. Estimate magnitude
- [PASS] `beta_twfe = -0.281` (28% decline in mortality rate) is economically plausible for the introduction of sulfa drugs, consistent with prior literature

---

## Summary of concerns

| # | Severity | Finding |
|---|---|---|
| 1 | WARN | Non-standard `statepost` FE absorbing structure — closer to triple-diff than TWFE |
| 2 | WARN | Massive sensitivity to trend controls: no-controls estimate is +13.6 vs controlled -0.28 |
| 3 | WARN | Strong monotonic pre-trend drift in TWFE event study (t=-12: -0.26, t=-3: +0.01) |

Three WARNs present. Verdict: **WARN**

The main result (-0.281) is meaningful and economically plausible, but the specification is non-standard, the estimate is fragile to trend controls, and the pre-trend pattern raises parallel trends concerns.
