# Paper Auditor Report — Article 335
# Le Moglie, Sorrenti (2022) — "Revealing 'Mafia Inc.'?"

**Verdict:** EXACT
**Date:** 2026-04-19

## Applicability Assessment

Paper-auditor requires:
- `pdf/{id}.pdf` exists: YES — `pdf/335.pdf` confirmed present as of 2026-04-19.
- `results/by_article/335/results.csv` has numeric `beta_twfe`: YES (0.04053).

Fidelity axis: F-HIGH (EXACT).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 5) | 0.041 | (0.011) | 924 | Conley spatial HAC (200km, 11yr) | *** |
| Our stored results.csv | 0.04053 | 0.01274 | 924 | province (id) clustered SE | *** |
| Relative Δ | -1.14% | +15.8% | — | — | — |

## Verdict rationale

Our stored beta (0.04053) reproduces the paper's Table 2 Col 5 coefficient (0.041) with a relative difference of 1.14%, which is below the EXACT threshold when rounding is considered (0.041 rounded from 0.04053). N=924 matches exactly. Significance stars match (***). SE divergence (15.8%) reflects the documented difference between Conley spatial HAC and province-clustered SEs and does not affect the verdict.

Source confirmed: paper states (p. 150) "we refer to the most complete specification in column 5 as the 'complete model.'" Our metadata correctly targets Table 2, Column 5.
