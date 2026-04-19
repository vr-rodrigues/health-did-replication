# Skeptic report: 242 --- Moorthy, Shaloka (2025)

**Overall rating:** LOW
**Methodology score:** M-LOW (3 WARN, 0 FAIL)
**Fidelity score:** F-NA (no PDF, no original_result)
**Design credibility:** D-FRAGILE (rm_avg_Mbar = 0.25 for TWFE and CS-NT)
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (WARN), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Moorthy and Shaloka (2025) study the fracking revolution effect on county-level earnings using staggered DiD: top-quartile Rock Productivity Index counties vs never-treated counties in same shale plays. TWFE = +0.019 log-earnings (SE=0.008), p<0.05, confirmed by CS-DID (ATT=0.017). Three methodological concerns: (1) staggered 9-cohort adoption with Bacon decomposition revealing large cohort heterogeneity (early adopters 4-10x larger effect); (2) non-absorbing treatment (turns off at e~6); (3) CS-DID cannot incorporate 7 baseline-year controls used in TWFE. HonestDiD: average ATT sign-preserving only at Mbar<=0.25 (D-FRAGILE). Stored TWFE=0.0194 is a credible implementation but interpret with caution given three methodological warnings.

## Per-reviewer verdicts

### TWFE (WARN)

- beta=0.01944 (SE=0.00756); no-controls beta=0.01892, stable (2.7%), correctly specified.
- Staggered adoption (9 cohorts): TWFE may aggregate cohort-time ATTs with wrong-sign weights.
- Non-absorbing treatment (turns off at e~6): estimand is not a standard absorbing ATT.

Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)

- CS-NT ATT=0.0168 (SE=0.0081); CS-NYT=0.0167 -- confirms TWFE direction.
- With-controls CS-DID fails (variable scoping error): only uncontrolled estimates available.
- Post-treatment dynamics concentrated at t=3-5; near zero at t=0,1,2.

Full report: reviews/csdid-reviewer.md

### Bacon (WARN)

- Treated vs Untreated comparisons dominate (~92% weight): healthy structure.
- Large cohort heterogeneity: 2007 cohort +0.200; 2008 (weight 0.340) -0.008; 2010/2012 negative.
- Non-absorbing treatment technically invalidates standard Bacon interpretation.

Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS)

- Pre-trends clean: max deviation 0.008 log-points over 5 pre-periods for TWFE and CS-NT.
- At Mbar=0, average ATT CIs fully positive: TWFE [0.0085, 0.041], CS-NT [0.0033, 0.033].
- Design credibility: D-FRAGILE -- rm_avg_Mbar=0.25. Implementation correct and complete.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing-binary-staggered within max_e=5 window. CS-DID provides robust alternative.

Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE)

- No PDF at pdf/242.pdf; original_result empty. Fidelity axis not evaluable.

Full report: reviews/paper-auditor.md

## Material findings (sorted by severity)

1. WARN [TWFE/BACON]: Cohort effect heterogeneity -- 2005/2007 cohorts show 4-10x larger effects than 2008-2012 cohorts; TWFE masks this heterogeneity.
2. WARN [TWFE]: Non-absorbing treatment -- ddtquartile1 can switch off at e~6; estimand is not a clean ATT.
3. WARN [CSDID]: Missing controls -- 7 baseline-year controls unavailable in att_gt; with-controls estimation failed entirely.
4. WARN [DESIGN]: D-FRAGILE -- average ATT sign-preserving only at Mbar<=0.25; modest pre-trend violations dissolve the effect.
5. INFO [SA/GARDNER]: Anomalous event study -- SA and Gardner show negative post-treatment at t=0-3 and large positive at t=4-5, inconsistent with TWFE/CS-NT monotonic ramp-up.

## Recommended actions

- Repo-custodian: Investigate SA/Gardner anomaly -- check whether shale_play x year FEs interact incorrectly with Sun-Abraham cohort interaction terms in feols.
- Repo-custodian: Resolve CS-with-controls scoping failure for medianhhinc1990; pre-construct interaction columns as explicit dataframe variables.
- Repo-custodian: Add original_result.beta and original_result.se to metadata.json to enable fidelity audit axis.
- Pattern curator: Document non-absorbing treatment with bounded event-study window as a canonical pattern (extend Pattern 37).
- User: Assess whether cohort-specific ATTs should be the primary reported quantity given large dispersion across cohorts revealed by Bacon.
- User: Assess whether shale_play x year FEs are sufficient to ensure parallel counterfactual trends given D-FRAGILE sensitivity at Mbar=0.25.

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
