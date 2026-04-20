# Skeptic report: 437 -- Hausman (2014)

**Overall rating:** HIGH *(Fidelity x Implementation -- 3-axis rubric, 2026-04-19)*
**Design credibility:** D-BROKEN *(Axis 3 -- finding about paper design, not our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (impl=N/A, TvT=49.5%), honestdid (impl=PASS, rm_first=0, rm_avg=0, rm_peak=0 both estimators), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT 0.58%)

## Executive summary

Hausman (2014) studies nuclear plant divestiture (1999-2007) and collective radiation exposure (personrem) via OLS TWFE on a facility-year panel (N=1,749; 63 facilities; 1974-2008). Our reanalysis reproduces the headline TWFE coefficient exactly (stored -42.245 vs paper -42.2, 0.58% gap; SE 66.098 vs paper 66-67). Implementation is correct on all axes: fractional treatment in the divestiture year matches the paper Stata collapse exactly; FEs, clustering, and sample filter all match. Rating is HIGH (F-HIGH x I-HIGH). The reanalysis surfaces severe design evidence (Axis 3): HonestDiD shows rm_Mbar=0 at all three targets for TWFE and CS-NT -- the Mbar=0 CI already includes zero, so the result is not robust to any pre-trend violation. Bacon shows 49.5% of TWFE weight from forbidden treated-vs-treated comparisons with implausible estimates (-352 to -682 person-rem). CS-DID produces a 20x magnitude collapse (-42.2 to -1.9 person-rem), driven by a 34-year secular decline (1,200 to 135 person-rem), 3 singleton cohorts, and 14/63 facilities spanning the full panel. All estimates are statistically insignificant (SE approx 22-66). Paper headline findings are Poisson/NB regressions; OLS personrem is a secondary specification. The stored -42.245 faithfully reproduces a noisy, design-broken secondary result.

## Per-reviewer verdicts

### TWFE (WARN -- all WARNs reclassified as Axis 3 design findings)
- beta_twfe = -42.245 reproduced to numerical identity (0.00%). FEs, cluster at facility_num, sample filter all match Stata do-file line 971. Implementation: PASS.
- Fractional divested in divestiture year (18 obs) matches Stata collapsed data exactly. Asymmetry with CS-DID is Axis 3, not an implementation error.
- 34-year secular decline plus 25-year pre-treatment window: Axis 3 design finding.
- Full report: reviews/twfe-reviewer.md

### CS-DID (WARN -- all WARNs reclassified as Axis 3 design findings)
- CS-NT = -1.943 (SE 22.3); CS-NYT = -3.724 (SE 20.2). Both run correctly, no controls, matching metadata. Implementation: PASS.
- 20x magnitude collapse (TWFE -42.2 to CS-NT -1.9) is the central design finding. Direction preserved (both negative).
- 3 singleton cohorts, unbalanced panel (14/63 facilities), oscillating pre-trends: Axis 3 signals, not implementation errors.
- Full report: reviews/csdid-reviewer.md

### Bacon (WARN -- all WARNs are Axis 3 design findings; reviewer ran despite allow_unbalanced=true)
- TVT share = 49.5% (at the D-BROKEN boundary).
- EvL pair estimates: -352 to -682 person-rem (secular trend contamination of early-as-pseudo-control comparisons).
- TVU cohort estimates span -372 to +301 person-rem (extreme heterogeneity masked under one TWFE weight).
- Full report: reviews/bacon-reviewer.md

### HonestDiD (WARN -- all WARNs are Axis 3 design findings)
- rm_first_Mbar = 0, rm_avg_Mbar = 0, rm_peak_Mbar = 0 for TWFE and CS-NT. Mbar=0 CI includes zero for all three targets.
- CIs expand rapidly (TWFE avg at Mbar=2: +/-396; CS-NT avg at Mbar=2: +/-948 person-rem).
- n_pre=2 is a structural panel constraint, not an implementation error.
- Design verdict: D-BROKEN (rm_Mbar=0 at first-post AND peak for both estimators).
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Absorbing-binary-staggered design; no treatment reversal. DC-DH adds no information beyond CS-DID.
- Full report: reviews/dechaisemartin-reviewer.md

## Three-way controls decomposition

N/A -- paper has no covariates (twfe_controls = [], cs_controls = []). All specs (A, B, C) are identical. No covariate margin estimable.

## Axis 3 design-credibility summary

| Signal | Value | Threshold | Reading |
|---|---|---|---|
| HonestDiD rm_first_Mbar (TWFE) | 0 | >0 to avoid D-BROKEN | D-BROKEN |
| HonestDiD rm_peak_Mbar (TWFE) | 0 | >0 to avoid D-BROKEN | D-BROKEN |
| HonestDiD rm_first_Mbar (CS-NT) | 0 | >0 to avoid D-BROKEN | D-BROKEN |
| HonestDiD rm_peak_Mbar (CS-NT) | 0 | >0 to avoid D-BROKEN | D-BROKEN |
| Bacon TVT share | 49.5% | <30% for D-ROBUST | D-BROKEN boundary |
| TVU cohort range | -372 to +301 person-rem | Narrow | Extreme heterogeneity |
| Pre-trends | Oscillating +/-13 to +/-23 person-rem | Flat | Inconsistent |
| TWFE/CS-NT gap | 20x magnitude | <2x | D-BROKEN |

Design credibility upgraded from D-FRAGILE (prior row) to D-BROKEN: rm_Mbar=0 at both first-post AND peak for both estimators. Axis 3 only; does not affect HIGH rating.

## Material findings (sorted by severity)

- [Design -- D-BROKEN] HonestDiD rm_Mbar=0 all targets both estimators. Mbar=0 CI includes zero; no robustness to any pre-trend violation. Strongest design-broken signal in sample alongside Greenstone & Hanna (147).
- [Design] Bacon TVT = 49.5%; EvL estimates -352 to -682 person-rem driven by secular trend.
- [Design] 20x magnitude collapse TWFE to CS-NT; CS-NT (-1.9, SE 22.3) is noise around zero.
- [Design] 3/9 singleton cohorts (2003, 2004, 2006) with extreme leverage on pooled CS-DID ATT.
- [Design] 14/63 facilities span full 1974-2008 panel; universal base period creates composition effects.
- [Note] Paper headline is Poisson/NB count regressions; OLS personrem (Table 3, Panel A, Col 4) is secondary.
- [Note] Metadata table_reference (Table 6, Column 1) is a coding error; correct is Table 3, Panel A, Col 4.

## Recommended actions

- Metadata fix: update original_result.table_reference to Table 3, Panel A, Column 4. No re-run needed.
- Aggregate analysis: confirm article 437 excluded from aggregate CS-DID vs TWFE table (metadata note already flags this).
- Pattern curator: confirm Pattern 46 names article 437 as the canonical D-BROKEN secular-trend exemplar (TVT 49.5% + rm_Mbar=0 all targets).
- No pipeline action needed: rating is HIGH; all reviewer WARNs are Axis 3 design findings under the 3-axis rubric.

## Rating rationale (3-axis)

| Axis | Score | Evidence |
|---|---|---|
| Fidelity (Axis 1) | F-HIGH | EXACT: -42.245 vs paper -42.2 (0.58%); SE within tolerance |
| Implementation (Axis 2) | I-HIGH | 0 true implementation WARNs; fractional divested matches Stata; FEs, cluster, sample correct |
| Design credibility (Axis 3) | D-BROKEN | rm_Mbar=0 first+peak both estimators; TVT 49.5%; 20x TWFE/CS gap; all ns |

F-HIGH x I-HIGH = HIGH. D-BROKEN is Axis 3 -- a finding about the paper design, not a demerit against our reanalysis.

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
