# HonestDiD Reviewer Report: Article 1094

**Verdict: PASS**
**Date:** 2026-04-18
**Paper:** Fisman & Wang (2017) — "The Distortionary Effects of Incentives in Government: Evidence from China's Death Ceiling Program"

---

## Pre-Conditions

- `has_event_study: true`
- `event_pre: 4` (4 pre-periods available: t=-5, -4, -3, -2, base t=-1)
- `event_post: 4`
- Estimators analysed: TWFE and CS-NT

## 1. Pre-Period Estimates

**TWFE (t=-5 to t=-2, base t=-1):**

| Period | Coef | SE |
|--------|------|----|
| t=-5 | -0.030 | 0.047 |
| t=-4 | +0.019 | 0.055 |
| t=-3 | -0.038 | 0.054 |
| t=-2 | +0.066 | 0.053 |

**CS-NT (t=-5 to t=-2, base t=-1):**

| Period | Coef | SE |
|--------|------|----|
| t=-5 | +0.006 | 0.055 |
| t=-4 | -0.032 | 0.069 |
| t=-3 | -0.103 | 0.069 |
| t=-2 | +0.053 | 0.071 |

## 2. HonestDiD Sensitivity Intervals

**TWFE — Target: first post-period (t=0, point = -0.056):**

| Mbar | Lower | Upper | Includes zero? |
|------|-------|-------|----------------|
| 0 | -0.157 | +0.046 | YES |
| 0.25 | -0.180 | +0.071 | YES |
| 0.5 | -0.210 | +0.099 | YES |
| 1.0 | -0.282 | +0.165 | YES |

**TWFE — Target: average ATT:**

| Mbar | Lower | Upper | Includes zero? |
|------|-------|-------|----------------|
| 0 | -0.124 | +0.077 | YES |
| 0.5 | -0.351 | +0.253 | YES |

**CS-NT — Target: first post-period (t=0, point = -0.075):**

| Mbar | Lower | Upper | Includes zero? |
|------|-------|-------|----------------|
| 0 | -0.169 | +0.019 | YES (barely) |
| 0.25 | -0.206 | +0.054 | YES |
| 0.5 | -0.251 | +0.095 | YES |
| 1.0 | -0.360 | +0.200 | YES |

**CS-NT — Target: average ATT:**

| Mbar | Lower | Upper | Includes zero? |
|------|-------|-------|----------------|
| 0 | -0.119 | +0.074 | YES |
| 0.5 | -0.421 | +0.376 | YES |

## 3. Breakeven Analysis

At Mbar=0 (zero allowed violation of pre-trend linearity):
- TWFE CI for first post: [-0.157, +0.046] — includes zero
- CS-NT CI for first post: [-0.169, +0.019] — narrowly includes zero (upper bound +0.019)

Both estimators fail to robustly reject the null even under the strongest possible parallel trends assumption (Mbar=0). This is consistent with the paper's own finding: the treatment effect is not statistically significant at conventional levels (p ≈ 0.20 for TWFE).

## 4. Interpretation in Context

- The paper does NOT claim a statistically significant treatment effect in Table 2, Col 1
- The HonestDiD sensitivity analysis CONFIRMS the paper's own null finding
- No statistically significant finding is being undermined by the sensitivity analysis
- The analysis is internally consistent with the paper's stated conclusions
- This is a PASS: HonestDiD confirms, not contradicts, the paper's qualitative claims

## 5. Pre-Trend Quality Assessment

TWFE pre-trends: small coefficients (-0.030 to +0.066), all statistically insignificant. Adequate quality.

CS-NT pre-trends: more variable (-0.103 to +0.053). The t=-3 coefficient (-0.103) approaches 1.5 SEs, but still within bounds that permit credible sensitivity analysis. The HonestDiD sensitivity intervals at Mbar=0.25 (allowing 25% additional slope violation) remain wide, consistent with the point estimate.

## 6. Summary

**Verdict: PASS**

HonestDiD sensitivity analysis confirms the paper's null finding at all values of Mbar for both TWFE and CS-NT. No statistically significant claim is overturned. The pre-trend quality is adequate under TWFE (and marginally so under CS-NT). The CS-NT first-period CI at Mbar=0 barely includes zero (upper bound = +0.019), which is the closest thing to a concern here but is consistent with the original paper's non-significant p-value.
