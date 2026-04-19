# Paper fidelity audit: 80 — Marcus et al. (2022)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes + paper text (p. 140, Table 2 note): Table 2, Column 3 ("+ municip. fixed effects"), outcome = *Member of sports club* (variable `sportsclub`). The table note explicitly states "Column 3 is the main specification that is the basis for the subsequent analyses." Specification: cohort FEs + state FEs + municipality FEs; treatment indicator = `Voucher` (Saxony × Post); robust SEs clustered at municipality level; N = 13,334.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 3, Panel B — Member of sports club) | 0.009 | (0.019) | 13,334 | municipality | none |
| Our stored results.csv (`beta_twfe`) | 0.008925 | 0.018718 | — | cityno (=municipality) | none |
| Relative Δ | −0.83% | −1.48% | | | |

## Notes
- The paper reports the coefficient to 3 decimal places (0.009); our stored value is 0.008925, consistent with rounding.
- SE difference is 1.48% — entirely within tolerance; both effectively 0.019 after rounding.
- N is reported in the paper as 13,334 observations; our results.csv does not include an N field, but the metadata sample filter matches.
- The paper's Panel B reports six outcomes; sports club membership ("sportsclub") is our primary outcome and matches metadata `variables.outcome`.
- No controls are included beyond FEs (metadata `twfe_controls: []`), consistent with the paper's specification for the physical activity outcomes.
- The paper uses clustered SEs at the municipality level (= `cityno` in our data); specification alignment is complete.

## Verdict rationale
Our stored β = 0.008925 deviates from the paper's reported 0.009 by only −0.83%, well within the 1% EXACT threshold, with matching sign (both positive, both insignificant).
