# Paper-Auditor Report — Article 241 (Soliman 2025)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
Table 1 Col 1 — TWFE (equation 2), outcome = MME per capita, county + state*year FEs, no controls, SE clustered at county. Sample restricted to rel_year ∈ [-3, 3] for treated counties (line 239 of replication code). Published in *American Economic Journal: Economic Policy*, 17(4): 165–191.

Benchmark from metadata `original_result`: β = -31.52, SE = 5.767 (documented from replication code output on the filtered sample).

## Comparison

| Source | β | SE | Relative Δ β |
|---|---|---|---|
| Paper / original_result (Table 1 Col 1) | -31.52 | 5.767 | — |
| Our stored results.csv | -31.5232 | 5.7669 | 0.01% |

## Verdict rationale
After applying the rel_year ∈ [-3, 3] sample filter to the TWFE estimation (matching line 239 of the paper's replication code), our stored β = -31.5232 reproduces the paper's documented -31.52 to within 0.01% — an EXACT match by the protocol's < 1% threshold. SE difference is 0.002%, negligible.

Previous WARN verdict (-33.65, 7.72% gap) was caused by the filter being absent from the TWFE run. That mismatch is fully resolved by the 2026-04-19 fix.

Note: PDF at pdf/241.pdf exists but the canonical benchmark is taken from metadata `original_result` (documented from replication code) per profiler protocol.

**Overall:** EXACT
