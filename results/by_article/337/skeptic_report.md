# Skeptic report: 337 — Cameron, Seager, Shah (2021)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (N/A — single timing), honestdid (N/A — no event study), dechaisemartin (NOT_NEEDED), paper-auditor (N/A — no PDF)

## Executive summary

Cameron, Seager, Shah (QJE 2021) study the effect of criminalizing sex work in Malang, East Java, Indonesia. The headline result is a 27.3pp increase in STI positivity (sept_any) among sex workers at criminalized worksites (TWFE = 0.2726, Table II Col 1 Panel A). The design is an exceptionally clean 2x2 DiD: single treatment date (Nov 2014 closings), 2 survey waves (baseline Feb-Mar 2014, endline May-Jun 2015), N=12 worksites (6 treated, 6 control). The stored TWFE reproduces the paper exactly (0.2726 vs paper 0.273, 0.15% gap). The sole methodological concern is that the CS-DID estimator — while directionally consistent (ATT = 0.211) — yields a SE 13.7x larger than TWFE's due to bootstrapping over only 6 treated clusters, rendering the CS-NT estimate statistically uninformative. This is a structural sample-size limitation, not a methodological error; the paper itself addresses the few-cluster inference problem via wild cluster bootstrap. No staggered-timing bias, no negative-weight concerns, no event study concerns, and no de Chaisemartin issues apply to this 2x2 design. The stored consolidated result of 0.2726 is reliable and directionally robust.

## Per-reviewer verdicts

### TWFE (PASS)
- Coefficient reproduced exactly: stored 0.2726 vs paper 0.273 (0.15% rounding difference).
- Clean 2x2 design — no negative weights, no staggered-timing contamination.
- Conventional SE (0.0316) is 3.2x smaller than paper's bootstrap SE (0.101); this divergence is expected and documented — wild cluster bootstrap is appropriate with 6 treated clusters.

[Full report: reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT ATT = 0.211 (22.5% below TWFE = 0.273), directionally consistent.
- CS-NT SE = 0.434–0.469, 13.7–14.8x the TWFE SE — renders t-statistic = 0.49, statistically uninformative.
- Root cause: cluster bootstrap over N=6 treated worksites is numerically unstable; structural sample-size limitation.
- No forbidden comparisons (single timing); no pre-trends testable (only 2 periods).

[Full report: reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (N/A — SKIPPED)
Treatment timing is single (not staggered). Bacon decomposition is not applicable.

### HonestDiD (N/A — SKIPPED)
No event study in the paper (only 2 periods — no pre-periods available). HonestDiD requires at least 3 pre-periods.

### de Chaisemartin (NOT_NEEDED)
Treatment is absorbing, binary, single-timing — the standard case. de Chaisemartin estimator adds nothing for this design.

[Full report: reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (N/A — SKIPPED)
No PDF at `pdf/337.pdf`. Numerical fidelity axis not evaluable.

## Material findings (sorted by severity)

- **WARN — CS-NT SE inflation (13.7x):** CS-DID applied to N=6 treated clusters yields a bootstrap SE of 0.434–0.469 vs TWFE SE of 0.032. The CS-NT estimate is directionally correct but statistically uninformative. Downstream users should not use the CS-NT SE for inference; the paper's wild cluster bootstrap p-values remain the appropriate inferential standard.

## Recommended actions

- No action on methodology: the design is clean and the stored TWFE is the correct causal estimate for this setting.
- **For repo-custodian:** Add a warning flag to results.csv (or a note in report.md) that `se_csdid_nt` for article 337 is a few-cluster bootstrap artefact and should not be used for inference. The paper's wild cluster bootstrap SE (0.101) is the authoritative inferential measure.
- **For user:** When citing the CS-NT result, note that N=6 treated clusters renders the CS-DID SE uninformative; the coefficient direction (positive) is confirmed but the magnitude uncertainty is very large.

## Individual reports

- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

Skipped (not applicable): bacon-reviewer, honestdid-reviewer, paper-auditor.
