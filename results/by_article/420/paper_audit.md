# Paper fidelity audit: 420 — Bailey, Goodman-Bacon (2015)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Table 2 Panel B Col 2 / Figure 7D — age-adjusted mortality rate, 50+ years old, baseline specification (county FEs + urban-by-year FEs + state-by-year FEs + county-level covariates X_jt), early CHCs 1965–1974, 3,044 counties, 1959–1988."

Protocol rule applied: paper title and abstract emphasize the 50+ mortality result as the headline finding (Section III.B, Figure 7D, Table 2 Panel B Col 2 is the preferred baseline column per metadata notes).

## The comparability problem

The paper's Table 2 does **not** report a single static ATT (post-indicator) coefficient. It uses a grouped event-year dummy specification (equation 1 in the paper), collapsing event-study dummies into four period buckets:

| Period | Panel B Col 2 (50+ AMR) | SE |
|---|---|---|
| Years −6 to −2 (pre-trend) | −2.0 | [8.0] |
| Years 0 to 4 (early post) | −41.1 | [9.6] |
| Years 5 to 9 (medium post) | −72.0 | [14.8] |
| Years 10 to 14 (late post) | −64.1 | [19.3] |

Mean at t* = −1: 3,213 deaths per 100,000

Our `beta_twfe` is a **single static post-indicator** (`treat_post` = 1 if year >= first CHC year and county ever treated). This collapses all post-treatment event years into one coefficient, producing a time-averaged ATT that is not directly comparable to any individual row in Table 2.

## Approximate comparison (informational only)

A rough unweighted average of the three post-period estimates in Panel B Col 2 gives approximately −59.1. Our stored `beta_twfe = −53.21` is in the same direction and broadly similar in magnitude, suggesting the pipeline is not wildly off.

| Source | β | SE | N | cluster | comparability |
|---|---|---|---|---|---|
| Paper Table 2 Panel B Col 2 — Years 5–9 (closest single period) | −72.0 | (14.8) | ~91k obs | fips | event-year group dummy |
| Paper Table 2 Panel B Col 2 — Years 0–4 | −41.1 | (9.6) | ~91k obs | fips | event-year group dummy |
| Paper approximate post-average (unweighted) | ~−59.1 | — | — | — | not reported by paper |
| Our stored results.csv (beta_twfe) | −53.21 | 14.84 | — | fips | static post-indicator |
| Relative Δ vs approx average | ~10% | — | | | approximate |

## Notes

- The paper's TWFE specification uses grouped event-year dummies, not a single `D_j * Post_t` indicator. These are structurally different parameterizations: the paper's approach allows for time-varying treatment effects; our `beta_twfe` imposes a constant post-treatment effect.
- The paper does not report any weighted-average or aggregated static ATT coefficient anywhere in the main text, appendices, or robustness tables. There is no single number that directly maps to our `beta_twfe`.
- The `original_result` field in metadata.json is empty `{}`, consistent with this finding.
- Figure 7D (the event-study plot for 50+ AMR) also cannot provide a single numeric point estimate for precise comparison.
- The magnitude of our `beta_twfe` (~−53) falls between the paper's early-post (−41) and medium-post (−72) estimates, which is plausible for a time-averaged estimator over a staggered rollout with growing treatment effects.
- Our stored `se_twfe = 14.84` is comparable to the paper's Period 5–9 SE of 14.8, suggesting similar clustering behavior.

## Verdict rationale

The paper reports only grouped event-year dummy estimates in Table 2 (no single static ATT coefficient), making a direct 1-to-1 comparison with our `beta_twfe` (static post-indicator) impossible. Verdict is NOT_APPLICABLE (paper does not report a comparable standalone TWFE ATT).
