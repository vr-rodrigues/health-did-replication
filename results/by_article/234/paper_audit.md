# Paper fidelity audit: 234 — Myers (2017)

**Verdict:** FAIL
**Date:** 2026-04-19

## Selected specification

From metadata notes and SKILL_profiler protocol: Table 2, Panel A "Pr(Birth < 19)", "Consent pill" row, **Model 3** (the fullest preferred specification with race/ethnicity controls, additional policy controls, state FEs, cohort FEs, state linear time trends). This is the paper's main TWFE estimate for the effect of minors' pill consent access on the probability of first birth before age 19. N = 279,266 women (CPS Fertility Supplements 1979–95, birth cohorts 1935–1958, aged 22+ at observation). Clustered at state level.

The metadata `notes` field explicitly documents: "our univariate TWFE gives -0.0053 vs original -0.0084", confirming this is the intended comparison target. (The notes were written from an earlier run; current stored beta is -0.00332.)

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Panel A, "Consent pill", Model 3) | -0.0084 | (0.0079) | 279,266 | state | not sig |
| Our stored results.csv (`beta_twfe`) | -0.00332 | 0.00871 | pre-aggregated panel | state | not sig |
| Relative Δ | **60.4%** | 10.2% | | | |

`rel_diff_beta = (-0.00332 - (-0.0084)) / 0.0084 = +60.4%`
`rel_diff_se   = (0.00871 - 0.0079)   / 0.0079 = +10.2%`

## Notes

- **Spec mismatch is intentional and documented.** The paper's Model 3 is a multivariate specification that simultaneously includes 6 reproductive policy exposure variables (pill legal, consent pill, abortion legal, consent abortion, abortion reform, consent abortion reform) plus additional policy controls (state EPL, racial discrimination FEPA, no-fault divorce), plus controls for race/ethnicity, plus state linear cohort trends. Our TWFE is univariate: it regresses the outcome on `epillconsent18` alone (plus state and cohort FEs). These are fundamentally different specifications.
- **The metadata notes document this divergence explicitly** as expected: "our univariate TWFE gives -0.0053 vs original -0.0084 (both insig)." The current stored value (-0.00332) differs even from the notes' figure (-0.0053), suggesting the pipeline result has evolved since the notes were written.
- **Both estimates are statistically insignificant** (the paper's consent pill coefficient is never significant across Models 1–4 for Panel A; our estimate also has large SE relative to the point estimate). The sign is the same (negative) in both cases.
- **The paper's main finding is NOT the pill consent coefficient** — it is the abortion policy coefficients (consent abortion: -0.0520*** to -0.0567***). Our pipeline captures the pill consent variable (`epillconsent18`) as the treatment variable, which the paper itself estimates as a null result.
- SE divergence is within tolerance (10.2% < 30%).
- The paper uses individual-level CPS data (n = 279,266 individual observations). Our pipeline pre-aggregates to a 49-state × 24-cohort panel (n = 1,176 cell observations, weighted means), which can also shift point estimates.

## Verdict rationale

FAIL because the relative difference in beta is 60.4% (> 20% threshold), driven entirely by the documented, intentional mismatch between our univariate TWFE specification (consent pill only, pre-aggregated panel) and the paper's multivariate Model 3 (6 policy variables simultaneously, individual-level data, state trends). Both are insignificant with the same sign, and the divergence is an expected consequence of a deliberate implementation choice — not a coding error.
