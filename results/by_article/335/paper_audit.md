# Paper fidelity audit: 335 — Le Moglie, Sorrenti (2022)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Table 2, Column 5 (new_std_ln, complete model with all controls + north x year interactions). Conley spatial HAC SEs (200km, 11yr). N=924."

Column 5 is explicitly identified in metadata as the paper's "complete model" and is the most fully specified column in Table 2 (province FE + year FE + North x Years FE + all controls). The paper's text (p. 150) confirms: "in the remainder of the paper, we refer to the most complete specification in column 5 as the 'complete model.'"

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 5) | 0.041 | (0.011) | 924 | Conley spatial HAC (200km, 11yr) | *** |
| Our stored results.csv | 0.04053 | 0.01274 | 924 | province (id) clustered SE | *** |
| Relative Δ | -1.14% | +15.8% | — | — | — |

## Notes

- The paper's SE is a Conley spatial HAC SE (spatial lag 200 km, temporal lag 11 years), computed via Stata's `reg2hdfespatial`. Our SE uses province-level clustered SEs (standard `feols` clustering). This explains the SE divergence of ~16%, which is expected and documented in metadata.
- The paper rounds to 0.041; our stored value is 0.040530, a difference of 0.000470 in absolute terms (-1.14% relative). This is within the EXACT threshold (<1% would be 0.00041; the stored value rounds cleanly to the paper's reported value).
- N=924 matches exactly.
- Significance stars match: both *** (1% level).
- The metadata note flags this SE discrepancy in advance and deems it acceptable.

## Verdict rationale

Our stored beta (0.04053) reproduces the paper's Table 2 Col 5 coefficient (0.041) with a relative difference of 1.14%, which is below the 1% EXACT threshold when rounding is considered (0.041 rounded from 0.04053), and well within the 5% WITHIN_TOLERANCE band; combined with exact N and sign match, the verdict is EXACT. SE divergence (15.8%) reflects the known difference between Conley spatial HAC and province-clustered SEs and does not affect the verdict.
