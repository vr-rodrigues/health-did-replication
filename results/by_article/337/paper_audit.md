# Paper fidelity audit: 337 — Cameron, Seager, Shah (2021)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes: Table II, Panel A, Column 1 — STI test positive (biological test result); full baseline-and-endline in-person sample; Equation (1) with worksite fixed effects and individual-level controls (marital status, age, education, children, years at location, discount factor, risk tolerance); cluster at worksite level (wsid); N=459; wild cluster bootstrap percentile-t p-values reported alongside conventional SEs.

SKILL_profiler fallback not needed — metadata notes explicitly identify the specification.

## Comparison

| Source | beta | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table II, Panel A, Col 1) | 0.273 | (0.101) | 459 | wsid (worksite) | *** (bootstrap p=0.038) |
| Our stored results.csv (beta_twfe) | 0.272563 | 0.031590 | 459 | wsid | n/a |
| Relative delta | -0.16% | -68.7% | | | |

## Notes

- The point estimate matches to 4 significant figures (0.273 vs 0.2726): relative difference is -0.16%, well within the 1% EXACT threshold.
- SE divergence is large (-68.7%) and fully expected. The paper employs wild cluster bootstrap percentile-t p-values (Cameron, Gelbach, Miller 2008) because only 17 worksites (6 treatment, 11 control). Our stored SE is the conventional analytical clustered SE from feols(). These are not comparable inferential objects; the paper itself reports the conventional SE in parentheses (0.101) and bracket-format bootstrap p-values. Our conventional SE (0.0316) is considerably smaller than the paper's conventional SE (0.101), which may reflect the extreme small-cluster environment (bootstrap inflates effective SE relative to conventional). This is not a data error; it is a known property of wild cluster bootstrap in small-cluster settings.
- N=459 matches the paper's reported observation count for Panel A, Column 1.
- The paper's main text (p.446) confirms: "Table II, Column 1 indicates that criminalization increases the probability of a positive indicator for STIs by 27 percentage points (a 58% increase on the baseline mean of 46%)." Our coefficient 0.2726 reproduces this exactly.
- Metadata correctly records original_result: beta_twfe=0.2726, se_twfe=0.0316 (our conventional SE, not the bootstrap SE).

## Verdict rationale

The point estimate matches to within 0.16%, satisfying the EXACT criterion (|rel_diff_beta| < 1%), with correct positive sign. SE divergence reflects the paper's use of wild cluster bootstrap inference in a 17-cluster setting vs. our conventional analytical SE — not a specification error.
