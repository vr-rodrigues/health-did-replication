# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 321 (Xu 2023)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability Assessment

Article 321 features:
- **Binary treatment**: `indian_dm1918_post` — a binary 0/1 indicator
- **Single treatment timing**: all treated units adopt simultaneously in 1918 (`treatment_timing = "single"`)
- **Absorbing treatment**: once treated (post-1918), towns remain treated (no treatment reversal)
- **No continuous dose or heterogeneous adoption**: all treated towns receive the same binary treatment

The de Chaisemartin & D'Haultfoeuille (2020) estimator (`did_multiplegt`) is specifically designed for:
1. Non-absorbing (reversible) treatments
2. Continuous or multi-valued treatments
3. Designs with heterogeneous dose at adoption (varying treatment intensity)

**None of these conditions apply here.** The design is a canonical absorbing binary DiD with single treatment timing. The main concern for heterogeneous treatment effect bias from staggered adoption (the de Chaisemartin motivation) is also absent since all units adopt simultaneously.

## Conclusion
The de Chaisemartin & D'Haultfoeuille estimator adds no additional information beyond TWFE and CS-DiD for this design. The verdict is NOT_NEEDED as expected for standard absorbing-binary-single-timing designs.

**Verdict: NOT_NEEDED**
