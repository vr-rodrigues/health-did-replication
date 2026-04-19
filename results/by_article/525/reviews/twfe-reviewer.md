# TWFE Reviewer Report — Article 525
# Danzer & Zyska (2023) — Pensions and Fertility: Microeconomic Evidence

**Verdict:** WARN
**Date:** 2026-04-18

---

## Checklist

### 1. Treatment variable specification

- `treatment_twfe = "DID"` — This is a pre-constructed interaction variable (TREAT × AFTER), which encodes the DiD structure directly.
- `twfe_controls = ["TREAT"]` — The treatment group indicator is included as a control. This is the standard "with TREAT" specification.
- The template always adds unit FEs (`clustervar1`) and time FEs (`syear`). Because `DID` is a pre-constructed product of TREAT and a post-indicator, including `DID` plus unit FEs and time FEs is appropriate: unit FEs absorb the TREAT main effect, time FEs absorb the AFTER main effect, and `DID` identifies the interaction. The inclusion of `TREAT` as an additional control alongside unit FEs is redundant (unit FEs subsume it for the static case), but does not bias the estimate.
- **WARN**: The original paper (Table 3 Col 2) uses individual-level OLS without explicit unit FEs — it clusters by state (clustervar1) but the unit of variation in the treatment is at the group (rural/urban × state × year) level, not the individual level. The template adds unit+time FEs where `unit_id = clustervar1` (state). This is a coarser fixed effect than individual FEs, but appropriate given the data structure (RCS, no individual identifier).
- **WARN**: `beta_twfe_no_ctrls = +0.0349` is dramatically different in sign and magnitude from `beta_twfe = -0.00776`. The "no controls" model omits TREAT from the regression. Since `TREAT` is the main-effect group indicator and the data is a repeated cross-section, removing it while retaining unit FEs does not fully control for group composition differences. The sign reversal is a red flag: it suggests either (a) TREAT is absorbing a large pre-existing level difference between rural and urban workers, or (b) the unit FEs (`clustervar1` = state) do not adequately control for systematic differences between the rural and urban subpopulations within states. The paper's design relies on TREAT being in the model to identify the DiD coefficient off the interaction (`DID = TREAT × AFTER`).

### 2. Data structure alignment

- `data_structure = "rcs"` (repeated cross-section, PNAD surveys)
- `unit_id = clustervar1` (Brazilian states, 26 clusters)
- N = 1,442,376 individuals per the metadata notes
- The PNAD has missing years (no 1991 or 1994 surveys). The analysis uses years present in the data — this creates non-contiguous time series but is unavoidable given the survey design. The template handles this correctly since `feols` is flexible about unbalanced panels.
- The `allow_unbalanced = true` setting is appropriate.

### 3. Standard errors

- Clustering at the state level (`clustervar1`, 26 clusters) matches the paper's specification.
- 26 clusters is borderline small for cluster-robust inference. The Cameron-Miller (2015) rule of thumb suggests concerns below 30–40 clusters. With 26 clusters the reported SEs may be slightly downward-biased. The paper is aware of this (they use state clustering explicitly).
- `se_twfe = 0.00284` for `beta_twfe = -0.00776` gives t ≈ 2.73 — statistically significant at 1%.

### 4. Sample filter

- `sample_filter = "rwb2 == 1 | uwb2 == 1"` — selects rural workers (treated) or urban workers (control). This is the correct comparison group as described in the paper's design.
- The filter is correctly specified in R syntax.

### 5. Fixed effects

- Unit FE: `clustervar1` (state) — 26 states
- Time FE: `syear` (survey year)
- No additional FEs specified. The paper uses individual-level OLS so additional demographic controls would have been appropriate, but none are specified in metadata.

### 6. Numerical proximity to paper

- Paper Table 3 Col 2: DID = -0.008 (SE 0.003)
- Our TWFE: beta = -0.00776 (SE = 0.00284)
- Ratio: -0.00776 / -0.008 = 0.970 — within 3% of paper's reported value. Excellent match.
- SE ratio: 0.00284 / 0.003 = 0.947 — within 6%. Good match.

### 7. Sign reversal in no-controls specification

- `beta_twfe_no_ctrls = +0.0349` (positive) vs `beta_twfe = -0.00776` (negative)
- This is a 4.5x magnitude difference with sign reversal. The "no controls" specification drops `TREAT` from the covariates. In a DiD with pre-constructed `DID = TREAT × AFTER`, the `TREAT` control is essential for identifying the DiD coefficient cleanly. Without it, the coefficient on `DID` picks up both the treatment effect AND the differential in levels between the rural and urban populations not absorbed by state or year FEs.
- This large sensitivity to the inclusion of TREAT is not unusual for this type of design, but it is a methodological flag: inference is highly sensitive to the inclusion of the group indicator.

---

## Summary of findings

| Check | Status |
|---|---|
| Treatment variable correctly specified | PASS |
| Data structure appropriate | PASS |
| Clustering matches paper | PASS |
| Sample filter correct | PASS |
| Numerical proximity to paper | PASS (within 3%) |
| Sign stability (no-controls vs controls) | WARN — sign reversal |
| Small cluster concern (26 clusters) | WARN |

**Overall Verdict: WARN** — The headline TWFE estimate matches the paper within 3% and the specification is correctly implemented. Two concerns: (1) the no-controls specification produces a sign reversal, indicating sensitivity to the TREAT control; (2) 26 clusters is below the conventional threshold for reliable cluster-robust inference. Neither concern invalidates the headline result, but both should be noted.
