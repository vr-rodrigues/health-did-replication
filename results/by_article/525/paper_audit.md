# Paper fidelity audit: 525 — Danzer & Zyska (2023)

**Verdict:** WITHIN_TOLERANCE
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Table 3 Col 2: DID = -0.008 (SE 0.003), N = 1,442,376."

Table 3 Col 2 corresponds to the DID regression for women ages 15–44 with year and region fixed effects but no individual, job, household, or regional/group covariates. This is the second column in the stepwise covariate inclusion sequence — the first specification that adds year and region FEs to a bare-bones model. The paper text confirms the effect is "highly significant reform effect... around 1 percentage point irrespective of the chosen specification," and Col 2 is the first FE-augmented column and the one explicitly documented in metadata notes.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 2, women 15–44) | −0.008 | (0.003) | 1,442,376 | 26 Brazilian states | *** (implied by text) |
| Our stored results.csv (beta_twfe) | −0.007763 | 0.002844 | not stored | clustervar1 (states) | — |
| Relative Δ | +2.96% | −5.19% | | | |

## Notes
- The paper reports the coefficient to 3 decimal places as −0.008; our stored value is −0.007763, a difference of 0.000237 in absolute terms.
- The metadata `twfe_controls` includes `TREAT` (the rural indicator), matching the paper's Col 2 structure which adds state FEs but not individual covariates. The template also absorbs year FEs via the time fixed effect, consistent with Col 2.
- SE divergence is −5.19%, well within the 30% tolerance threshold; both report ~0.003.
- The paper notes Col 2 uses "year and region FE" — our implementation uses `clustervar1` (state) for clustering, matching the paper's 26-state cluster structure.
- N is not stored in results.csv; the paper reports N = 1,442,376 for the full short-run sample, consistent with the metadata notes.
- The rounding in the paper (−0.008 shown to 3 dp) means the true printed value could be anywhere from −0.0075 to −0.00849. Our estimate of −0.007763 sits squarely within that published rounding band, so the true underlying relative difference is likely smaller than 2.96%.

## Verdict rationale
Our stored beta (−0.007763) reproduces the paper's Table 3 Col 2 figure (−0.008) with a relative difference of 2.96%, which falls in the WITHIN_TOLERANCE band (1–5%); the small discrepancy is consistent with rounding in the published table (−0.008 reported to 3 decimal places).
