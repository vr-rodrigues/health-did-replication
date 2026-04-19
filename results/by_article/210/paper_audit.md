# Paper fidelity audit: 210 — Li et al. (2026)

**Verdict:** WITHIN_TOLERANCE
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Table 3 Col 3 (TWFE with controls)" — Post TIS Initiation coefficient, TWFE with full controls, Year-Month FE + Molecule-Province FE, clustered at province by ATC major category. N = 149,013.

Stata spec (from notes): `reghdfe lnprice treat1 GDPadj old POP NumHos NumPhy NumBed GovExp inten InsurExp_Urban, absorb(yearmonth id) cluster(clusterid)`

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 3) | 0.019 | (0.006) | 149,013 | province × ATC major category | *** |
| Our stored results.csv | 0.01854 | 0.005738 | 149,013 | clusterid | *** |
| Relative Δ | -2.44% | -4.37% | | | |

## Notes
- The paper rounds to three decimal places (0.019); our stored value is 0.018537, which rounds to 0.019 — the divergence is entirely rounding.
- SE divergence is -4.37%, well within the 30% tolerance band.
- N = 149,013 matches exactly.
- Both estimates are positive and statistically significant at 1%.
- Clustering label: metadata uses `clusterid`; paper describes clustering at "province by ATC major category" — these refer to the same construct, consistent with Pattern 30 noted in metadata (TWFE clusters at clusterid, CS at clusternum).
- The paper reports two TWFE variants in Table 3: Col 1 (Post TIS Initiation only, no extra controls, β=0.023) and Col 3 (Post TIS Initiation with full controls, β=0.019). Metadata correctly identifies Col 3 as the headline.

## Verdict rationale
Our stored beta (0.01854) differs from the paper's reported value (0.019) by only 2.44%, which falls in the WITHIN_TOLERANCE band (1–5%); the divergence is attributable to rounding in the paper's reported value and our stored precise estimate rounds to 0.019, confirming high fidelity.
