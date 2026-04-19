# Skeptic report: 241 — Soliman (2025)

**Overall rating:** HIGH *(built from Fidelity x Implementation)*
**Design credibility:** MODERATE *(separate axis — a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (impl=PASS, TvT share=1.3%), honestdid (NOT_APPLICABLE — only 2 pre-periods), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT, 0.01% gap)

## Executive summary

Soliman (2025) studies the effect of DEA crackdowns on pill mills in the opioid crisis, using a staggered county-year panel (3,006 counties; 95 treated across 8 cohorts 2007–2014; 2,911 never-treated). The headline result from Table 1 Col 1 is a TWFE estimate of -31.52 MME per capita. After the 2026-04-19 fix applying the paper's rel_year ∈ [-3, 3] sample filter to the TWFE run (with CS-DID intentionally exempted to avoid a `did` package segfault), our stored TWFE = -31.5232 reproduces the paper's published number to within 0.01% — an EXACT match. The CS-NT dynamic ATT (-40.96) is 30% larger in magnitude than TWFE, consistent with Lesson 8 (TWFE attenuation when treatment effects grow with event time): TWFE assigns negative implicit weights to later cohort-periods, suppressing the growing effect. Bacon decomposition confirms that 98.7% of TWFE weight comes from clean treated-vs-never-treated comparisons, so contamination from forbidden 2x2 comparisons is negligible. Pre-trends are flat across all estimators. The HonestDiD gate was not met (only 2 pre-periods), but informational M̄ values are D-MODERATE (CS-NT average effect robust to M̄ ≈ 1.0). The stored consolidated_results value (-31.52 for the TWFE headline) is trustworthy and faithfully reproduces the paper; users should also note the CS-NT dynamic ATT (-40.96) as the preferred modern estimate for this staggered design.

## Per-reviewer verdicts

### TWFE (PASS)
- Sample filter fix applied 2026-04-19: `sample_filter = "(rel_year >= -3 & rel_year <= 3) | gvar_CS == 0"` now in metadata. TWFE = -31.5232 matches paper to 0.01%. Previous WARN (unfiltered -33.65) is resolved.
- FE structure (county + state*year) and clustering (county_fips) are correct throughout.
- Pre-trends flat: t=-3: +2.23 (SE=6.03), t=-2: +0.64 (SE=3.95). No evidence of parallel-trends violation.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- CS-DID runs on full 9-year panel (`cs_sample_filter = ""`); cs_min_e=-3/cs_max_e=3 clip dynamic aggregation to the paper's event window. Correct implementation.
- NT dynamic ATT = -40.96 (SE=6.65); NYT dynamic = -41.06 (SE=7.48). Both 30% larger magnitude than TWFE — canonical Lesson 8 attenuation finding.
- Pre-trends flat for both NT and NYT variants. Comparison group is deep (2,911 never-treated).
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (PASS)
- TvT (forbidden comparisons) share = 1.3% — well below the 30% concern threshold. TWFE is overwhelmingly driven by clean treated-vs-never-treated comparisons.
- 2012 cohort heterogeneity: estimate = +3.19 MME/capita with 16.4% weight. Directionally opposite to all other cohorts; TWFE masks this heterogeneity. Design finding, not an implementation flaw.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (NOT_APPLICABLE)
- Only 2 pre-periods (t=-3 and t=-2); applicability gate requires ≥ 3. Formal review not conducted.
- Informational M̄ values from honest_did_v3.csv: CS-NT M̄_first=0.75, M̄_avg=1.00, M̄_peak=0.75. D-MODERATE range. Average effect robust to M̄ ≈ 1.0.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Binary absorbing treatment. CS-DID and Bacon are the appropriate tools. No additional information from DIDmultiplegtDYN.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

## Three-way controls decomposition

N/A — paper has no original covariates (`twfe_controls: []`, `cs_controls: []`); unconditional comparison only. Spec A (with controls) is not applicable; results.csv records `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"`. The headline corresponds to Spec B (both without controls), which is the only applicable protocol.

## Material findings (sorted by severity)

- (Design finding — not a demerit) CS-NT dynamic ATT (-40.96) is 30% larger in magnitude than TWFE (-31.52). Consistent with Lesson 8: TWFE attenuates growing treatment effects through negative implicit weights on later cohort-period cells. CS-DID is the preferred estimator for this staggered design.
- (Design finding — not a demerit) 2012 adoption cohort shows a positive Bacon estimate (+3.19 MME/capita, weight 16.4%), opposite in sign to all other cohorts. TWFE masks this heterogeneity; cohort-specific CS-DID ATTs are needed to unpack it.
- (Design finding — informational) HonestDiD gate not formally met (only 2 pre-periods). Available M̄ values suggest D-MODERATE robustness: CS-NT average effect survives parallel-trends violations up to M̄ ≈ 1.0, but first-period effect breaks at M̄ ≈ 0.75.
- (Implementation — resolved) Prior WARN (2026-04-18) from sample-filter mismatch (TWFE stored as -33.65 on unfiltered panel) is now resolved. No outstanding implementation concerns.

## Recommended actions

- No action needed on the stored TWFE headline (-31.52). Implementation is clean and the paper's number is exactly reproduced.
- For dissertation/working paper: present CS-NT dynamic ATT (-40.96) alongside TWFE (-31.52) and note the 30% gap as a Lesson 8 attenuation finding. Recommend Table 1 entry report both values and flag the growing-effect mechanism.
- For the event-study figure: all four estimators (TWFE, CS-NT, CS-NYT, SA, Gardner) show similar pre-trend flatness and diverging post-treatment paths — use this to illustrate TWFE attenuation visually.
- The 2012 cohort outlier (+3.19, 16.4% weight) warrants a footnote: the aggregate TWFE (-31.52) is pulled toward zero by this cohort, and CS-DID's cohort-specific ATTs can reveal whether this cohort-specific null/positive effect reflects a genuine policy difference or data artifact.
- No pattern-curator action needed (Pattern 50 / sample-mismatch patterns already documented; the cs_sample_filter="" solution is the known resolution).

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
