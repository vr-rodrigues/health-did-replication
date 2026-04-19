# CS-DID Reviewer Report — Article 97 (Bhalotra et al. 2021)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. CS-DID applicability

**1.1 Treatment timing**
Treatment timing is "single" — all treated units adopt at the same calendar time (1991). With a single adoption cohort, CS-DID collapses to a single ATT(g=1991). This is valid, though CS-DID offers no aggregation benefit over TWFE in this case (no heterogeneous treatment timing to decompose). PASS.

**1.2 Data structure**
Data is `repeated_cross_section`, not a true panel. The CS-DID estimator (`csdid`) applied to repeated cross-sections uses the repeated cross-section variant (RC), which is appropriate here. PASS.

**1.3 Comparison group**
`run_csdid_nt = true`, `run_csdid_nyt = false`. With single treatment timing, the never-treated comparison group is the only meaningful option; not-yet-treated is not applicable. Correct. PASS.

**1.4 Base period**
`cs_base_period = "universal"`. The universal base period averages all pre-treatment periods as the reference, which is standard. PASS.

### 2. Composite unit construction

The dual-cohort structure requires composite unit IDs: `unit_cs_bjs = mun_reg*10 + treated2`. This correctly distinguishes the two "slots" of each municipality, making the CS panel unique on (composite_unit, year). This is a valid and necessary adjustment. PASS.

### 3. Numerical results

| Estimator | ATT | SE |
|---|---|---|
| CS-NT simple | -0.3518 | 0.0383 |
| CS-NT dynamic | -0.3518 | 0.0392 |
| Original paper CS-NT | -0.3517 | 0.0387 |
| Divergence | < 0.0001 | — |

Near-exact match to the paper's reported CS-NT estimates. PASS.

### 4. TWFE vs CS-DID comparison

| | TWFE | CS-NT |
|---|---|---|
| Static ATT | -0.303 | -0.352 |
| Divergence | 0.049 (16%) | — |

The CS-NT estimate is ~16% larger in magnitude than TWFE. With single treatment timing, this small divergence is not due to negative-weighting contamination (the primary motivation for CS over TWFE). Instead it likely reflects: (a) differences in the implicit comparison pool, or (b) the controls included in TWFE but not in CS-NT (`cs_controls = []`). The direction (CS more negative) is consistent with the TWFE controls partially absorbing treatment variation.

No negative-weighting concern applies here (single cohort). PASS on heterogeneity grounds.

### 5. Pre-trend pattern (event study, CS-NT)

CS-NT pre-period coefficients mirror TWFE exactly (see TWFE reviewer):

| Period | CS-NT coef | SE |
|---|---|---|
| -6 | +0.109 | 0.048 |
| -5 | +0.225 | 0.051 |
| -4 | +0.335 | 0.051 |
| -3 | +0.156 | 0.046 |
| -2 | +0.052 | 0.048 |

The near-identical match between TWFE and CS-NT event-study paths confirms that the pre-trend issue is structural to the data, not an artefact of TWFE-specific weighting. The pre-trends represent a genuine threat to parallel trends — four of five pre-period estimates are significantly positive, peaking at +0.335 at t=-4.

**WARN on parallel trends.** The pre-trend profile is large and structured.

### 6. SA equivalence

Since there is only one treatment cohort (g=1991), Sun-Abraham (SA) is mathematically equivalent to TWFE. The stored event-study confirms exact numerical equality between TWFE and SA paths. This is expected and correct — not a concern.

### 7. Summary

| Check | Verdict |
|---|---|
| Applicability | PASS |
| Comparison group | PASS |
| Composite unit construction | PASS |
| Numerical match | PASS |
| TWFE/CS divergence | PASS (16% within expected range) |
| Parallel trends (pre-trends) | WARN — large positive pre-trend, structural |

**Top-line WARN** — implementation is correct, but the pre-trend evidence is concerning for the parallel-trends assumption underlying both TWFE and CS-DID estimates.
