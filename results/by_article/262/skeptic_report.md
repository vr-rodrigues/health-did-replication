# Skeptic report: 262 -- Anderson, Charles, Rees (2020)

**Overall rating:** MODERATE  *(Fidelity x Implementation: F-NA x I-MOD -> use implementation alone -> MODERATE)*
**Design credibility:** D-FRAGILE  *(separate axis -- finding about the paper, not our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS; design-WARNs->Axis3), csdid (impl=WARN: Spec A collapse 0/NA), bacon (impl=WARN: metadata flag mismatch; TvT=11.4%->Axis3), honestdid (impl=PASS; M_first~0.25, M_avg=0->D-FRAGILE Axis3), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Anderson, Charles, Rees (2020) studies hospital desegregation -- operationalized through Medicare certification -- on Black postneonatal mortality in the Deep South, staggered DiD across 7 cohorts (1967-1973). Headline TWFE: beta=1.221 (SE=0.888, p~0.17, not significant). CS-NT: 0.995 (SE=0.404, t=2.46, significant at 5%). Fidelity cannot be evaluated (no PDF, no original_result). Implementation is mostly clean with one Axis-2 concern: Spec A CS-NT returns 0/NA (likely Pattern 42 propensity separation with 3 direct-level controls). Design-credibility axis: HonestDiD shows CS-NT robust at M=0 but breaks at M~0.25; Bacon reveals large heterogeneity by cohort timing (TvU avg 9.15 vs timing-group avg 2.5), though TvU share is only 11.4%. CS-NT stored value (0.995, SE 0.404) is the best available estimate; the TWFE headline is non-significant and contaminated by 85%-cohort imbalance.

---
## Per-reviewer verdicts

### TWFE (impl=PASS; design WARNs -> Axis 3)

- Specification matches original Stata code exactly: county FE, year FE, three time-varying controls, birth-weighted, clustered by county, Black subsample with balanced panel restriction. Implementation is clean.
- TWFE pre-trends are flat (all pre-period |t| < 0.55) but measured imprecisely (SE approx 1.5-2.0); low bar for a null pre-trend test -- design finding, Axis 3.
- Staggered adoption with 85% of treated units in 1967: TWFE uses dominant early cohort as implicit control for all later cohorts. Forbidden-comparison contamination inflates SEs relative to CS-NT (0.888 vs 0.404) -- design finding, Axis 3.

Full report: reviews/twfe-reviewer.md

### CS-DID (impl=WARN: Spec A 0/NA)

- CS-NT simple ATT = 0.995 (SE 0.404, t=2.46) is statistically significant at 5%; CS-NYT (1.270, SE 2.222) is not, because not-yet-treated pools are near-empty for 1970-1973 cohorts (<1% each) -- design finding, Axis 3.
- Axis-2 concern: att_cs_nt_with_ctrls=0, SE=NA -- Spec A silent convergence failure. With 3 direct-level time-varying controls and extremely imbalanced cohort structure, consistent with Pattern 42 (propensity score separation in doubly-robust estimator). cs_nyt_with_ctrls runs successfully (2.452, SE 2.705, status=OK).
- CS-NYT severely underpowered (SE 5x CS-NT) due to cohort structure -- design finding, Axis 3.

Full report: reviews/csdid-reviewer.md

### Bacon (impl=WARN: metadata flag mismatch; TvT diagnostics -> Axis 3)

- Axis-2 concern: run_bacon=false in metadata despite bacon.csv existing and being valid. Minor metadata inconsistency.
- TvT timing-group weight = 88.6% (EarlierVsLater 59.5% + LaterVsEarlier 29.1%); TvU = 11.4%. TvU < 30% is a D-ROBUST signal, but large timing-group weight exposes TWFE to heterogeneity contamination -- Axis 3 design finding.
- TvU weighted avg = 9.15 vs timing-group avg approx 2.5: substantial heterogeneity by cohort timing. Cohort 1969 shows negative estimates in some pairs (vs 1967: -1.33; vs 1968: -8.46) with small weights -- Axis 3 design finding.

Full report: reviews/bacon-reviewer.md

### HonestDiD (impl=PASS; M thresholds -> Axis 3 D-FRAGILE)

- CS-NT is robust at M=0: first-post lb=0.32, ub=3.97; avg lb=0.30, ub=1.99; peak lb=1.03, ub=4.39. All three targets exclude zero.
- CS-NT breaks at M approx 0.25 for first-post and avg targets -- M in [0.1, 0.5] -> D-FRAGILE design signal.
- TWFE not robust even at M=0 (first-post lb=-0.80) -- reflects imprecision (large SEs), not pre-trend evidence.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design; CDH estimator adds no information beyond CS-DID.

Full report: reviews/dechaisemartin-reviewer.md

---
## Three-axis rating

| Axis | Score | Basis |
|---|---|---|
| Axis 1 -- Fidelity | F-NA | PDF absent; original_result={}; paper-auditor NOT_APPLICABLE |
| Axis 2 -- Implementation | I-MOD | 1 impl WARN (Spec A CS-NT=0/NA, Pattern 42 candidate) + 1 metadata WARN (run_bacon flag mismatch); no FAIL |
| Axis 3 -- Design credibility | D-FRAGILE | M_avg=0 breaks at 0.25; TvU avg 9.15 vs timing avg 2.5; pre-trends flat but imprecise |

**Final rating: MODERATE** (F-NA x I-MOD -> use implementation alone -> MODERATE)

---

## Three-way controls decomposition

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | 1.221 (SE 0.888) | 0 (SE NA) | FAIL -- Spec A CS-NT convergence failure (Pattern 42 candidate) |
| (B) both without controls | 1.206 (SE 0.892) | not available as standalone aggregate | -- |
| (C) TWFE with, CS without (headline) | 1.221 (SE 0.888) | 0.995 (SE 0.404) | current default |

Key ratios:
- Total gap (Spec C headline): (1.221 - 0.995) / 1.221 = +18.5% (TWFE larger; imprecision-driven)
- Covariate margin (TWFE side): (1.221 - 1.206) / 1.221 = +1.2% (controls add negligible information)
- Spec A status: FAIL (CS-NT+controls returns 0/NA). Matched-protocol estimator margin cannot be computed.

Verbal interpretation: The 18.5% TWFE vs CS-NT gap (Spec C) is driven almost entirely by the estimator choice, not covariates (TWFE covariate margin = 1.2%). Spec A collapse prevents confirmation via matched protocol; the gap is consistent with forbidden-comparison variance inflation in TWFE rather than control-variable confounding.

---

## Material findings (sorted by severity)

Implementation concerns (Axis 2):

1. [WARN -- CS-DID, Axis 2] Spec A CS-NT (att_cs_nt_with_ctrls) returns 0/NA. Likely Pattern 42: 3 direct-level time-varying controls plus extreme cohort imbalance (85% in 1967) cause propensity score separation in the doubly-robust estimator. Spec A CS-NYT runs successfully (2.452, status=OK). Requires investigation and re-run.

2. [WARN -- Bacon, Axis 2] Metadata inconsistency: run_bacon=false but bacon.csv exists and is valid. Decomposition should be formally enabled or documented as supplementary.

Design findings (Axis 3 -- informational, do not affect rating):

3. [Design finding] HonestDiD: CS-NT robust at M=0 but breaks at M approx 0.25. Robustness is real but narrow. Flat pre-trends (max |t|=1.02) make M=0.25 a plausible upper bound.

4. [Design finding] Bacon: TvU avg 9.15 vs timing-group avg approx 2.5. Large heterogeneity between clean and contaminated comparisons. TWFE aggregate dominated by timing-group comparisons (88.6% weight).

5. [Design finding] Cohort imbalance (1967=85% treated units) makes TWFE and CS aggregation sensitive to a single cohort. CS-NYT severely underpowered for late cohorts.

---

## Recommended actions

- For the repo-custodian: Investigate att_cs_nt_with_ctrls=0/NA. Re-run Spec A CS-NT and check R template logs for Pattern 42 propensity separation. Update results.csv if corrected.

- For the repo-custodian: Populate original_result in data/metadata/262.json with the paper reported TWFE coefficient, SE, and table/column reference once the PDF is located. This will enable a full fidelity audit and potentially upgrade F-NA to F-HIGH.

- For the repo-custodian: Reconcile run_bacon flag -- either set run_bacon=true (decomposition ran successfully) or document bacon.csv as supplementary.

- For the user (methodological judgement): The most defensible headline estimate is CS-NT (0.995, SE 0.404, t=2.46, significant at 5%), not the TWFE (1.221, SE 0.888, p approx 0.17). HonestDiD supports moderate confidence (robust at M=0, breaks at M approx 0.25). Communicate both estimates to readers.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
