# Paper fidelity audit: 333 — Clarke, Muhlrad (2021)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes + paper Table 2 caption: Table 2, Panel A (ILE versus non-reformers), Column 1 — no population weights, no time-varying controls. Outcome: abortion-related morbidity per 1000 fertile-aged women per month. Sample: Mexico DF (ILE adopter) + all non-reforming states, monthly panel 1990–2015, regressiveState==0 filter. State and Year×Month FEs. SEs via wild clustered bootstrap (clustered at state level).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2, Panel A, Col 1) | -0.064 | (0.013) | 2496 | state (wild bootstrap) | *** |
| Our stored results.csv | -0.063576 | 0.012605 | 2496 | state (analytical clustered) | *** |
| Relative Δ | +0.66% | -3.04% | | | |

## Notes
- Paper SE uses wild clustered bootstrap; our template uses analytical clustered SE. The 3% SE gap is well within the 30% tolerance and is expected given the different inference method.
- N=2496 matches exactly (13 states × 192 months = 2496 state×month cells).
- Our beta rounds to -0.064, identical to the paper's reported value to three decimal places.
- No controls, no weights in this column — matches our `beta_twfe` (which equals `beta_twfe_no_ctrls` since twfe_controls=[]).

## Verdict rationale
|rel_diff_beta| = 0.66% < 1% with sign match — our stored TWFE coefficient is effectively identical to the paper's Table 2 Panel A Column 1 headline estimate.
