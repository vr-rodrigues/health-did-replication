# TWFE Reviewer Report — Article 228
# Sarmiento, Wagner & Zaklan (2023) — Air Quality and LEZ

**Verdict:** WARN
**Date:** 2026-04-18

---

## Checklist

### 1. Specification alignment

The paper's primary TWFE uses **daily** data with weather controls (temperature, precipitation, wind) and station × year fixed effects. Our TWFE uses **yearly** aggregated data with no controls and only unit + time FE. This is a deliberate metadata choice (`twfe_controls: []`, `data_structure: panel`, `time: Period` = year) made for comparability with CS-DiD, which cannot incorporate weather controls at daily frequency.

- **WARN**: Our TWFE (-1.240, SE=0.327) operates on a different data granularity and control set than the paper's TWFE. The gap vs. CS-NT (-1.642) is partly explained by this specification gap, not solely by heterogeneous treatment effects.

### 2. TWFE static estimate

- `beta_twfe = -1.2396` (SE = 0.3274)
- `beta_twfe_no_ctrls = -1.2396` (same — no controls in spec)
- Negative sign is consistent with paper's finding that LEZs reduce PM10. Direction is confirmed.

### 3. TWFE vs. CS-DiD gap

- TWFE static: -1.240
- CS-NT simple (aggte): -1.803 (45.5% larger in magnitude)
- CS-NT dynamic (aggte): -1.954 (57.7% larger)
- CS-NYT simple: -1.795; CS-NYT dynamic: -1.948

The substantial TWFE underestimate relative to CS aggregates is consistent with the negative weighting problem documented in Bacon decomposition. Some "Later vs Earlier Treated" pairs carry positive estimates that dilute the TWFE. The event study confirms a growing treatment effect over time (from -0.48 at h=0 to -2.35 at h=5), which is precisely the configuration where TWFE static estimates are most downward-biased.

- **WARN**: TWFE underestimates the ATT by approximately 36-58% relative to modern estimators due to negative-weight contamination from late-treated cohort comparisons and growing treatment effects over time.

### 4. Pre-trend assessment (TWFE event study)

Event study coefficients at pre-periods (normalised to h=-1=0):
- h=-6: -0.353 (SE=0.604) — not significant
- h=-5: +0.294 (SE=0.532) — not significant
- h=-4: +0.132 (SE=0.411) — not significant
- h=-3: -0.410 (SE=0.434) — not significant
- h=-2: +0.077 (SE=0.440) — not significant

Pre-trends are flat and statistically insignificant. **PASS on parallel trends (TWFE).**

### 5. Growing treatment effects and TWFE contamination

The TWFE dynamic event study shows monotonically growing effects:
h=0: -0.48, h=1: -0.55, h=2: -1.00, h=3: -1.32, h=4: -1.55, h=5: -2.35

Growing effects → TWFE static estimate is a weighted average of ATT(g,t) with potentially negative weights for later adoption cohorts used as clean controls for earlier-treated units. Bacon decomposition confirms significant "Later vs Earlier Treated" pairs with heterogeneous signs, though these comprise only ~2-5% of total weight.

### 6. Metadata fidelity

- `treatment_timing: staggered` — correct (cohorts 2008-2016)
- `data_structure: panel` — correct
- `allow_unbalanced: true` — noted; 588 stations over 14 years with staggered treatment
- `gvar_cs: treat_cohort` — correct grouping variable for CS-DiD
- `additional_fes: []` — no extra FEs; standard unit + time FE only. The paper uses station FE + year FE, which matches.

### 7. VCOV warning (SA estimator)

The notes flag a VCOV warning for SA due to small cohorts (2010, 2015, 2016). This does not affect the TWFE estimate itself but signals limited variation in some cohort-year cells.

---

## Summary

The TWFE estimate of -1.240 µg/m³ is internally consistent and shows clean pre-trends, confirming the sign and rough magnitude of the LEZ effect. However, two concerns warrant WARN status:

1. **Data granularity mismatch**: Our TWFE uses yearly data without weather controls vs. the paper's daily-data TWFE with weather controls — the two are not directly comparable.
2. **Negative-weight contamination**: Staggered adoption with growing treatment effects causes the TWFE static estimate to significantly understate the ATT, confirmed by the 36-58% gap to CS aggregates.

These are not fatal flaws but represent well-known limitations of the TWFE estimator in this design.

**Full data path:** `results/by_article/228/results.csv`, `results/by_article/228/event_study_data.csv`
