# CS-DID Reviewer Report — Article 201 (Maclean & Pabilonia 2025)

**Verdict:** WARN

**Date:** 2026-04-18

## Checklist

### 1. CS-DID setup appropriateness
The underlying data is a repeated cross-section (ATUS, monthly, 139K obs with hh_child==1). CS-DID requires panel data (same units observed over time). The workaround — collapsing monthly ATUS microdata to yearly state×year means — is a common approach but introduces three concerns:
- (a) The collapsed panel treats the state-year cell mean as if it were a panel unit, losing within-cell variation.
- (b) Sample sizes per state-year cell are very small (ATUS declining coverage; some cells have <5 obs per state-year).
- (c) Collapsing to yearly discards the monthly variation that the TWFE exploits.

The approach is defensible (Gardner 2022 also requires panel-level data and has similar issues), but introduces imprecision.

### 2. Group variable construction
gvar_CS is constructed as the first year in which pslm_state_lag2==1 is observed in the monthly data, then converted to a calendar year. This is a reasonable mapping. Six cohorts identified: first_t years 2014, 2017, 2018, 2019, 2020, 2022 (in monthly encoding → calendar years).

### 3. Control group
Never-treated (34 states that never adopted PSL by end of study period). This is the appropriate control group given the available variation.

### 4. Covariates
cs_controls: [] (empty). The 19 individual and state-level covariates used in TWFE are unavailable in the collapsed yearly panel. This is a limitation flagged in the metadata: the CS-DID estimates are unconditional ATTs, while TWFE conditions on a rich covariate set. The comparison between TWFE (+4.61 with controls) and CS-NT (-1.92 without controls) is therefore not apples-to-apples.

### 5. ATT estimates
- att_csdid_nt = 0.637 (SE=6.055) — near-zero, insignificant
- att_nt_simple = -1.916 (SE=5.795) — small negative, insignificant
- att_nt_dynamic = -3.044 (SE=4.745) — small negative, insignificant
- CS with controls: FAIL (control variables not in collapsed data)

All CS-NT estimates are statistically insignificant (p > 0.5 approximately). The point estimates are negative or near-zero, contrasting with TWFE's positive significant estimate.

### 6. Pre-trend assessment (CS-NT event study)
CS-NT pre-period coefficients (yearly collapsed):
- t=-8: +6.75 (SE=8.68) — positive, insignificant
- t=-7: +5.39 (SE=7.12) — positive, insignificant
- t=-6: +3.81 (SE=9.34) — positive, insignificant
- t=-5: +5.57 (SE=7.52) — positive, insignificant
- t=-4: +8.38 (SE=6.13) — positive, marginally significant (t≈1.37)
- t=-3: +0.37 (SE=5.52) — near zero
- t=-2: +3.57 (SE=5.89) — positive, insignificant

Pre-trends show a pattern of positive but insignificant coefficients in the distant pre-period (t=-8 to t=-5), with magnitudes around +5-8 minutes. This mildly suggests treated states had slightly higher (or trending higher) childcare pre-treatment, though none are individually significant. The t=-4 coefficient (8.38) approaches significance. This is a mild concern for parallel trends.

### 7. Post-period pattern
CS-NT post-period: t=0: +2.92, t=1: +9.84, t=2: -8.08, t=3: -0.02, t=4: -17.51, t=5: -5.41, t=6: -7.17, t=7: +21.59.
High variance across post-periods. The t=+7 estimate (+21.59, SE=3.66) is anomalously large and positive — this is a binning artifact noted in the metadata: at h=+7, only Cohort 2014 (CT, N≈33 state-year cells) contributes, making it extremely noisy and unreliable. The endpoint restriction creates this artefact.

### 8. Sign reversal vs TWFE
TWFE=+4.61 (p<0.05) vs CS-NT simple=-1.92 (ns) is a sign reversal of 6.5 minutes. This is material but the CS-NT estimates are so imprecise (SE≈5-6 minutes) that the two confidence intervals overlap substantially. The reversal is partly explained by:
(a) Cohort 2020 (34% weight in TWFE, ATT=+10.12) possibly COVID-confounded — CS distributes weights more uniformly across cohorts.
(b) Missing controls in CS-NT (could attenuate estimates).
(c) Data collapse from monthly to yearly losing precision.

### 9. CS-DID with controls failure
FAIL_other: "The following variables are not in data: fam_med, pto_state, poverty, pop, female, age, age2, non_wh..." — this is an implementation limitation stemming from the data structure. The unconditional CS estimates are valid but less comparable to the TWFE specification.

## Summary
WARN issued because:
1. Pre-period CS-NT coefficients show a pattern of mild positive coefficients (t=-8 to t=-4: +6 to +8 min), suggesting possible pre-existing trend differences — though none individually significant.
2. Post-period t=+7 estimate is an endpoint binning artefact (pure Cohort 2014, N≈33).
3. CS estimates lack controls (implementation limitation), making direct comparison to TWFE difficult.
4. All CS-NT ATT estimates are statistically insignificant; sign reversal vs TWFE is real but partially explainable.

The CS-DID setup is as well-executed as the data structure allows, but the RCS-to-yearly collapse and missing controls are inherent limitations that reduce confidence in the CS-NT estimates.

## Reference
Full data: `results/by_article/201/results.csv`, `results/by_article/201/event_study_data.csv`
