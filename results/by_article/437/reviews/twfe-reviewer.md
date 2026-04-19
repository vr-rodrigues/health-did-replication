# TWFE Reviewer Report — Article 437 (Hausman 2014)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Replication fidelity
- Stored beta_twfe = -42.2450, SE = 66.0979.
- Paper (Table 6, Column 1) reports beta = -42.245, SE = 66.098.
- Difference: 0.00% (numerical identity). Stata do-file line 971 (`reg personrem divested R* Y*`) reproduced exactly via feols with unit + year FEs, cluster(facility_num).
- PASS on fidelity.

### 2. Treatment variable construction
- Raw data is a reactor x month panel (36,667 obs). Collapsed to facility x year (1,749 obs).
- After collapsing, `divested` is fractional in the divestiture year (mean of binary monthly variable across months). 18 facility-year observations have 0 < divested < 1.
- This fractional treatment is an artefact of the collapse — the paper's Stata code uses the same collapsed mean, so the TWFE matches exactly. However, a fractional continuous-ish treatment in the divestiture year creates a misspecification: TWFE treats partial-year divestiture as a fractional "dose", whereas CS-DID treats the first year post-gvar as fully treated.
- WARN: fractional treatment in transition year creates a structural asymmetry between TWFE and CS-DID estimators.

### 3. Fixed effects specification
- Facility FEs + Year FEs. No controls (twfe_controls = []). This matches the paper specification.
- PASS.

### 4. Clustering
- Clustered at facility_num level (63 clusters). Matches paper (cluster(plantid)).
- PASS.

### 5. Sample
- Sample filter: `!is.na(personrem)`. 1,749 facility-year observations after collapse.
- PASS.

### 6. Secular trend concern (WARN)
- personrem shows a massive secular decline from ~1,200 person-rem (1974) to ~135 person-rem (2008) — approximately a 10-fold reduction over 34 years. This is driven by regulatory tightening, technological improvements, and changing work practices, all independent of divestiture.
- With only year FEs (common trend), TWFE absorbs this trend adequately *if* the parallel trends assumption holds. However, the long pre-treatment window (25+ years before the earliest divestiture cohort in 1999) and the massive secular decline create severe risk that TWFE is capturing composition effects rather than a causal divestiture effect.
- The coefficient (-42.2) is not statistically significant (t = -0.64), suggesting the estimate is very noisy.
- WARN: secular trend over 34 years combined with 25-year pre-treatment window creates substantial composition risk for TWFE.

### 7. Negative-weight concern
- Staggered treatment with 9 cohorts (1999–2007). TWFE mechanically uses late-treated as controls for early-treated. The massive secular decline means late-treated facilities have lower baseline personrem than early-treated — this creates the conditions for Bacon-type contamination.
- WARN: staggered TWFE negative-weight contamination is present (see Bacon reviewer).

## Material concerns
1. WARN: fractional treatment in divestiture year creates asymmetry vs. CS-DID
2. WARN: 34-year secular decline + 25-year pre-treatment window risk composition bias
3. WARN: staggered design negative-weight contamination

## Summary
TWFE coefficient reproduced exactly (-42.245). However, three methodological concerns earn a WARN verdict: fractional treatment variable in transition year, massive secular decline undermining parallel trends over the long panel, and staggered negative-weight contamination. The estimate is not statistically significant (SE > magnitude).
