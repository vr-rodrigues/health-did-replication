# Skeptic report: 359 -- Anderson, Charles, Olivares, Rees (2019)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (FAIL), bacon (WARN), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Anderson, Charles, Olivares, Rees (2019) estimate the effect of mandatory TB case-reporting requirements on tuberculosis lung mortality using a staggered DiD design across 548 US cities from 1900-1917. The headline TWFE result from Table 3B col 1 is beta = -0.036 (SE = 0.035), statistically insignificant. Our replication reproduces this estimate almost exactly (-0.036, SE = 0.033). The stored consolidated result should be interpreted with caution for three reasons: (1) CS-DID reverses sign -- both NT and NYT variants produce positive ATTs (+0.018); (2) HonestDiD shows no robustness even at Mbar=0, with CIs spanning [-0.080, +0.009]; (3) Bacon decomposition reveals extreme cohort-specific heterogeneity (range -0.659 to +0.378). The Gardner/BJS event study is directionally consistent with TWFE (negative and growing post-treatment), partially contradicting the CS sign reversal -- the divergence appears driven by cohort-group weighting. Overall there is no robust evidence that anti-TB reporting mandates reduced TB mortality in this historical sample.

---

## Per-reviewer verdicts

### TWFE (WARN)
- Point estimate (-0.036) reproduces exactly; SE within 5% of paper (0.033 vs 0.035). Full specification confirmed including city-specific linear trends and population weights.
- Pre-period TWFE event study coefficients are uniformly positive and rising (t=-3: +0.040), suggesting violation of parallel trends.
- Bacon decomposition confirms extreme heterogeneity (Treated vs Untreated range: -0.354 to +0.285).
- Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (FAIL)
- Sign reversal: CS-NT ATT = +0.018 (SE=0.101), CS-NYT ATT = +0.018 (SE=0.104) -- both positive where TWFE is negative.
- Controls-augmented CS-DID returned degenerate results (point estimate = 0, SE = NA).
- CS pre-trends are flat (max coef = 0.022 at t=-5), suggesting TWFE pre-trend is artifact of staggered aggregation.
- Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (WARN)
- Extreme cohort-specific heterogeneity: Treated vs Untreated range -0.354 to +0.285; Later vs Always Treated range -0.415 to +0.229.
- Identification weight dominated by Treated vs Untreated comparisons (favorable), but heterogeneity makes TWFE aggregate hard to interpret.
- Decomposition approximate due to repeated cross-section structure (not balanced panel).
- Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- TWFE not robust at any Mbar: Mbar=0 CI = [-0.080, +0.009] includes zero; avg post-treatment CI = [-0.085, +0.037].
- CS-NT first-period CI at Mbar=0 = [-0.117, +0.003] marginally negative but fails at Mbar=0.25.
- Pre-trend magnitudes (up to 0.040 at t=-3) comparable to treatment effect (-0.035).
- Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design; CS-DID already covers this case.
- Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- PDF pdf/359.pdf not found; independent fidelity verification not possible.
- Metadata comparison: point estimate matches to 3 decimal places; SE within 5%.
- Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

---

## Material findings (sorted by severity)

**FAIL:**
- CS-DID sign reversal: NT and NYT both yield +0.018 versus TWFE -0.036. Direction of policy conclusion not robust to estimator choice.
- CS-DID controls version degenerate (0/NA): incompatibility between repeated cross-section and CS-DID covariate conditioning.

**WARN:**
- HonestDiD: CI = [-0.080, +0.009] at Mbar=0; effect fragile under any pre-trend extrapolation.
- Positive pre-trend in TWFE event study (t=-3: +0.040) casts doubt on parallel trends assumption.
- Bacon: 2x2 DiD range exceeds 0.9 log-points; TWFE averages fundamentally different cohort effects.
- Repeated cross-section structure (53% fill rate) makes decompositions approximate.

---

## Recommended actions

- For the repo custodian: att_cs_nt_with_ctrls and att_cs_nyt_with_ctrls return 0/NA. Investigate whether repeated cross-section requires modified CS-DID call (e.g., panel=FALSE in att_gt()).
- For the user (methodological judgement): Gardner/BJS consistency with TWFE suggests cohort-group weighting -- not negative weights -- drives the CS reversal. Consider whether Gardner is more appropriate for this historical repeated cross-section setting.
- For the user: Headline result is not statistically significant. No robust evidence of TB reduction. Treat stored TWFE estimate as lower bound of a range including zero and positive values.
- For the pattern curator: Add pattern for CS-DID sign reversal with Gardner consistency (cohort-group weighting as mechanism rather than negative weights).
- For the pattern curator: Document controls failure in repeated cross-section + CS-DID (att_cs_*_with_ctrls = 0/NA when data_structure = repeated_cross_section).

---

## Individual reports

- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
