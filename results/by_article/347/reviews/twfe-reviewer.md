# TWFE Reviewer Report — Article 347

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** twfe-reviewer

## Checklist

### 1. Specification alignment
- Paper uses `areg` with county FE + monthly time FE (`tt = (year-2001)*12 + mo + 84`) + county-specific linear trends (`fips[tt]`).
- Replication uses `fixest::feols` with `additional_fes = ["fips[tt]"]` encoding county-specific linear trends exactly.
- Treatment variable: `law_enacted` (binary, absorbing).
- Controls: 12 individual-level covariates (female, age dummies, race/ethnicity, education, pd, unem, med_inc).
- Weighted by `swt`; clustered by `fips`.
- **Result:** TWFE ATT = -0.1744, paper Table 3 = -0.174. Deviation = 0.23% (< 1%). MATCH.

### 2. TWFE magnitude and sign
- TWFE = -0.174 (SE = 0.081). Statistically significant at 5%.
- CS-NT = -0.448 (SE = 0.099); CS-NYT = -0.439 (SE = 0.100).
- **WARN: CS-DID estimates are ~2.5x larger in magnitude than TWFE.** This gap is consistent with TWFE attenuation via negative weighting or heterogeneous treatment effects across the 4 cohorts (2008, 2009, 2010, 2011).

### 3. Data structure
- **Repeated cross-section**, not a balanced panel. `data_structure == "repeated_cross_section"`.
- TWFE is appropriate for RCS with individual-level controls and aggregated FEs.
- Yearly county-level panel constructed from RCS for CS-DID (44 of 89 counties balanced).

### 4. County-specific linear trends
- The inclusion of `fips[tt]` (county × time linear trend) in TWFE is a strong parametric assumption that absorbs county-specific secular trends. This is a potential source of over-absorption: if true effects are gradual, the trend controls can attenuate or inflate estimates depending on sign.
- **WARN:** County-specific linear trends make TWFE sensitive to functional form of secular trends. This is a design-level concern shared with the original paper.

### 5. Treatment timing
- 4 cohorts: NYC 2008, Seattle+Westchester 2009, Philadelphia+Albany+Montgomery+Schenectady+Suffolk 2010, Vermont 14 counties 2011.
- TWFE pools all cohorts; the gap to CS-DID suggests heterogeneous treatment effects by cohort.

## Summary of flags
- PASS: TWFE point estimate matches paper within 0.23%.
- WARN: CS-DID 2.5x larger suggests negative-weight TWFE attenuation.
- WARN: County-specific linear trends introduce parametric sensitivity.

**Verdict: WARN** (2 concerns; no outright failure)
