# Bacon Decomposition Reviewer Report: Article 262

**Verdict:** WARN
**Date:** 2026-04-18
**Article:** Anderson, Charles, Rees (2020) — Hospital Desegregation & Black Postneonatal Mortality

---

## Applicability

- treatment_timing: staggered — YES
- data_structure: panel — YES
- allow_unbalanced: false — YES (balanced panel enforced)
- run_bacon: false in metadata (Pattern 49 in metadata notes: SA removed due to cohort imbalance)
- **Bacon data file exists** (`bacon.csv`) despite run_bacon=false — decomposition was run and cached.
- **Verdict: APPLICABLE** — Bacon data available for review.

---

## Checklist

### 1. Decomposition Overview

The Bacon decomposition partitions the TWFE estimate (1.221) into three components:

| Type | Weighted Avg Estimate | Total Weight | Share |
|------|----------------------|-------------|-------|
| Earlier vs Later Treated | 1.91 | 0.595 | 59.5% |
| Later vs Earlier Treated | 3.38 | 0.291 | 29.1% |
| Treated vs Untreated | 9.15 | 0.114 | 11.4% |

Total timing-group weight: 88.6%. Total TvU weight: 11.4%.

### 2. Negative Weight Problem Assessment

**Concern: Earlier vs Later Treated ("forbidden" comparison)**

The 59.5% weight on "Earlier vs Later Treated" means the TWFE estimate relies heavily on comparisons where 1967 (the dominant early adopter, 85% of treated units) is used as a control for all later cohorts (1968–1973). This is the classic Callaway-Sant'Anna concern: if the 1967 cohort's treatment effects are still changing when later cohorts adopt, these comparisons contaminate the TWFE estimate.

However, examining the individual pair estimates:
- 1967 vs 1968 (wt=19.9%): 3.62 (Earlier vs Later) — a valid 2x2 DiD
- 1968 vs 1967 (wt=14.9%): 3.86 (Later vs Earlier) — also valid
- Both are positive and large

The key question is whether early cohort treatment effects are stable (satisfying the "no anticipation + parallel trends" assumption even when using treated units as controls). Given that the CS-NT estimate (0.995) is lower than most individual Bacon 2x2s involving late-vs-untreated (TvU avg=9.15), there is evidence of **heterogeneity**: the TvU comparison gives much higher estimates than timing-group comparisons, suggesting the 1967 cohort's effect measured against untreated units is larger than the timing comparisons suggest.

### 3. Cohort 1967 Dominance

The 1967 cohort constitutes ~85% of treated observations. In the Bacon decomposition:
- 1967 appears in many pairs as both treated and (later) "clean" control
- The pairs 1967 vs [1968–1973] collectively receive the largest individual weights
- This extreme imbalance means the TWFE estimate is essentially the 1967 cohort's effect, adjusted by noisy small-sample comparisons for later cohorts

### 4. Sign Consistency

All Bacon 2x2 estimates are **positive** across treated-vs-untreated and most timing pairs. A few Later-vs-Earlier pairs involving cohort 1969 show negative estimates (e.g., 1969 vs 1967 = −1.33, 1969 vs 1968 = −8.46), suggesting the 1969 cohort may have anomalous pre-adoption trends relative to earlier adopters. However, these pairs have small weights (<0.5%).

### 5. Metadata Flag: run_bacon=false

The metadata sets run_bacon=false and notes "Pattern 49: cohorts extremely unbalanced — 1967=85%, 1970-73<1% each." This was a design decision to exclude Bacon from the main analysis. Given the Bacon results confirm the cohort imbalance concern, this decision was reasonable. However, the decomposition remains informative for understanding the TWFE estimate's composition.

---

## Summary

The Bacon decomposition reveals that 88.6% of the TWFE weight comes from timing-group comparisons (mostly 1967 cohort serving as comparison). All estimates are directionally positive. The main concern is: (1) TvU comparison gives much higher ATTs (~9.15) than timing comparisons (~2.4 pooled), indicating substantial treatment effect heterogeneity across cohort adoption timing; (2) the 1969 cohort shows negative estimates in some timing pairs; (3) the extreme 1967 dominance means the TWFE aggregate primarily reflects the early-adopting cohort's experience.

**Verdict: WARN** — Substantial treatment effect heterogeneity across Bacon components (TvU avg ~9x the timing-group avg), and cohort 1969 shows anomalous negative estimates in some pairs. The TWFE aggregate is dominated by timing-group comparisons, not the cleanest TvU comparison.
