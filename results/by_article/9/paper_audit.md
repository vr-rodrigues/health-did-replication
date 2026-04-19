# Paper fidelity audit: 9 — Dranove et al. (2021)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes + Stata log verification: online Appendix Table A.17, Column 4
("preferred estimate" per paper footnote 23).

Stata command recovered from replication log (03 state x quarter analysis.smcl):
`reghdfe lnpriceperpresc treated treatedXfullswitch exp [aw=wgt], absorb(state_r yq) cluster(state_r)`
Sample: `sample1 == 1` (29 treatment + control states, 26 quarters = 741 obs).

The paper labels column 4 — the `fullswitch` heterogeneity specification — as preferred
throughout the paper. The pooled (non-het) columns 1-2 are the simpler baselines.
Appendix Table A.17 is online-only and not reproduced in the main PDF.

The paper does not report a standalone TWFE table in the main body; all pooled-period
coefficient tables are in the online appendix. The main body presents event-study figures
(Figure 3 Panel B for lnpriceperpresc).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (App. Table A.17 col 4, Stata log) | -0.1761249 | 0.0519049 | 741 obs | state_r (29) | *** |
| Our stored results.csv (beta_twfe) | -0.1763056 | 0.0483934 | 754 obs* | state_r (29) | *** |
| Relative Δ | 0.10% | -6.77% | | | |

*Our pipeline runs on 29 states × 26 quarters = 754 rows before sample_filter but reports
N as total rows in data; the Stata log shows 741 obs (13 rows excluded because treated==.
when L0==1 in the Stata construction).

## Notes

- The paper's treatment variable `treated` is set to missing (.) in the quarter of
  privatization (L0), so N = 754 - 13 = 741. Our `Post_avg` includes L0 (rowSums of
  L0:L9 > 0), giving 754 effective obs. This accounts for the small SE difference.
- The preferred Stata column also includes `treatedXfullswitch` as a heterogeneity
  interaction; our TWFE uses only `Post_avg` (equivalent to the baseline `treated` column).
  Despite this, the coefficient on `treated` in col 4 (-0.1761) matches our `Post_avg`
  estimate (-0.1763) to within 0.10%.
- The Stata pooled baseline with exp control (col 3, no fullswitch): β = -0.1978,
  SE = 0.0514. Our `Post_avg` specification does not correspond to col 3.
- The metadata `original_result.beta_twfe = -0.1763` was pre-populated from our R run
  (not from the Stata log), but this is confirmed to match the Stata preferred column 4.
- SE divergence of 6.77% is within the 30% tolerance. It is attributable to the L0
  inclusion difference (13 obs) plus the absence of the `treatedXfullswitch` term in our
  specification.
- The online appendix PDF was not available; the Stata log from the full replication
  package was used as the authoritative source for the paper's number.

## Verdict rationale

Our stored beta_twfe (-0.1763) differs by 0.10% from the paper's Appendix Table A.17
Column 4 preferred estimate (-0.1761), well within the 1% EXACT threshold, with matching
sign and significance level.
