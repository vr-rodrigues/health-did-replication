# Paper fidelity audit: 79 — Carpenter, Lawler (2019)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata `original_result` field and paper text (p. 108): Table 1, Column 1 — baseline DiD without linear state trends; outcome = 1 dose Tdap booster by age 13; individual-level NIS-Teen sample weights applied; cluster SE at state level; N = 116,304 observations; 2008–2013 survey waves.

The paper's own language (p. 108): "The estimate in column 1 indicates that Tdap mandates were associated with a 13.5 percentage point increase in the likelihood that an adolescent received a Tdap booster between 10 and 12 years of age."

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 1, Col 1) | 0.135 | (0.0140) | 116,304 | state | *** (implied) |
| Our stored results.csv | 0.135036 | 0.013962 | — | state (fips) | — |
| Relative Δ | +0.027% | −0.27% | | | |

## Notes
- Paper Table 1 reports β = 0.135 rounded to 3 decimal places; our stored value is 0.135036, a difference of 0.036 in the fourth decimal place.
- SE: paper reports 0.0140 (rounded); our value is 0.013962, a difference of −0.27% — effectively identical.
- N: paper reports 116,304; our results.csv does not store N explicitly but the metadata sample filter and data file match the paper's NIS-Teen 2008–2013 sample.
- The paper uses NIS-Teen sampling weights (`provwt`), which is correctly specified in our metadata (`weight: provwt`).
- Column 2 (with linear state trends) yields β = 0.137 (SE = 0.0164) — also very close to our estimate, but Column 1 is the headline per the paper's text and the SKILL_profiler hierarchy (most parsimonious baseline, explicitly named as the main result in text).
- No unit or scale transformation issues; both paper and our results are in probability (proportion) units.

## Verdict rationale
Our stored beta_twfe (0.135036) matches the paper's Table 1 Column 1 reported value (0.135) to within 0.03%, well inside the 1% EXACT threshold, with correct sign and negligible SE divergence (−0.27%).
