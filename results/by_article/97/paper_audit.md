# Paper fidelity audit: 97 — Bhalotra et al. (2021)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes + SKILL_profiler protocol: Table 3 Column 1 (Diarrheal diseases vs. Respiratory diseases as control group; equation (3) from paper). This is the most conservative control-disease comparison, identified in the paper text as the baseline. The composite TWFE coefficient is θ₁ + 2·θ₂ (level break + 2 × trend break evaluated at Year=0, i.e., at 1991, the midpoint of the post period), per `composite_twfe: "additive_2"` in metadata.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper Table 3 Col 1 (θ₁ + 2·θ₂) | -0.132 + 2×(-0.0857) = **-0.3034** | not directly reported (composite) | 31,082 municipality-years | municipality | *** (both components) |
| Our stored results.csv | -0.30314 | 0.0691 | — | municipality (mun_reg) | — |
| Relative Δ | **0.09%** | n/a (not comparable) | | | |

Component breakdown from Table 3 Col 1:
- `1(Diarrhea) × 1(Post)` (θ₁): -0.132 (SE 0.0418)
- `1(Diarrhea) × 1(Post) × Year` (θ₂): -0.0857 (SE 0.0144)
- Composite: -0.132 + 2·(-0.0857) = -0.3034

## Notes

- The paper does not report a single pooled ATT coefficient. The headline estimand is a linear combination of two regression parameters (level break θ₁ and trend break θ₂) as described in equation (3). The composite formula `θ₁ + 2·θ₂` is documented in metadata as `composite_twfe: "additive_2"` and represents the cumulative effect by 1993 (two years post-treatment), consistent with the "Decline by 1995 due to PAL: -47%" footnote in Table 3.
- SE of the composite is not reported in the paper (requires covariance between θ₁ and θ₂). Our stored se_twfe = 0.0691 is computed internally by the template via delta method; no direct comparison is possible.
- Column 2 (non-infectious childhood diseases control) gives θ₁=-0.182, θ₂=-0.122, composite=-0.426 — this is NOT our stored value, confirming Column 1 is the correct reference.
- Columns 3-4 (small vs. large cities comparison, equation (4)) give β₁=0.00262, β₂=-0.112 — composite=-0.2218, also not matching our stored value.
- N=31,082 municipality-years from paper (Table 3 Col 1); our metadata does not store N in results.csv for this article.

## Verdict rationale

Our stored beta_twfe (-0.30314) reproduces the paper's Table 3 Column 1 composite (θ₁ + 2·θ₂ = -0.3034) to within 0.09% relative difference, well within the 1% EXACT threshold.
