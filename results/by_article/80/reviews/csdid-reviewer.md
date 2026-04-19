# CS-DID Reviewer Report — Article 80

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** csdid-reviewer

---

## Checklist

### 1. Estimator applicability for RCS data
- CS (2021) was developed for panel or repeated cross-section data. The RCS extension requires that the analyst aggregate or work at the cohort×year level. The `csdid2` Stata implementation handles RCS natively.
- Our R implementation uses the `did` package (CS 2021), which is designed for panel data. Applying it to RCS data requires treating the student-level observations as if they were a pseudo-panel indexed by (cityno, year_3rd).
- **WARN:** The `did` package applied to RCS data may produce inconsistent standard errors if within-city within-year repeated observations are not properly accounted for. The metadata specifies `cs_cluster = "none"`, which means no clustering is applied in our CS estimation — this is likely wrong for RCS data where cityno clustering is appropriate.

### 2. Group variable construction
- `gvar_CS` is constructed as: if ever_tbula=1, then 2008, else 0 (never-treated code).
- This correctly assigns all treated cities to the single cohort g=2008.
- Group variable is constant within cityno (confirmed by preprocessing using group_by(cityno) max).
- **Construction: PASS.**

### 3. ATT comparison
- Our CS-NT ATT: 0.01991, SE 0.02779.
- Paper's CS ATT: 0.0058, SE 0.0118.
- Ratio of our SE to paper SE: 0.02779 / 0.0118 ≈ 2.35. Our SE is more than twice as large.
- Point estimate diverges substantially: 0.01991 vs 0.0058 (ratio ≈ 3.4).
- **WARN:** This divergence is large and warrants explanation.

### 4. Source of divergence
- The paper uses `csdid2` with `cluster(cityno)`, our implementation uses `did` package with `cs_cluster = "none"`. The lack of clustering inflates SE unexpectedly in the opposite direction here — our SE is larger, not smaller.
- More likely cause: the `did` package in R collapses RCS to a pseudo-panel, which changes the effective sample and weighting relative to Stata's `csdid2`.
- The SA event-study estimate (from our R run) at t=0 is 0.01773, while CS-NT at t=0 is 0.02332. These are closer to each other than to the paper's CSDID value of 0.0058.
- The paper's 0.0058 figure may come from a different aggregation (simple vs dynamic) or a different normalization period.
- **WARN:** CS-NT dynamic ATT aggregation (0.01991) is 3.4× the paper's reported CS ATT (0.0058). The discrepancy is most likely attributable to the RCS pseudo-panel aggregation and the absence of clustering in our CS implementation.

### 5. Pre-trend assessment
- CS-NT at t=-2: 0.01335, SE 0.04215. t-ratio ≈ 0.32. Not significant.
- Pre-trend is small relative to SE. No evidence of violation of parallel trends, but power is very low.
- **Pre-trends: PASS (conditional on low power).**

### 6. Comparison with other estimators
- Gardner (BJS): ATT ≈ 0.01538 (dynamic average of post periods). Close to CS-NT.
- SA: overlaps with TWFE exactly (single cohort, so SA = TWFE = expected).
- All modern estimators cluster around 0.012–0.020, while the paper's CSDID is 0.006. The paper's value may represent a different quantity (e.g., the t=0 effect only, or a different weighting).

### 7. Summary
The CS-NT estimate diverges substantially from the paper's reported CSDID value (0.020 vs 0.006). However, our estimate is broadly consistent with TWFE and BJS. The divergence is most plausibly explained by: (a) RCS pseudo-panel aggregation differences between R `did` and Stata `csdid2`, and (b) absence of cityno clustering in our CS run. Effect remains statistically insignificant across all estimators.

---

## Key findings
- CS-NT ATT (0.01991) is 3.4× the paper's reported CS value (0.0058).
- Divergence most likely attributable to RCS aggregation differences between `did` (R) and `csdid2` (Stata) and missing clustering.
- All estimators agree the effect is statistically insignificant.
- Pre-trend at t=-2 is small and non-significant.

