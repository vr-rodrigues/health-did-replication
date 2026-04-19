# Paper fidelity audit: 281 — Steffens, Pereda (2025)

**Verdict:** NOT_APPLICABLE (paper does not report a standalone pooled TWFE estimate)
**Date:** 2026-04-19

## Selected specification

From metadata notes / SKILL_profiler protocol: "Figure 3a — average effects on smoking prevalence (Eq. 2 event-study without controls series)."

The paper's main specification is a generalized DiD event-study (Eq. 2, p. 7) that yields year-by-year coefficients β_s for s = 2006, …, 2013, with cohort-specific linear trends controlled. No single pooled ATT coefficient from this specification is reported anywhere in the main text. The paper's headline summary ("18% reduction after four years") is a verbal translation of the 2013 event-study coefficient, not a scalar regression output from a single binary post-treatment indicator.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper — Figure 3a, "without controls" 2013 coeff (approx from plot) | ~-0.011 to -0.015 | not reported (CI from figure) | 68,130 (Table 4 notes) | capital (27 clusters) | visual only |
| Paper — Table 4 Col 4 "Estimation" 2013 (prevalence decomposition) | -0.022 | (0.003) | 68,130 | capital | *** |
| Our stored results.csv — beta_twfe (pooled post indicator) | 0.00240 | 0.00553 | not stored | uf (state) | n.s. |
| Relative Δ | not comparable | not comparable | | | |

## Notes

- The paper's Eq. (2) is an event-study specification with year indicators interacted with treatment indicator, plus cohort-specific linear trends. It yields a vector of year-specific coefficients, not a single scalar.
- Our pipeline estimates `beta_twfe` using a single binary `Post_avg` indicator (treatment × post dummy), which is a different estimand from any number in the paper.
- The closest scalar in the paper is the 2013 event-study coefficient from the "without linear trends" series in Figure 3a (approximately -0.011 to -0.015 pp, negative sign), or the 2013 prevalence decomposition estimate of -0.022*** (Table 4 Col 4). Neither of these corresponds to our pooled post-treatment TWFE coefficient.
- Our stored `beta_twfe` = +0.00240 has the opposite sign from all post-treatment effects in the paper. This is not a sign flip in a matched comparison — the estimands are fundamentally different (single pooled indicator vs. year-specific event-study).
- The metadata `original_result.beta_twfe` was correctly left as `{}` (empty), consistent with no extractable scalar TWFE from the paper.
- The paper uses PNS sampling weights and wild-cluster bootstrap for inference; our pipeline uses cluster-robust SE at the state (uf) level.

## Verdict rationale

The paper's main estimator is a year-specific event-study DiD (Eq. 2), and no pooled TWFE ATT coefficient is reported anywhere in the main text; there is no scalar paper number to compare against our stored `beta_twfe`, making fidelity comparison inapplicable.
