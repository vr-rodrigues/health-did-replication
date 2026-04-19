# TWFE Reviewer Report — Article 321 (Xu 2023)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Specification fidelity
- Outcome: `log_deaths_town` (log mortality). Unit FE (`cid`) + year FE (`year`). No additional controls. Cluster at district (`did`). This matches the paper's Table 2, Column 3 specification exactly.
- `beta_twfe = -0.142352`, `se_twfe = 0.041021`. Paper reports -0.142, SE=0.041. Replication is within 0.02% — EXACT match.
- Treatment variable `indian_dm1918_post` is pre-computed in the data; correctly absorbs single-timing binary treatment.

### 2. Pre-trend assessment (TWFE event study)
Pre-period coefficients (relative to t=-1 normalised to 0):

| Period | Coef | SE | t-stat | Significant? |
|--------|------|----|--------|--------------|
| t=-5 | -0.081 | 0.059 | -1.37 | No |
| t=-4 | -0.155 | 0.054 | -2.87 | **YES** |
| t=-3 | -0.149 | 0.056 | -2.66 | **YES** |
| t=-2 | -0.112 | 0.057 | -1.96 | Borderline |

**Two pre-periods are statistically significant** (t=-4 and t=-3 at 5% level). This is a substantive parallel trends concern. The pre-trend pattern is non-monotonic (dips at t=-4/-3, then rises at t=-2) but the magnitudes (~0.10-0.15 log points) are comparable to the treatment effect itself (-0.142).

### 3. Post-period dynamics
| Period | Coef | SE | t-stat |
|--------|------|----|--------|
| t=0 | -0.180 | 0.068 | -2.63 |
| t=1 | -0.312 | 0.106 | -2.95 |
| t=2 | -0.154 | 0.088 | -1.75 |
| t=3 | -0.111 | 0.060 | -1.85 |

The treatment effect is largest at t=1 (-0.312), potentially indicating a one-year lagged effect of the 1918 pandemic on towns with Indian DMs. The effect attenuates by t=2-3.

### 4. Negative weighting concern
- Single treatment timing (`treatment_timing = "single"`): all treated units treated simultaneously in 1918. No staggered adoption → no negative-weighting Goodman-Bacon concern. TWFE = 2×2 DiD in this context.
- SA event study coefficients are nearly identical to TWFE, confirming no heterogeneous-timing bias.

### 5. Concerns
- **Significant pre-trends**: t=-4 (t-stat=-2.87) and t=-3 (t-stat=-2.66) are statistically significant. This violates the parallel trends assumption.
- **Gardner (BJS) attenuation**: Gardner post-period coefficients are substantially smaller than TWFE (t=0: -0.082 vs -0.180; t=1: -0.221 vs -0.312; t=2: -0.067 vs -0.154; t=3: -0.017 vs -0.111). BJS robustness estimator shows considerable attenuation, suggesting TWFE may be picking up level differences correlated with the pre-treatment outcome path.
- **No controls**: The specification has zero controls. This is correct per the paper (Table 2 col 3), but limits the ability to account for pre-existing town-level differences.

## Summary
The TWFE point estimate reproduces the paper exactly. However, two pre-period event-study coefficients are statistically significant, and Gardner/BJS estimates are systematically attenuated (35-85% smaller). The combination of significant pre-trends and BJS attenuation raises a credibility concern.

**Verdict: WARN** (significant pre-trends in t=-3 and t=-4; Gardner BJS attenuation)
