# Paper fidelity audit: 241 — Soliman (2025)

**Verdict:** WARN
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Table 1 Col 1" — TWFE (equation 2), outcome = MME per capita, county + state*year FEs, no controls, SE clustered at county. Published in *American Economic Journal: Economic Policy*, 17(4): 165–191.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 1 Col 1) | -31.24 | (5.700) | 26,505 | county | *** |
| Our stored results.csv | -33.6515 | 6.4859 | — | county | — |
| Relative Δ | -7.72% | +13.79% | | | |

## Notes

- The stored result (-33.65) uses the **full unfiltered sample**. The paper's TWFE (equation 2) restricts the estimation sample to rel_year in [-3, 3] for treated counties (line 239 of replication code), dropping 247 treated-county obs far from treatment. Never-treated have rel_year = 0 and are always in window.
- Metadata `original_result` documents beta = -31.52 / SE = 5.767, which is the replication code output on the filtered sample. The published table shows -31.24 / 5.700 — a small rounding/version discrepancy between replication code and published paper (rel diff vs paper: 0.9%).
- The gap between our stored result and the paper's published number (-7.72%) is therefore entirely attributable to the sample filter, not to FE structure, clustering, or controls.
- SE divergence (13.79%) is consistent with the different effective sample sizes (filtered vs full).
- A STANDALONE SCRIPT (`investigate_241.R`) exists per metadata notes; the main results.csv reflects the unfiltered pipeline run.
- The metadata `original_result.beta_twfe = -31.52` vs published -31.24: these are within 0.9% of each other, consistent with minor version differences between replication code and final published manuscript.

## Verdict rationale

Our stored TWFE (-33.65) differs from the paper's published Table 1 Col 1 (-31.24) by 7.72%, because results.csv was produced on the full unfiltered panel, while the paper restricts the estimation sample to ±3 event-years around treatment. This is a known, documented specification mismatch (WARN); a standalone filtered run reproduces -31.52, within 0.9% of the paper's -31.24.
