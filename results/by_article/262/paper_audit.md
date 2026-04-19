# Paper fidelity audit: 262 — Anderson, Charles, Rees (2020)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From paper text (pages 16 and 27) and Figure 3 Panel B: the "fully specified regression model" — county FEs + year FEs + county-level covariates (hs_deg_imp, health_per_cap, emp_to_pop), weighted by live Black births, clustered at the county level. Outcome: Black postneonatal mortality rate (deaths per 1,000 live Black births). Treatment: Medicare (indicator = 1 if county had access to a Medicare-eligible hospital). Sample: race==3 (Black), balanced panel, no_births==0 excluded; N = 6,033 county-years.

The paper does not present this estimate in a standalone regression table. The DD estimate and SE are reported directly in Figure 3 Panel B's inset box. The same value (1.22) is repeated verbatim in the main text and conclusion.

## Comparison

| Source | β | SE | N | Cluster | Sig |
|---|---|---|---|---|---|
| Paper (Figure 3 Panel B) | 1.22 | 0.888 | 6,033 | county | none |
| Our stored results.csv | 1.22100 | 0.88792 | 6,033 | county | none |
| Relative Δ | +0.08% | -0.01% | | | |

## Notes

- The paper's headline estimate is reported in Figure 3 Panel B, not in a regression table. The figure's inset reads: "DD estimate = 1.22 (.888), Pre-treatment mean = 21.0, N = 6,033."
- The same value appears in the main text (p. 16): "gaining access to a certified hospital is associated with a 1.22 increase in the Black PNMR" and in the conclusion (p. 27).
- The figure notes state 90% confidence intervals are reported; SE is the standard error from the regression (clustered at county), not a bootstrap SE.
- Figure 3 Panel A (without covariates) reports DD = 1.20 (SE = .892) — this is the no-controls version. Panel B (with covariates) is the fully specified model and the paper's stated headline.
- Our beta_twfe_no_ctrls = 1.20590 matches Panel A to within 0.5% as well, providing additional cross-check that the pipeline is correctly matched.
- Metadata original_result field is empty ({}); this audit now establishes the ground truth.

## Verdict rationale

Our stored beta_twfe (1.22100) matches the paper's Figure 3 Panel B DD estimate (1.22) to within 0.08%, and our se_twfe (0.88792) matches the paper's reported SE (0.888) to within 0.01% — both well within the 1% EXACT threshold.
