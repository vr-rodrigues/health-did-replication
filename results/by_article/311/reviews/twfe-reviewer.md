# TWFE Reviewer Report — Article 311

**Verdict:** WARN

**Reviewer:** twfe-reviewer
**Date:** 2026-04-18
**Article:** Galasso & Schankerman (2024) — Licensing Life-Saving Drugs for Developing Countries

---

## Checklist

### 1. Treatment timing
- [x] Treatment timing is staggered across units (7 cohorts: 2011–2017). TWFE with staggered adoption is known to produce a weighted average that can include negative weights (Goodman-Bacon 2021). **WARN.**

### 2. Pre-trends
- [x] Event study data available. TWFE pre-period coefficients:
  - t=-6: -0.021 (se=0.048) — not significant
  - t=-5: -0.009 (se=0.046) — not significant
  - t=-4: +0.046 (se=0.016) — marginally significant (2.8σ)
  - t=-3: +0.042 (se=0.011) — significant (3.8σ)
  - t=-2: +0.010 (se=0.006) — marginally significant (1.7σ)
- **WARN:** Pre-periods t=-4 and t=-3 show statistically significant positive coefficients, suggesting possible pre-trend or anticipation effects. This is a notable concern — treated units appear to be on a rising trajectory before treatment.

### 3. Panel balance
- Panel fill rate is 84.8% (unbalanced). `allow_unbalanced = false` in metadata, meaning the template was instructed to balance the panel. Forced balancing of an inherently unbalanced panel may introduce composition bias. **WARN.**

### 4. Clustering
- Paper uses two-way clustering (product_code × country_code); template uses one-way clustering on product_code. Standard errors may be underestimated relative to the paper's specification. **WARN.**

### 5. Binary outcome
- Outcome (`access`) is binary. TWFE with a binary LPM outcome is estimating a probability, which is standard but imposes linearity. With a large share of never-treated units (84.6%), this is less likely to produce boundary issues.

### 6. TWFE estimate
- beta_twfe = 0.663 (se = 0.050). Large, highly significant effect. Robust to eyeballing the event-study post-period coefficients (all ~0.62–0.77).

---

## Summary

The TWFE estimate of 0.663 is large and statistically robust. However, three methodological concerns arise: (1) significant pre-trend coefficients at t=-4 and t=-3 undermine the parallel trends assumption; (2) staggered adoption creates contaminated comparisons under TWFE; (3) the clustering specification differs from the paper. These concerns are partially mitigated by the large effect size.

**Verdict: WARN** (pre-trend violation at t=-4, t=-3; staggered contamination risk; clustering mismatch)
