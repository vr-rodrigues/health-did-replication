# TWFE Reviewer Report: Article 281 — Steffens, Pereda (2025)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Specification adequacy
- Treatment variable: `Post_avg` — a binary indicator for 2009-treated states post-2009. The paper studies effects of Brazilian smoking bans.
- Fixed effects: unit (individual id) and time (year), standard TWFE.
- Covariates: none (`twfe_controls = []`). The metadata explicitly notes "unica_sem_controles" (single specification without controls). The paper's baseline uses no time-varying controls, consistent with stated selection protocol.
- Clustering: by `uf` (Brazilian state) — appropriate geographic unit for the policy variation.
- Weights: survey weights applied (`weight = weight`), correct for PNS cross-sectional data expanded into synthetic panel.

### 2. Treatment design concerns
- **Single timing design implemented correctly:** `treatment_timing == "single"`, only 2009-cohort treated (states that adopted smoking ban in 2009). States treated in 2008, 2010, 2011 are excluded via `sample_filter`.
- **WARN — Synthetic panel construction:** The data is a cross-sectional survey (PNS 2013) expanded synthetically into a 2004–2013 panel by repeating each observation 10 times. This is a known approach in the literature for retrospective smoking histories, but introduces non-independence of observations within person-year. The clustering at `uf` level partially addresses this, but the panel is not a true longitudinal panel — unit IDs (`id`) are constructed and not truly tracked over time.
- **WARN — Pre-treatment trends:** TWFE event-study pre-treatment coefficients at t=-4 are -0.0072 (se=0.0045), at t=-3 -0.0043, at t=-2 -0.0028. While individually insignificant, there is a monotonic upward trend toward zero suggesting the no-pretrend assumption may be borderline (pre-periods show a systematic pattern rather than noise around zero).

### 3. Coefficient magnitude and significance
- `beta_twfe = 0.00240` (se = 0.00553): Near-zero, statistically insignificant (t ≈ 0.43). The headline result is a null finding — the TWFE estimate is not statistically distinguishable from zero.
- Post-period event-study: t=0: +0.0019, t=1: +0.0035, t=2: +0.0022, t=3: -0.0069, t=4: -0.0092. The sign reversal in later post-periods is notable — this is consistent with the paper's story of dynamic effects (delayed reductions in smoking prevalence) but makes the static ATT interpretation less meaningful.

### 4. Methodological flags
- **WARN:** The static TWFE coefficient aggregates over post-periods that include sign reversals. The average over 5 post-periods mixes early null/positive effects with later negative effects, producing a near-zero average that obscures the dynamic pattern.
- PASS: No controls omitted incorrectly relative to stated spec.
- PASS: Cluster-robust SEs at state level — appropriate.

## Summary
The TWFE implementation is technically correct given the metadata spec. Two WARNs are raised: (1) the synthetic panel construction introduces within-person serial correlation not fully addressed by state-level clustering, and (2) the pre-trend pattern in the TWFE event study is monotonically increasing toward zero (not purely random), suggesting borderline parallel trends. The null static ATT conceals important dynamic heterogeneity visible in the event study.

Full data: `results/by_article/281/results.csv`, `results/by_article/281/event_study_data.csv`
