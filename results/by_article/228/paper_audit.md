# Paper fidelity audit: 228 — Sarmiento, Wagner & Zaklan (2023)

**Verdict:** NOT_APPLICABLE (paper uses CS-DD as main estimator; TWFE not reported in any table)
**Date:** 2026-04-19

## Selected specification

From metadata notes and SKILL_profiler protocol: Paper's primary estimator is CS-DD (Callaway-Sant'Anna att_gt with DR, never-treated control group). The preferred specification is the **doughnut design** (control stations 25–75 km from LEZ borders) from Table 4, Panel (c), PM10 column.

Paper's TWFE is used solely for diagnostic/decomposition purposes (Goodman-Bacon Figure 6 and Figure B.1 in online appendix). The PDF (23 pages) does not contain any appendix table with a standalone TWFE coefficient for PM10. The only TWFE number for PM10 appears in narrative text on p. 10: "PM₁₀ by 1.21 (vs. 2.06) µg/m³" — where 1.21 is the TWFE value and 2.06 is the CS-DD preferred estimate.

## Comparison

### Primary: Paper's main CS-DD estimate vs. our CS-DD (not our TWFE)

| Source | β | SE | N.Obs | N.Stations | cluster | sig |
|---|---|---|---|---|---|---|
| Paper Table 4c (doughnut, PM10) | −2.059 | (0.376) | 2501 | 247 | municipality | *** |
| Our att_csdid_nt (results.csv) | −1.642 | 0.305 | — | — | municipality | — |
| Our att_nt_dynamic | −1.954 | 0.353 | — | — | municipality | — |
| Relative Δ (simple vs paper) | +20.3% | — | | | | |
| Relative Δ (dynamic vs paper) | +5.1% | — | | | | |

Note: CS-DD comparison is informational only; CS-DD fidelity is `csdid-reviewer`'s scope.

### Secondary: Paper's narrative TWFE vs. our stored TWFE

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (narrative p.10, doughnut PM10) | −1.21 (approx) | not reported | not reported | municipality | — |
| Our stored results.csv (beta_twfe) | −1.2396 | 0.3274 | — | municipality | — |
| Relative Δ | −2.4% | N/A | | | |

## Notes

- The paper's TWFE uses **daily** pollution data with weather controls (temperature, precipitation, sunshine) and station + year + month FEs. Our TWFE uses **yearly** averages without controls. These are fundamentally different specifications on different data aggregations.
- The TWFE appears in Figure B.1 (online appendix) as a graphical comparison against CS-DD, not in any numbered table. The online appendix is not part of the 23-page PDF supplied.
- The narrative value of -1.21 on p.10 is an approximate round figure from a figure, not a tabled estimate. It cannot be used for precise fidelity comparison.
- The `original_result` field in metadata.json is empty `{}`, consistent with no tabled TWFE being the paper's main result.
- Despite the data/specification mismatch (daily vs. yearly), our TWFE on yearly data (-1.2396) happens to be very close to the paper's narrative TWFE approximation (-1.21), with a 2.4% relative difference. This is likely coincidental given the different underlying data.
- The paper's preferred CS-DD estimate for PM10 doughnut is -2.059 µg/m³; our CS-DD simple ATT is -1.642 and our dynamic ATT is -1.954, both in the same direction with reasonable magnitude alignment.

## Verdict rationale

The paper's main estimator is CS-DD (Callaway-Sant'Anna); TWFE is reported only graphically in an online appendix (not in the supplied PDF) and as a single narrative approximation in the main text. No standalone TWFE coefficient table exists to compare against our stored value. Verdict is NOT_APPLICABLE.
