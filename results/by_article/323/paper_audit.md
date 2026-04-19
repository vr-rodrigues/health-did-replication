# Paper fidelity audit: 323 — Prem, Vargas, Mejia (2023)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-19

## Selected specification
From metadata notes + Table 1 Col 1 (paper's headline): Treatment x Announcement on coca area (share of municipal area cultivated with coca per 1,000 hectares). Continuous treatment = coca suitability index (standardized). Municipality FE + Year FE. SE clustered at municipality level. N = 8,736 obs, 1,092 municipalities.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 1 Col 1) | 0.30 | (0.12) | 8,736 | municipality | ** |
| Our stored results.csv | 0.6427 | 0.1992 | 8,736 | municipality | *** |
| Relative Δ | +114.2% | +66.0% | — | — | — |

## Notes
- The paper's coefficient (0.30) is a marginal effect from a **continuous** treatment: a one-standard-deviation increase in coca suitability index x announcement dummy. This is the parameter β in equation (1).
- Our stored estimate (0.6427) comes from a **binarized** treatment: municipalities above the median suitability are classified as treated (gvar=2014), those below as control (gvar=0). This is a binary DiD ATT on a different estimand.
- The two numbers cannot be compared on a common scale: the paper's β is a per-SD marginal effect of a continuous instrument; ours is the average treatment effect for the above-median group. Any numeric Δ is purely an artifact of the different parameterization.
- The metadata `original_result` field documents β=0.30 from the paper for reference, but the metadata `notes` explicitly states the binarization choice for replication purposes (CS-DID requires a binary treatment indicator).
- N = 8,736 matches exactly between paper and our data, confirming the same sample is used.
- The SE divergence (66%) also reflects the different treatment variable scale, not a clustering or implementation error.
- This is the canonical NOT_APPLICABLE case: our stored TWFE uses a deliberate estimand transformation (continuous → binary) that makes direct comparison with the published coefficient meaningless. The binarized specification is necessary for CS-DID comparability.

## Verdict rationale
NOT_APPLICABLE: the paper's headline estimate (β=0.30 per SD of continuous suitability) and our stored estimate (β=0.643 for binarized above/below-median treatment) measure different estimands by design; no direct fidelity comparison is possible.
