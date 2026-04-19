# Paper fidelity audit: 65 — Akosa Antwi, Moriya & Simon (2013)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes + SKILL_profiler protocol: Table 2, Column 1 ("Any source"), Row "ACA implementation effect (October 2010–November 2011)". This is the paper's explicitly labelled main DD result: the average post-September 2010 implementation effect on any health insurance coverage (outcome = `anyhi`) for 19–25-year-olds relative to the control group (16–18 and 27–29-year-olds). N = 150,997 person-month observations. Standard errors clustered at the state level.

Note: The paper's TWFE model (equation 1) includes two treatment interaction terms: `η(Treat_g × Implement_t)` (ACA enactment effect, March–September 2010) and `σ(Treat_g × Enact_t)` (ACA implementation effect, October 2010 onwards). Our stored `beta_twfe` maps to `elig_oct10` = `after_oct10 × fedelig`, which corresponds to `σ` — the ACA implementation effect row of Table 2. This is the main headline number cited in the paper's abstract (p. 3: "a 3.2 percentage-point increase in insurance").

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 1, implementation row) | 0.0318 | (0.0074) | 150,997 | state | *** |
| Our stored results.csv | 0.031744 | 0.007559 | — | state | *** |
| Relative Δ | −0.18% | +2.15% | | | |

## Notes
- N is not stored in results.csv; the paper reports 150,997 person-month observations in the Table 2 notes.
- The paper also includes a March–September 2010 "enactment" interaction (`elig_mar10`) as a separate coefficient in the same regression; our template includes `elig_mar10` as a control variable, consistent with the Stata code in the notes. `beta_twfe` isolates `elig_oct10` only — the correct comparison target.
- SE convention: paper uses analytical state-clustered SEs (linear probability model). Our template likewise clusters at `fipstate`. The 2.15% SE relative difference is negligible.
- Metadata `notes` warn that the template uses `fipstate + yearmonth + age` FEs (more saturated than the paper's `fipstate + year + month + trend + state-specific trends`). Despite this structural difference, the point estimate is effectively identical, suggesting the two FE structures absorb similar variation for this outcome.
- The `beta_twfe_no_ctrls` estimate (0.03436) is further from the paper, as expected — the paper's headline spec includes controls.

## Verdict rationale
Our stored beta_twfe (0.031744) differs from the paper's Table 2 Col 1 implementation coefficient (0.0318) by only −0.18%, well within the 1% EXACT threshold, with matching sign and significance level.
