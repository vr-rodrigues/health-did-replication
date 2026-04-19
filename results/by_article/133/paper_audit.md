# Paper fidelity audit: 133 — Hoynes et al. (2015)

**Verdict:** WARN
**Date:** 2026-04-19

## Selected specification

From metadata notes + SKILL_profiler protocol: Table 2, Column 2 — "Parity 2+ versus 1" with state-year control variables (Medicaid/SCHIP, welfare reform, unemployment rate). This is the authors' baseline headline specification for the high-impact sample (single women, high school education or less), effective tax years 1991–1998, outcome = fraction low birth weight (×100). Equation (1), full controls, clustered by state.

The metadata `original_result` field stores `beta_twfe = -0.3549` and `se_twfe = 0.0746`. Table 2 Col 1 (no state controls) shows -0.355 (0.075); Col 2 (with controls) shows -0.354 (0.074). The two are nearly identical; Col 2 is selected as the metadata-nominated baseline (controls included, consistent with `twfe_controls` in metadata). The stored `original_result` value of -0.3549 rounds to -0.355, consistent with Col 1, but the difference between Col 1 and Col 2 is <0.3% and immaterial to the verdict.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 2) | -0.354 | (0.074) | 47,687 | state | *** |
| Our stored results.csv | -0.38684 | 0.08258 | — | state | — |
| Relative Δ | -9.3% | +11.6% | | | |

## Notes

- The metadata `notes` field states "MATCHES: TWFE exact" — this indicates the pipeline previously reproduced -0.355/-0.354. The current stored result (-0.3868) diverges by 9.3%, suggesting specification drift between when the notes were written and the current results.csv.
- The paper's Table 2 has two nearly identical columns for "Parity 2+ versus 1": Col 1 (-0.355, SE 0.075, no state controls) and Col 2 (-0.354, SE 0.074, with state controls). Both are plausible headline candidates; the divergence from either is ~9%.
- SE divergence is 11.6%, within the 30% lenient threshold — not flagged separately.
- N is not stored in results.csv for direct comparison.
- The paper uses cell-weighted WLS (weight = number of births in cell) and clusters by state; metadata confirms `weight = cellnum` and `cluster = stateres`.
- The `original_result.beta_twfe = -0.3549` stored in metadata.json rounds correctly to Col 1/Col 2 of Table 2 (-0.355/-0.354) — the metadata reference is internally consistent with the paper. The divergence is between results.csv and the paper, not between metadata and the paper.
- `cs_nt_with_ctrls_status = 0` in results.csv (stored as numeric zero, not "OK") warrants attention by csdid-reviewer but is out of scope here.

## Verdict rationale

Our stored `beta_twfe` (-0.3868) diverges from the paper's Table 2 Col 2 value (-0.354) by 9.3% with matching sign, placing it in the WARN band (5–20%); the specification appears partially misaligned relative to when the metadata notes recorded an exact match.
