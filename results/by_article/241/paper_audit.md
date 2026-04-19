# Paper fidelity audit: 241 — Soliman (2025)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Table 1 Col 1" — TWFE (equation 2), outcome = MME per capita, county + state*year FEs, no controls, SE clustered at county. Sample restricted to rel_year ∈ [-3, 3] for treated counties (line 239 of replication code). Metadata `original_result` documents the paper's benchmark as β = -31.52 / SE = 5.767 (replication code output on the filtered sample). Published in *American Economic Journal: Economic Policy*, 17(4): 165–191.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper / original_result (Table 1 Col 1) | -31.52 | (5.767) | — | county | *** |
| Our stored results.csv | -31.5232 | 5.7669 | — | county | — |
| Relative Δ | 0.01% | -0.002% | | | |

## Notes

- No PDF at `pdf/241.pdf`; paper value taken from metadata `original_result` (documented by profiler from replication code run on filtered sample).
- The previously published table shows -31.24 / 5.700 (prior audit noted 0.9% discrepancy vs replication code). The canonical benchmark used here is the replication-code output (-31.52 / 5.767) per profiler protocol.
- FIX APPLIED 2026-04-19: `sample_filter` now includes `(rel_year >= -3 & rel_year <= 3) | gvar_CS == 0` globally, matching the paper's estimation sample. CS-DID is exempted via `cs_sample_filter = ""` and runs on the full 9-year panel.
- Previous WARN verdict (-33.65, 7.72% gap) was caused by the filter being absent from the TWFE run; that mismatch is now resolved.
- SE relative difference is negligible (0.002%); no concern.

## Verdict rationale

After applying the rel_year ∈ [-3, 3] sample filter to the TWFE estimation (matching line 239 of the paper's replication code), our stored β = -31.5232 reproduces the paper's documented -31.52 to within 0.01% — an EXACT match.
