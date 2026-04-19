# Bacon Reviewer Report: Article 25 — Carrillo, Feres (2019)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability Check
| Criterion | Value | Pass? |
|---|---|---|
| `treatment_timing == "staggered"` | staggered | Yes |
| `data_structure == "panel"` | panel | Yes |
| `allow_unbalanced == false` | false | Yes |
| `run_bacon` in metadata | false | Flagged |

## Assessment

### Why NOT_APPLICABLE
The Bacon decomposition is defined only for the canonical TWFE specification:
`Y_it = alpha_i + lambda_t + delta * D_it + e_it`

Article 25 uses 18 time-varying controls (entered as `var × date` linear interactions), plus state-specific linear trends (`UF[date]`). The `bacondecomp` R package requires a controls-free TWFE and will produce meaningless weights when controls are present. This is not a metadata error — the profiler correctly set `run_bacon = false`.

### Forbidden Comparison Risk (Indirect Assessment)
Despite Bacon being inapplicable, we can assess forbidden-comparison risk indirectly:
- CS-NT and CS-NYT yield IDENTICAL ATTs (0.11440) — large never-treated pool
- Growing effects pattern (t=0: +0.003 → t=4: +0.113) — consistent with no negative-weight contamination
- 1.3% gap between TWFE and CS-NT (no controls) — minimal forbidden-comparison contamination signal

### Conclusion
`run_bacon = false` is correct. Forbidden-comparison risk is LOW based on CS-DID convergence. No additional Bacon-specific flags raised.
