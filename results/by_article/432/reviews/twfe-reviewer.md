# TWFE Reviewer Report — Article 432 (Gallagher 2014)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. Specification fidelity
- FEs: community FE (id_num) + state×year FE (st_fips^year2, 864 categories). Matches paper's equation (1): areg with absorb(id_num) and state×year dummies.
- Outcome: ln_takeup_proxy1 = log(flood insurance policies per capita + 1). Correct per metadata Rule (i) declared preference.
- Cluster: state (st_fips, 48 states). Matches paper.
- No time-varying controls. Matches paper ("no controls" specification).
- Treatment variable: post_hit = 1{year2 >= hit1year}. Correctly constructed via preprocessing.
- Sample: panel9007==1, balanced panel 195,138 obs (10,841 communities × 18 years 1990–2007).

### 2. Point estimate plausibility
- beta_twfe = 0.1095 (SE = 0.0163, t = 6.72). Highly significant.
- Paper's Figure 2 event study shows t=0 coefficient ~0.09, consistent with static ATT of 0.11 (post_hit integrates over all post-treatment periods, slightly above contemporaneous effect).
- IDIOSYNCRASY NOTE: Paper uses repeated-event hityear_* dummies for Figure 2 (t=0 match: 0.090 ≈ paper); we use post_hit for the static ATT. This is the correct approach for a staggered DiD static estimate — documented in metadata.

### 3. Pre-trend assessment (TWFE event study)
10 pre-periods available. Pre-trend t-statistics:
- t=−11: −0.020/0.029 = −0.70 (ns)
- t=−10: −0.015/0.023 = −0.63 (ns)
- t=−9:  −0.040/0.038 = −1.05 (ns)
- t=−8:  −0.027/0.037 = −0.74 (ns)
- t=−7:  −0.021/0.018 = −1.13 (ns)
- t=−6:  +0.001/0.014 = +0.05 (ns)
- t=−5:  +0.001/0.012 = +0.10 (ns)
- t=−4:  −0.000/0.012 = −0.01 (ns)
- t=−3:  −0.008/0.008 = −1.02 (ns)
- t=−2:  +0.004/0.006 = +0.61 (ns)

**Zero significant pre-trends at 5% level.** Max |t-stat| = 1.13. Parallel trends assumption passes scrutiny.

### 4. Post-treatment stability
Post-treatment coefficients (t=0 through t=11): 0.090, 0.113, 0.106, 0.102, 0.116, 0.113, 0.115, 0.110, 0.124, 0.099, 0.094, 0.099. Range: 0.090–0.124. Stable plateau with no systematic growth or decay. No evidence of treatment effect heterogeneity contaminating the static ATT.

### 5. Repeated-event idiosyncrasy
The paper's event study uses hityear_* variables relative to ALL PDD floods (not just first hit). The static TWFE here uses post_hit relative to first hit. The contemporaneous coefficient (t=0) from the first-hit TWFE ES is 0.090 (exact Figure 2 match per metadata). The late-horizon gap (t=10: first-hit=0.094 vs paper-repeated=0.024) is a known feature documented in metadata notes and the es432_script.R — not an implementation error.

### 6. FE collinearity / absorption
state×year FE (864 categories) nested within community FE in fixest's multi-way FE absorption. Standard fixest handling. No absorption conflict.

## Summary
TWFE implementation is correct. Clean pre-trends over 10 periods. Stable post-treatment plateau. Highly significant ATT = 0.110 (t = 6.72). The repeated-event idiosyncrasy is documented and understood.

**Verdict: PASS**
