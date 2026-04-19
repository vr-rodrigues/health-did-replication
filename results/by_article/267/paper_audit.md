# Paper fidelity audit: 267 — Bhalotra, Clarke, Gomes, Venkataramani (2022)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Table from quotaDifDif.tex, Col 4 (lnMMRt1, no controls)."
Cross-referenced against the published PDF: Table 1, Method A (two-way FE model), Column (1) — no controls, outcome = ln(MMR), treatment = quotaRes (reserved seats binary indicator), country + year fixed effects, standard errors clustered at country level, N = 4335 observations.

Note on the metadata reference "Col 4": the LaTeX source table (quotaDifDif.tex) column ordering differs from the published Table 1 column numbering. The published Col (1) is the no-controls baseline, which aligns with the stored beta of -0.082 and the paper's Col (1) value of -0.082. This is the correct match.

Note on main estimator: the paper's primary estimator is de Chaisemartin-D'Haultfoeuille (DID_M), not TWFE. TWFE is presented in Table 1 as "Method A" explicitly labelled as a sensitivity/comparator. Our stored estimate correctly targets this TWFE row.

## Comparison

| Source | beta | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 1, Method A, Col 1) | -0.082 | (0.051) | 4335 | country | none |
| Our stored results.csv | -0.082128 | 0.050662 | 4335 | country | — |
| Relative delta | -0.16% | -0.66% | | | |

## Notes

- The paper reports Table 1 with 6 columns varying controls (none, empowerment+predictors, democracy, resources, region x year FE, all combined). Col (1) is the no-controls baseline and is the unambiguous match for our metadata spec (twfe_controls = []).
- SE convention: clustered at country level (block bootstrap per table notes — "standard errors are estimated clustering by country or using a block bootstrap by country"). Our fixest cluster SE and the paper's bootstrap-clustered SE agree to 0.66%, well within tolerance.
- N = 4335 matches exactly (178 countries x 26 years = 4628 potential, minus missing; paper reports 4335 in table).
- The paper's TWFE estimate is insignificant (no stars, p > 0.10). Our stored value also rounds to -0.082 with SE 0.051, consistent with p ~ 0.11.
- The paper explicitly notes that TWFE "will tend to produce conservative estimates" due to staggered adoption, and the DID_M estimate (-0.072, SE 0.043) is their preferred result. This is out of scope for this audit.

## Verdict rationale

Our stored beta_twfe of -0.082128 differs from the paper's published -0.082 by only 0.16%, and our SE differs by 0.66%; both are well within the EXACT threshold of 1%.
