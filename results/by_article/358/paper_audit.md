# Paper fidelity audit: 358 — Bargain, Boutin, Champeaux (2019)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata `original_result.source` and `notes`: Table 1, Column 4 (Model 4 — Baseline). Outcome: `ibp` composite empowerment index (MCA on ternary final-say questions, scale 0–100). Regressor: Post x Treat (post_group). Specification includes individual controls (wealth, urban, education of wife and husband, husband employment status), birth cohort dummies, municipality dummies, and POST x covariate interactions. Cluster at municipality (ID_2). N = 27,782 observations (2008 and 2014 DHS waves, excluding 5 border governorates).

The paper explicitly designates this as its main/baseline DiD estimate (Section 4.1, "Main Estimations").

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 1, Col 4) | 4.181 | (1.058) | 27,782 | Municipality (ID_2) | *** |
| Our stored results.csv | 4.18087 | 1.05256 | 27,782 | Municipality (ID_2) | *** |
| Relative Δ | -0.003% | -0.51% | — | — | — |

## Notes
- The paper reports the SE as 1.058; our stored SE is 1.05256. The relative difference is -0.51%, well within the 30% tolerance. The small discrepancy is consistent with minor small-sample adjustment differences (Stata `areg` vs R `feols`) as explicitly noted in metadata notes ("R feols should give coef=4.181, SE~1.053").
- N matches exactly: 27,782 in both the paper and our stored result.
- The coefficient rounded to 3 decimal places is identical: paper prints 4.181, our stored value is 4.181 (full precision: 4.18087364321798).
- Column 4 is unambiguously the preferred/baseline specification per the paper's own narrative in Section 4.1 and Section 4.2 ("the most complete linear model").
- No scale/unit transformation required; both are in IBP index points (0–100 scale).

## Verdict rationale
Our stored beta (4.18087) matches the paper's reported value (4.181) to within 0.003% — well below the 1% EXACT threshold — with matching sign and significance; SE divergence of -0.51% is negligible.
