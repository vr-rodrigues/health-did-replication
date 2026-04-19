# TWFE Reviewer Report — Article 420

**Verdict: WARN**
**Date:** 2026-04-18
**Reviewer:** twfe-reviewer

---

## 1. Pre-trend Assessment

TWFE event-study pre-period coefficients (t=-7 to t=-2, t=-1 omitted/normalized):

| Time | Coeff | SE | t-stat |
|------|-------|----|--------|
| -7 | -2.27 | 15.10 | -0.15 |
| -6 | 4.02 | 11.26 | 0.36 |
| -5 | 1.72 | 10.96 | 0.16 |
| -4 | 4.37 | 9.99 | 0.44 |
| -3 | -9.16 | 10.26 | -0.89 |
| -2 | -9.78 | 10.48 | -0.93 |

All pre-period coefficients are statistically indistinguishable from zero. No monotone pre-trend is present. The modest negative dip at t=-2 and t=-3 (~-9 to -10 units) is within 1 SE and unsystematic. **Pre-trend check: PASS.**

Sun-Abraham pre-period (t=-7 to t=-2): -1.81, 3.00, 4.70, 8.66, -11.36, -15.68. The t=-2 SA coefficient (-15.68, SE ~9.2) is marginally significant, suggesting mild pre-trend heterogeneity across cohorts under the SA decomposition. This is a soft concern.

Gardner pre-period coefficients are essentially flat (range -9.35 to +3.63), reinforcing clean pre-trends under the imputation estimator.

## 2. Specification Fidelity

- **Paper target:** Bailey & Goodman-Bacon (2015), AER, Table 2 Panel B Column 2 (Figure 7D event study). Outcome: amr_eld (age-adjusted mortality rate per 100k, ages 50+).
- **D_ controls** (baseline characteristics × year dummies): D_pct59inclt3k_t, D_60pctnonwhit_t, D_60pctrurf_t, D_60pcturban_t, D_tot_act_md_t — these are Pattern 37 (baseline×trend) controls that generate time-varying confounders. These are correctly implemented as the paper's baseline.
- **R_ and H_ controls** (time-varying): R_tranpcret, R_tranpcpa1, H_bpc, H_hpc — correctly included.
- **Additional FEs:** urban-category×year (Durb^year, 5 bins) and state×year (stfips^year) — match the paper's Column 2/Figure 7D specification. These are high-dimensional FEs that absorb substantial variation.
- **Weight:** popwt_eld (elderly population weight) — correct.
- **Sample drops:** NYC (NY-61), LA (CA-37), Chicago (IL-31) — correctly excluded per paper's specification.
- **Treatment timing:** gvar_CS set to 0 for late CHCs (1975-1980), treated as never-treated. Correct for this paper's design.

Specification appears faithful to the paper. **Specification check: PASS.**

## 3. Treatment Indicator

treat_post = as.integer(year >= gvar_CS & gvar_CS > 0). This correctly identifies:
- Counties where CHC opened 1965-1974 (gvar_CS > 0 ensures late-CHC counties with gvar_CS=0 are excluded from treated).
- Post-treatment periods (year >= adoption year).

The 10 cohorts (1965-1974) each become a separate group in CS/SA. **Treatment indicator: PASS.**

## 4. Heterogeneous Treatment Effect Consistency

Comparing ATT estimates across estimators:

| Estimator | ATT (overall/average) | Notes |
|-----------|----------------------|-------|
| TWFE (with controls) | -53.21 (SE=14.84) | Static coefficient |
| TWFE (no controls) | -53.25 (SE=12.62) | Nearly identical |
| CS-NT (no controls) | -61.43 (SE=19.06) | Simple aggregate |
| CS-NT (Durb_f controls) | -6.78 (SE=27.69) | Severely attenuated |
| SA (average post) | ~-70 (from event study) | Broadly similar |
| Gardner (average post) | ~-68 (from event study) | Broadly similar |

TWFE, SA, and Gardner are broadly consistent in the event study trajectories (peak effects SA=-86, Gardner=-82, TWFE=-78). This suggests TWFE negative-weighting bias is not severe for this design — consistent with the Bacon decomposition showing ~84% of weight on clean "treated vs never-treated" comparisons.

**CRITICAL FLAG:** The CS-NT estimate collapses from -61 (no controls) to -6.78 (with Durb_f controls), with a massive standard error (27.7). This is a WARN-level finding: the CSDID estimator is highly sensitive to control specification. The metadata notes (Pattern 51) document this as a known identification challenge — the paper's identification relies on Durb×year and state×year FEs that CS-NT cannot absorb in its propensity-score framework.

## 5. Bacon Decomposition

The bacon.csv contains Bacon decomposition data despite run_bacon=false in metadata. Key observations:

- "Treated vs Untreated" comparisons dominate (8 observations with weights summing to ~0.84 of total). This is expected — 2948 control counties vs 114 treated.
- "Earlier vs Later Treated" and "Later vs Earlier Treated" weights are minuscule (each ~0.0001-0.0009 range), confirming negligible contamination from inter-cohort comparisons.
- The treated-vs-untreated estimates are all negative (except 1974, +40.5), ranging from -62 to -195. The 1974 cohort has a positive estimate (+40.5), which is anomalous and warrants attention — but it carries only 11.5% of total weight and may reflect the smallest/most recent cohort with limited post-treatment observations.
- Note: run_bacon=false in metadata but data exists. The metadata flag should be corrected to run_bacon=true.

**Bacon check: WARN** (1974 cohort positive treated-vs-untreated estimate, metadata inconsistency).

## 6. Overall Assessment

The TWFE specification is faithful to the paper. Pre-trends are clean. The main concern is the dramatic sensitivity of CS-NT estimates to control specification, reflecting a genuine identification challenge: the paper's credibility rests heavily on the Durb×year and state×year FEs, which modern semiparametric estimators cannot fully replicate. SA and Gardner confirm the direction of the effect. The run_bacon=false metadata flag is inconsistent with the existing bacon.csv data.

**Verdict: WARN**

Primary concern: CS-NT estimate collapses to near-zero with controls (Pattern 51), indicating that the paper's identification relies on parametric control functions that modern nonparametric estimators cannot absorb. The metadata flag run_bacon=false should be updated.
