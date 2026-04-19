# CS-DID Reviewer Report — Article 437 (Hausman 2014)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Estimator configuration
- CS-NT (never-treated control group): att_csdid_nt = -1.943 (SE 22.305)
- CS-NYT (not-yet-treated control group): att_csdid_nyt = -3.724 (SE 20.164)
- Both estimators run. No controls (cs_controls = []). Consistent with metadata.
- PASS on configuration.

### 2. Sign reversal relative to TWFE
- TWFE = -42.245; CS-NT = -1.943; CS-NYT = -3.724.
- Direction is the same (negative) but magnitude collapses by ~20x (from -42 to -2 to -4 person-rem).
- This is the 20x magnitude shrinkage flagged by the user. It constitutes a material WARN.
- The metadata note (Pattern 46) diagnoses the root cause: massive secular decline (personrem 1200→135 over 1974–2008), 25-year pre-treatment window, unbalanced panel (only 14/63 facilities span the full range), and 3 singleton cohorts with extreme leverage.

### 3. Simple vs. dynamic ATT consistency
- CS-NT simple = -2.161 (SE 22.726); CS-NT dynamic = 2.063 (SE 21.733).
- CS-NYT simple = -4.589 (SE 23.788); CS-NYT dynamic = 0.217 (SE 21.485).
- Simple and dynamic ATTs are close in magnitude but inconsistent in sign (dynamic slightly positive for NT, slightly positive for NYT). None statistically significant. WARN: sign inconsistency across aggregation methods.

### 4. Pre-trend assessment (event study)
- Event study pre-periods (t = -6 to -1), CS-NT:
  - t=-6: +19.02 (SE 39.34) — large but not significant
  - t=-5: -13.63 (SE 30.24)
  - t=-4: +2.59 (SE 28.15)
  - t=-3: +18.82 (SE 23.39)
  - t=-2: +12.34 (SE 45.05)
- Pre-trends are noisy and not individually significant, but the irregular oscillating pattern (positive, negative, positive, positive, positive) is inconsistent with a clean flat pre-trend.
- The large SE values reflect the substantial within-cohort variation and small cohort sizes (some cohorts have n=1 or n=2 facilities).
- WARN: pre-trends are noisy and oscillating, consistent with poor pre-trend balance rather than a clean parallel trends condition.

### 5. Singleton cohort leverage
- Cohort 2003: 1 facility. Cohort 2004: 1 facility. Cohort 2006: 1 facility. Three singleton cohorts.
- CS-DID ATT estimates for singleton cohorts are measured without uncertainty (they cannot be estimated properly). These cohorts contribute extreme leverage to the pooled ATT.
- WARN: 3/9 treatment cohorts are singletons, severely compromising the reliability of the CS-DID aggregate.

### 6. NT vs. NYT convergence
- CS-NT = -1.943; CS-NYT = -3.724. Difference = 1.78 (less than 0.1 SE). Convergence is acceptable.
- PASS on NT/NYT convergence.

### 7. Unbalanced panel concern
- allow_unbalanced = true. Only 14 of 63 facilities have data spanning the full 1974–2008 range.
- CS-DID with a universal base period will mix high-personrem 1970s–80s observations with low-personrem 1990s–2000s, creating composition effects in the group-time ATTs.
- WARN: unbalanced panel with universal base period creates composition effects — CS estimator is not measuring a clean ATT.

### 8. Comparison with TWFE
- TWFE = -42.245; CS-NT = -1.943; CS-NYT = -3.724.
- Gap = 40.3 person-rem (TWFE overstates the magnitude by ~21x relative to CS-NT).
- Per Bacon decomposition (see Bacon reviewer), TWFE is contaminated by negative forbidden comparisons and by the secular decline giving early-treated cohorts artificially low post-period values.
- WARN: the 20x magnitude gap between TWFE and CS-DID is the central finding and indicates severe heterogeneous treatment effects or composition bias in TWFE.

## Material concerns
1. WARN: 20x magnitude collapse from TWFE (-42.2) to CS-NT (-1.9) / CS-NYT (-3.7)
2. WARN: 3 singleton cohorts (2003, 2004, 2006) with extreme leverage
3. WARN: unbalanced panel with universal base period creates composition effects
4. WARN: simple vs. dynamic sign inconsistency (positive dynamic despite negative simple)
5. WARN: oscillating pre-trends inconsistent with clean parallel trends

## Summary
CS-DID implementation is technically correct (matches metadata spec, no-controls, both NT and NYT run). However, the estimator reveals a massive 20x magnitude collapse relative to TWFE (TWFE = -42.2 vs CS-NT = -1.9 person-rem). The CS-DID estimates are themselves unreliable due to 3 singleton cohorts, severe unbalanced panel composition effects, and a 34-year panel with massive secular decline. All CS estimates are statistically insignificant. The metadata note correctly diagnoses this as Pattern 46 (composition effects from long pre-treatment). Verdict: WARN.
