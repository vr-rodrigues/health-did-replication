# Skeptic report: 290 — Arbogast et al. (2022)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (FAIL), bacon (WARN), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Arbogast et al. (2022) study the effect of administrative burden in Medicaid enrollment processes on child Medicaid enrollment rates, using a staggered DiD design across 15 treated states with 12 distinct treatment cohorts over 2014-2020. The paper's headline TWFE estimate is -0.0172 (se=0.0072), suggesting administrative burden reduces child Medicaid enrollment by 1.72 percentage points. Our implementation reproduces the TWFE within 6% (-0.0182), within tolerance. However, three serious methodological concerns arise: (1) the CS-DID estimation completely failed ("argumento de comprimento zero") due to the reconstructed dataset (original IPUMS ACS not redistributable), meaning the paper's own CS-DID ATT estimate of -0.031 cannot be validated; (2) SA pre-trends are highly significant at t=-4 (t-stat=4.3) and t=-5 (t-stat=5.3), indicating a pre-existing downward enrollment trend before treatment adoption that violates parallel trends; and (3) HonestDiD shows the average ATT is fragile — significant only under exact parallel trends (Mbar=0) and loses significance at any non-zero smoothness allowance (Mbar=0.25). Given the observed SA pre-trends, Mbar=0 is implausible. The stored TWFE result should be interpreted with caution; the true causal effect on enrollment is likely smaller in magnitude or statistically fragile.

## Per-reviewer verdicts

### TWFE (WARN)
- Point estimate -0.0182 vs paper -0.0172 (6.05% gap, within tolerance). N=4085 matches paper 4086.
- SA pre-trends highly significant: t=-5 (t-stat=-5.3), t=-4 (t-stat=-4.3) — strong evidence of pre-existing downward trend.
- Post-period spike at t=5 (-0.0296, 4x larger than t=4) raises concern about late-cohort dynamics or data reconstruction artifacts.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (FAIL)
- All CS-DID variants failed: "argumento de comprimento zero" in R — empty group-time cells during `att_gt()` construction.
- Affects both NT and NYT variants, with and without controls. Complete estimation failure.
- Cannot validate paper's reported CS-DID simple ATT = -0.031 (larger magnitude than TWFE).

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (WARN)
- TVU (clean comparison) dominates at 88.2% of total weight — reassuring for TWFE interpretation.
- Cohort-level effect heterogeneity: range -0.0619 (cohort 60) to +0.0048 (cohort 67) — 6.7pp spread relative to -0.018 aggregate is large.
- Forbidden comparisons (LvE+EvL) = 11.8%; mixed signs partially offset each other.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- TWFE average ATT: robust at Mbar=0 only (CI = [-0.0086, -0.0016]); breaks at Mbar=0.25 — D-FRAGILE in practice given observed SA pre-trends.
- TWFE peak ATT: survives to Mbar=0.25 (CI = [-0.0133, -0.0007]) — D-MODERATE.
- CS-NT all targets: D-FRAGILE at Mbar=0 (all include zero); cannot test further due to CS-DID failure.
- With SA t-stats >4 in pre-period, Mbar=0 assumption is not credible; results effectively fragile.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered adoption. CS-DiD is the appropriate tool; de Chaisemartin adds no additional value here.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF at pdf/290.pdf. Fidelity axis excluded from rating synthesis.
- Metadata records target beta = -0.0172; stored = -0.0182 (6% gap) — plausible from data reconstruction note.

Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

## Material findings (sorted by severity)

**FAIL:**
- CS-DID complete estimation failure (all variants) — cannot validate paper's CS-DID ATT of -0.031 or perform negative-weight robustness check. Root cause: dataset reconstruction from Census API instead of original IPUMS ACS produces empty group-time cells.

**WARN:**
- SA pre-trends statistically significant at t=-4 (t-stat=4.3) and t=-5 (t-stat=5.3), indicating pre-existing downward enrollment trend that violates parallel trends assumption.
- HonestDiD average ATT fragile: loses significance at Mbar=0.25, which is plausible given observed SA pre-trends. Average ATT is effectively D-FRAGILE.
- Cohort heterogeneity in Bacon: effect ranges from -0.062 to +0.005 across treated cohorts; cohort 60 is an outlier at 3.4x the aggregate magnitude; cohort 67 shows positive (opposite sign) effect.

## Recommended actions

- **For repo-custodian agent:** Investigate the "argumento de comprimento zero" CS-DID failure. Check whether `newpolicydate` variable in the reconstructed dataset has valid cohort coverage across 2014-2020 sample. Confirm that never-treated states are correctly coded (st not in treated list). Consider running `did::att_gt()` with `anticipation=0` and printing group-time counts to identify which cells are empty.
- **For repo-custodian agent:** Investigate the t=5 TWFE post-period spike (-0.0296 vs -0.0107 at t=4). Check whether this reflects a genuine late-cohort effect (the most recently treated states) or a data reconstruction artifact in the final sample year (2020, COVID-affected).
- **For user (methodological judgement):** The SA pre-trend violations at t=-4/-5 are large and statistically significant. The parallel trends assumption is not credible without a pre-trend explanation. Consider whether the original paper addresses this pre-trend in its robustness section, and whether a trend-adjusted specification is available.
- **For pattern-curator:** The CS-DID "argumento de comprimento zero" failure from reconstructed Census API data (vs original IPUMS) should be logged as a new failure pattern — empty group-time cells from imperfect data reconstruction when original microdata are not redistributable.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
