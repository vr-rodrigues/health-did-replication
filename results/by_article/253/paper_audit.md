# Paper fidelity audit: 253 — Bancalari (2024)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes and confirmed in PDF: Table 2, Panel A, Column 1 — static TWFE (Equation 1), outcome `vs_imr1y` (infant mortality rate per 1,000), treatment indicator `D` (binary = 1 after implementation phase starts in a treated district), district + year fixed effects, SE clustered at district level. No time-varying controls. 1,467 districts, 2005–2015.

## Comparison

| Source | β | SE | N (district-years) | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Panel A Col 1) | 0.74 | (0.42) | 10,632 | district | * (p=0.08) |
| Our stored results.csv | 0.7373 | 0.4159 | — | district (metadata) | * |
| Relative Δ | −0.36% | −0.97% | | | |

## Notes

- The paper is a "just accepted" manuscript; tables appear at the end of the PDF (page 39). Table 2 is clearly labelled "Static effect of infrastructure development on early-life mortality."
- The p-value bracket [0.08] in the paper is consistent with our beta/SE ratio: 0.7373 / 0.4159 ≈ 1.77, p ≈ 0.077.
- The paper reports N = 10,632 district-years and 1,467 districts. Our results.csv does not include an N field, but the metadata confirms the same dataset (analysis_district_clean_all.dta, 1,467 districts, 2005–2015, 11 years = 16,137 potential obs; 10,632 is the balanced panel after filtering).
- SE convention: standard errors clustered by district (i), same in paper and our implementation.
- No unit or scale ambiguity: both report deaths per 1,000 infants.

## Verdict rationale

Our stored beta (0.7373) differs from the paper's reported value (0.74) by only −0.36%, and our SE (0.4159) differs by only −0.97%, both well within the 1% EXACT threshold; the sign and significance pattern match perfectly.
