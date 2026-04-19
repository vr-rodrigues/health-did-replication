# Bacon Decomposition Reviewer Report — Article 359

**Article:** Anderson, Charles, Olivares, Rees (2019) — "Was the First Public Health Campaign Successful?"
**Reviewer:** bacon-reviewer
**Date:** 2026-04-18
**Applicability note:** Metadata specifies `data_structure = "repeated_cross_section"`. Bacon decomposition is most valid for balanced panel data. The decomposition was run (run_bacon: true) and results exist; reviewing them with the caveat that the repeated cross-section structure makes the decomposition approximate. Results exist and are reviewed for completeness.
**Verdict:** WARN

---

## Checklist

### 1. Decomposition structure
- 13 cohort groups (1900–1914), all treated vs. never-treated (99999).
- Three comparison types present: "Treated vs Untreated", "Later vs Always Treated", "Earlier vs Later Treated".
- The "always treated" group here is cohort 1900 — the earliest adopters.

### 2. Weight distribution
- "Treated vs Untreated" comparisons dominate by weight (weights ~0.01–0.12 per pair).
- "Later vs Always Treated" and "Earlier vs Later Treated" comparisons have very small weights (<0.002 per pair) but many pairs.
- This is favorable: the bulk of identification comes from the cleaner treated-vs-never-treated comparisons, not from problematic earlier-vs-later comparisons.

### 3. Heterogeneity assessment
- **Treated vs Untreated 2x2 DiDs range**: +0.285 (cohort 1910) to -0.354 (cohort 1914). Enormous spread.
- **Later vs Always Treated**: ranges from +0.228 (1910 vs 1900) to -0.415 (1914 vs 1900). Extreme heterogeneity.
- **Earlier vs Later Treated**: many negative values, some positive.
- Sign heterogeneity is pervasive: roughly half of cohort-specific DiDs are positive, half negative.
- The TWFE aggregate (-0.036) is a weighted average of these wildly heterogeneous estimates. **WARN**

### 4. Negative weights / contamination
- "Earlier vs Later Treated" comparisons use already-treated units as controls, creating potential negative-weight issues. However, these pairs carry very small aggregate weight.
- The dominant source of heterogeneity is genuine variation in cohort-specific treatment effects (some cohorts showing TB reduction, others not), not primarily negative weights. **WARN**

### 5. Weighted sum consistency
- The weighted average of all 2x2 DiDs should sum to the TWFE estimate (-0.036). A quick check of the dominant Treated vs Untreated terms (weights sum to ~0.90) weighted against their estimates gives an approximate average of -0.03 to -0.05 — broadly consistent with TWFE. **PASS**

### 6. Data structure caveat
- Bacon decomposition assumes a balanced panel for exact decomposition. With a repeated cross-section (53% fill rate), the decomposition is approximate. Results should be interpreted as indicative rather than exact.

---

## Summary

The Bacon decomposition reveals extreme treatment effect heterogeneity across the 16 adoption cohorts. Cohort 1910 shows a large positive 2x2 DiD (+0.285 vs never-treated) while cohort 1914 shows a large negative 2x2 DiD (-0.354). This heterogeneity — not negative weights — is the primary driver of uncertainty in the TWFE estimate. The decomposition is approximate due to the repeated cross-section structure. The core finding is that the anti-TB public health campaign had very different effects (or confounding factors) across adoption cohorts, making the TWFE aggregate hard to interpret as a single policy-relevant parameter.

**Verdict: WARN** — Extreme cohort-specific heterogeneity; decomposition approximate due to non-panel data structure.

