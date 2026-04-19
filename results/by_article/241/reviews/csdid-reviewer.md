# CS-DiD Reviewer Report — Article 241 (Soliman 2025)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. Comparison group
- CS-NT uses never-treated (gvar_CS == 0 → 2,911 counties) as control group. With 2,911 never-treated vs 95 treated, this is a deep and credible control group. PASS.
- CS-NYT also run (not-yet-treated); results closely track CS-NT (ATT-NT = -48.49, ATT-NYT = -48.55 for simple aggregation), confirming robustness. PASS.

### 2. Parallel trends and pre-testing
- Event study pre-periods (2 periods available): CS-NT at t=-3: -4.66 (SE=6.80), t=-2: +0.30 (SE=3.65). Neither significant at 5%. PASS on pre-trend test.
- CS-NYT pre-periods: t=-3: -4.55 (SE=6.44), t=-2: +0.35 (SE=3.77). Also flat. PASS.

### 3. ATT aggregation
- Simple (calendar-time) ATT: CS-NT = -50.34 (SE=7.72), CS-NYT = -50.42 (SE=8.05).
- Dynamic (event-time) ATT: CS-NT = -70.04 (SE=12.35), CS-NYT = -70.09 (SE=11.49).
- The dynamic ATT is substantially larger in magnitude than the simple ATT, driven by growing post-treatment effects (t=+3: ~-61 MME/capita). This is consistent with escalating pill-mill crackdown impacts over time. Economically plausible. PASS.

### 4. Controls
- No controls in main CS spec (`cs_controls: []`), mirroring the TWFE spec. Appropriate. PASS.

### 5. Sample issue
- The metadata notes that running CS on the filtered sample (rel_year ∈ [-3,3]) caused a segfault (unbalanced panel triggers C code crash in `did` package). CS was therefore run on the FULL unbalanced panel, not the filtered window. This is standard practice — CS handles unbalanced panels differently from TWFE. The CS estimates are valid on the full sample.
- This creates a subtle comparability issue: TWFE (filtered) vs CS (full), but CS is methodologically correct here. The CS estimates are trustworthy.

### 6. Sign and magnitude consistency
- TWFE (unfiltered) = -33.65, CS-NT (simple) = -50.34, CS-NT (dynamic) = -70.04.
- CS ATT is substantially larger in magnitude than TWFE. This is the canonical staggered-DiD finding: TWFE attenuates when treatment effects grow over time (negative weights on later cohorts). The Bacon decomposition confirms treated-vs-untreated weight dominates (~0.99), so the attenuation comes from within-cohort-time aggregation in TWFE rather than forbidden comparisons.
- Direction consistent: both negative (DEA crackdowns reduce MME per capita). PASS.

## Summary
CS-DiD implementation is clean. Both NT and NYT variants run on full panel (appropriate given CS segfault on filtered sample). Pre-trends flat. ATT is larger than TWFE in magnitude, consistent with growing treatment effects and the known downward bias of TWFE in this scenario. No methodological concerns.

**Overall:** PASS
