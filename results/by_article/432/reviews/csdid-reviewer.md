# CS-DID Reviewer Report — Article 432 (Gallagher 2014)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. CS-DID specification
- gvar_CS constructed as: `ifelse(!is.na(hit1year), as.numeric(hit1year), 0)` — never-treated coded as 0 (correct Pattern 43).
- base_period = 'universal' (correct Pattern 26 for staggered designs with long pre-period windows).
- No controls (cs_controls = []) — consistent with paper's no-controls specification and TWFE.
- Panel balanced: allow_unbalanced = false, panel9007==1 filter applied.
- 18 cohorts (gvar 1990–2007) + never-treated pool (N=3,927 communities).

### 2. ATT convergence
- CS-NT ATT = 0.1215 (SE = 0.0150), +10.9% above TWFE (0.1095).
- CS-NYT ATT = 0.1155 (SE = 0.0174), +5.4% above TWFE.
- NT > NYT by 5.2%: modest gap consistent with not-yet-treated comparison providing a slightly more stringent control group.
- Direction unanimous across TWFE/CS-NT/CS-NYT/SA/Gardner. No sign reversal.
- The CS-DID ATT exceeds TWFE, as expected: TWFE in staggered designs can be attenuated by forbidden comparisons that use already-treated units as controls. CS-DID corrects this.

### 3. Pre-trend assessment (CS-NT event study)
10 pre-periods. CS-NT pre-trend t-statistics:
- t=−11: −0.056/0.048 = −1.18 (ns)
- t=−10: −0.042/0.044 = −0.96 (ns)
- t=−9:  −0.068/0.054 = −1.26 (ns)
- t=−8:  −0.042/0.054 = −0.78 (ns)
- t=−7:  −0.037/0.034 = −1.09 (ns)
- t=−6:  −0.004/0.022 = −0.17 (ns)
- t=−5:  +0.002/0.017 = +0.10 (ns)
- t=−4:  +0.009/0.014 = +0.61 (ns)
- t=−3:  +0.001/0.011 = +0.13 (ns)
- t=−2:  +0.001/0.010 = +0.11 (ns)

**Zero significant pre-trends at 5% level.** Max |t-stat| = 1.26. Parallel trends assumption passes within-CS-DID scrutiny.

### 4. Simple vs dynamic aggregation consistency
- NT: simple=0.1312 vs dynamic=0.1280 (2.4% gap — negligible).
- NYT: simple=0.1216 vs dynamic=0.1195 (1.8% gap — negligible).
- Consistency between aggregation methods confirms no severe cohort-time heterogeneity problem.

### 5. Late-period CS-NT attenuation
CS-NT post-treatment: t=0: 0.126, t=2: 0.170 (peak), then gradually declining to t=9: 0.092, t=10: 0.077, t=11: 0.066. This decay pattern is expected given the repeated-events idiosyncrasy: CS-DID uses first-hit timing for gvar_CS, so communities hit again in later periods are being treated as having had the same 'first event' — the true control comparison at long horizons becomes contaminated by second/third hits for a fraction of treated units. The attenuation is documented and expected.

### 6. NT vs NYT pooled comparison
Not-yet-treated (NYT) is applicable because treatment adoption is staggered across 18 cohorts. NYT pool is a valid comparison group. CS-NT slightly higher ATT suggests not-yet-treated controls may be slightly more pre-trend similar than never-treated, which is theoretically expected in this flooding context (not all communities will ever be hit).

### 7. Controls sensitivity
No controls in this specification (cs_controls = []). DR-CS-DID not run (N/A_no_twfe_controls). No controls sensitivity issue to flag.

## Summary
CS-DID implementation is correct. Pre-trends clean across 10 periods. NT=+10.9% above TWFE and NYT=+5.4% above TWFE — direction consistent and the upward adjustment relative to TWFE is theoretically expected under staggered adoption. Late-period decay is the documented repeated-events artefact, not a parallel-trends failure.

**Verdict: PASS**
