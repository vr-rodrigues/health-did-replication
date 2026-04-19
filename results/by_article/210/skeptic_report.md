# Skeptic report: 210 — Li et al. (2026)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (FAIL), bacon (N/A — unbalanced panel), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF at pdf/210.pdf)

---

## Executive summary

Li et al. (2026) estimate that China's drug distribution reform (the two-invoice system) reduced drug prices by approximately 1.9% (TWFE, Table 3 Col 3). However, the audit reveals three compounding methodological concerns. First, the TWFE event study shows severe pre-trend violations: all 11 pre-period coefficients are statistically significant (|t| = 2.05 to 3.32) and monotonically negative, a pattern consistent with contaminated comparisons arising from the all-eventually-treated design. Second, the CS-NYT estimator produces a sign-reversed result (-0.0065 simple ATT vs the paper's +0.012 CS result), a 154% deviation driven by the unbalanced panel implementation (allow_unbalanced=true) without pair-balancing. Third, HonestDiD sensitivity analysis shows the TWFE average effect loses statistical significance at Mbar=0.75 (plausible given observed pre-trends of 3-4%), and the CS-NYT confidence set already spans zero at Mbar=0. The stored CS-NYT result (att_nyt_simple = -0.0065) should not be treated as a valid replication of the paper's CS-NYT estimate. Users should interpret the headline TWFE result with substantial caution.

---

## Per-reviewer verdicts

### TWFE (WARN)
- Numerically reproduced at 2.44% deviation (our 0.01854 vs paper 0.019): implementation is correct.
- All 11 pre-period event-study coefficients are statistically significant and monotonically negative (t-stats -2.05 to -3.32), signalling severe pre-trend failure.
- The monotone convergence pattern is the fingerprint of already-treated units being used as implicit controls in an all-eventually-treated design.

[Full report: reviews/twfe-reviewer.md]

### CS-DID (FAIL)
- CS-NYT simple ATT = -0.0065 (our) vs +0.012 (paper): sign reversal, 154% deviation.
- Root cause: allow_unbalanced=true in an all-eventually-treated panel collapses the not-yet-treated control pool for late cohorts, producing incoherent cohort-time ATTs.
- CS-NYT pre-trends are clean (max |t|=1.8), confirming a correctly-implemented CS-NYT would satisfy parallel trends.
- att_cs_nyt_with_ctrls = 0 (exact zero): controlled CS specification returns implementation failure.

[Full report: reviews/csdid-reviewer.md]

### Bacon (NOT_APPLICABLE)
- Skipped: allow_unbalanced=true fails the applicability gate.
- Informational: all 133 stored Bacon pairs are LvE or EvL (no clean control), with extreme heterogeneity (cohort 688 vs 687: +0.231 vs aggregate TWFE of +0.019).

[Full report: reviews/bacon-reviewer.md]

### HonestDiD (WARN)
- TWFE att_avg robust at Mbar=0 (CI: [+0.006, +0.022]) but crosses zero at Mbar=0.75: D-MODERATE.
- CS-NYT att_avg null at Mbar=0 (CI: [-0.021, +0.012]): D-FRAGILE.
- Calibrated Mbar from observed TWFE pre-trends: approx 1.6+, well above robustness threshold.

[Full report: reviews/honestdid-reviewer.md]

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered adoption: DID_M not applicable.

[Full report: reviews/dechaisemartin-reviewer.md]

### Paper Auditor (NOT_APPLICABLE)
- PDF not found at pdf/210.pdf. Fidelity axis not evaluable.
- Manual check: TWFE 2.44% deviation (WITHIN_TOLERANCE); CS sign reversal is a methodology issue.

[Full report: reviews/paper-auditor.md]

---

## Material findings (sorted by severity)

FAIL:
- CS-DID sign reversal: att_nyt_simple = -0.0065 vs paper +0.012 (154% deviation, sign flip). Unbalanced panel + all-eventually-treated identification breakdown.
- att_cs_nyt_with_ctrls = 0: controlled CS-NYT returns exact zero — silent implementation failure when cs_controls is empty.

WARN:
- TWFE pre-trend violation: All 11 pre-periods significant (|t|=2.0 to 3.3), monotone negative drift. Parallel trends violated for TWFE.
- Balancing rule mismatch: allow_unbalanced=true without pair-balancing. Paper uses pair-balanced CS (figure3_cs_pairbalanced) not replicated by template.
- Controls asymmetry: TWFE uses 9 controls; cs_controls=[] (empty). CS estimate nonparametric but not directly comparable to TWFE.
- HonestDiD fragility: TWFE average loses significance at Mbar=0.75; calibrated Mbar approx 1.6 from observed pre-trends. CS-NYT null at Mbar=0.
- Extreme cohort heterogeneity (informational): Bacon pairs range -0.230 to +0.259; cohort 688 vs 687 = +0.231 (12x aggregate).

---

## Recommended actions

1. Repo-custodian (urgent): Set allow_unbalanced=false or implement pair-balancing for article 210 and re-run CS-NYT. The att_nyt_simple = -0.0065 is not a valid replication of the paper's CS estimate (+0.012).

2. Repo-custodian: Investigate att_cs_nyt_with_ctrls = 0. When cs_controls=[], the with_ctrls path should equal no-ctrls — exact zero is anomalous and indicates a template bug.

3. Pattern-curator: Add pattern for all-eventually-treated + unbalanced panel + no pair-balancing causing CS sign reversal. Cross-reference Pattern 30 (TWFE vs CS clustering).

4. Pattern-curator: Add pattern for TWFE monotone convergence pre-trend in all-eventually-treated designs as canonical signature of already-treated-as-pseudo-control contamination.

5. User (Lesson 10 focal point): This paper exemplifies the balancing rule problem. R csdid with allow_unbalanced=TRUE on all-eventually-treated panel does not enforce pair-balancing, while Stata csdid implicitly pair-balances. This software-driven replication gap should be highlighted as a methodological lesson for the dissertation.

6. User (methodological judgement): For dissertation reporting, present as: TWFE reproducible but pre-trend contaminated; paper's pair-balanced CS (+1.2%) is positive but smaller than TWFE; HonestDiD requires Mbar<0.75 for significance — borderline given observed pre-trends. Design credibility: D-FRAGILE (CS) to D-MODERATE (TWFE).

---

## Rating decomposition

| Axis | Score | Basis |
|------|-------|-------|
| Methodology TWFE | WARN | Pre-trend failure |
| Methodology CS-DID | FAIL | Sign reversal + implementation failure |
| Methodology Bacon | NOT_APPLICABLE | Unbalanced panel gate |
| Methodology HonestDiD | WARN | Fragile at realistic Mbar |
| Methodology dCdH | NOT_NEEDED | Not counted |
| Methodology score | M-LOW | 1 FAIL + 2 WARN |
| Fidelity paper-auditor | NOT_APPLICABLE | No PDF at pdf/210.pdf |
| Final rating | LOW | M-LOW x F-NA: use methodology alone |

---

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
