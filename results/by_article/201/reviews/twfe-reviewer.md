# TWFE review: 201 — Maclean & Pabilonia (2025)

**Verdict:** WARN
**Date:** 2026-04-19 (updated for monthly CS-DID run)

## Summary

Maclean & Pabilonia (2025) study state paid sick leave (PSL) mandates and parental childcare time using ATUS RCS data (2004–2023, N=78,080 with hh_child==1). The paper's PRIMARY estimator is Gardner (did2s); TWFE appears only in Appendix Table 10 as one of five alternative estimators. Our stored TWFE = +4.609 (SE = 1.799, t = 2.56) matches the paper's Appendix Table 10 exactly (EXACT per paper-auditor). Against the updated CS-NT (now running directly on the 78k monthly RCS via panel=FALSE), the sign reversal is amplified: TWFE = +4.61 vs CS-NT = -15.27 (group aggregation), a gap of nearly 20 minutes/day. The WARN reflects two issues: (1) the estimator divergence of this magnitude warrants documentation even though it is a design finding, and (2) the 19 TWFE covariates cannot be passed to CS-NT on this RCS data via doubly-robust estimation — Spec A returns an anomalous zero (Pattern 42), so protocol-matched comparison is unavailable.

## Specification snapshot

| Field | Value | From | Status |
|---|---|---|---|
| outcome | carehh_k | metadata | OK |
| treatment | pslm_state_lag2 (2-year lag) | metadata | OK |
| unit FE | fips | metadata | OK |
| time FE | time (monthly, 239 periods) | metadata | OK |
| additional FEs | none | metadata | OK |
| cluster | fips (state) | metadata | OK |
| weights | wt06 (ATUS survey weights) | metadata | OK |
| controls (Spec C) | 19 individual/state covariates | metadata | OK |
| controls (Spec B) | none | metadata | OK |

## Checks

| # | Check | Status | Note |
|---|---|---|---|
| 1.1 | Outcome = carehh_k | PASS | Primary childcare minutes/avg day |
| 1.2 | Treatment = pslm_state_lag2 (binary) | PASS | 2-year lag; paper's construction |
| 1.3 | Unit FE = fips | PASS | 44 states |
| 1.4 | Time FE = monthly time | PASS | 239 monthly periods |
| 1.5 | Additional FEs | PASS | None declared or used |
| 1.6 | FE override | PASS | No override; standard fips + time |
| 2.1 | Cluster = fips (state level) | PASS | Matches paper's Appendix Table 10 note |
| 2.2 | Single cluster | PASS | Paper uses single-level state cluster |
| 3.1 | Weights = wt06 | PASS | ATUS survey weights; matches paper |
| 3.2 | Weight validity | PASS | Standard ATUS weight, all positive |
| 4.1 | Controls list (19 vars) | PASS | Matches Appendix Table 10 specification |
| 4.2 | Post-treatment controls | WARN | Several individual controls (female, age, mar, hh_numkids, etc.) may be mildly endogenous for long-run PSL effects; standard in ATUS literature but worth noting |
| 4.3 | Trend interactions | PASS | No time×covariate interactions in TWFE formula |
| 7 | Heterogeneity flag | PASS | Staggered design — Bacon decomp informational (not formally applicable to RCS) |
| 8 | CS-DID convergence | WARN | TWFE=+4.609 vs CS-NT=-15.27; opposite signs, 20-min gap. COVID contamination of Cohort 2020 (weight 34%, ATT=+10.12) drives positive TWFE. |

## Sample mismatch probe (Pattern 50 invariant)

| Branch | N units | N obs | sample_filter |
|---|---|---|---|
| TWFE | 44 states | 78,080 | hh_child == 1 |
| CS-DID | 44 states (fips) | 78,080 | same filter inherited; panel=FALSE, row_id__ pseudo-ID |

Status: ALIGNED — CS-DID runs on the same 78k individual-level observations. The 2026-04-19 template update removed the prior state×year pre-aggregation step; CS now runs directly on the full monthly RCS via panel=FALSE. No Pattern 50 issue.

## Paper fidelity (delegated)

Paper-auditor verdict: **EXACT** (2026-04-19). Our TWFE = 4.6086 matches Appendix Table 10 value of 4.61 to within 0.03%.

## Design findings (feeds skeptic Axis 3, not implementation WARNs)

- **Pre-trend pattern (TWFE event study):** Coefficients at t=-8 (-14.6), t=-7 (-4.3), t=-6 (-31.1), t=-5 (-34.6), t=-4 (-14.8), t=-3 (+10.8), t=-2 (-21.0). Large, irregular, imprecise (ATUS small state-year cells). No monotonic drift, but t=-5 and t=-6 are large negatives. TWFE pre-trends are noisy and not cleanly flat.
- **Post-treatment trajectory (TWFE):** t=0: -11.6, t=1: -16.6, t=2: -18.9, t=3: +1.7, t=4: -15.4, t=5: -18.1, t=6: +0.3, t=7: -9.7. All negative post-treatment (opposite to static TWFE = +4.61), suggesting the static TWFE estimate masks a complex post-treatment trajectory where the initial effect is negative while aggregate is positive due to cohort-weighting.
- **COVID contamination:** Bacon-informational Cohort 2020 (treatment activation year 2020 due to 2-year PSL lag) has ATT=+10.12 and weight=33.97% of TWFE. COVID lockdowns drove unprecedented childcare time in 2020, contaminating this cohort. CS-NT downweights via uniform group averaging, flipping the sign.
- **Spec B covariate margin:** beta_twfe_no_ctrls = +1.820 vs beta_twfe = +4.609. Controls add +2.79 min/day (+60.5%) to the TWFE point estimate. The controls are absorbing composition effects in the individual-level RCS (female, age, education, marital status of ATUS respondents shift with PSL mandate states).

## Critical issues (implementation)

None. TWFE implementation faithfully follows the paper's Appendix Table 10 specification. The sign reversal vs CS-NT is a design finding about COVID contamination and cohort-weighting, not an implementation error. Pattern 50 is satisfied (ALIGNED).

## Recommendations

- Document that the Spec A (CS with controls) returns 0/anomalous via Pattern 42 in the metadata notes (already partially documented).
- For meta-analysis: use Gardner (4.45**) as the paper's primary effect. TWFE = +4.609 is a robustness appendix value.

## Reproducible snippets

```r
# Paper's TWFE (Appendix Table 10):
# feols(carehh_k ~ pslm_state_lag2 + [19 controls] | fips + time,
#       data = df[hh_child==1], weights = ~wt06, cluster = ~fips)
# → β = 4.609 (SE = 1.799)
```
