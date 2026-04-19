# Skeptic report: 80 — Marcus et al. (2022)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A — single timing, RCS), honestdid (N/A — only 2 pre-periods), dechaisemartin (NOT_NEEDED — absorbing binary single cohort), paper-auditor (N/A — no PDF)

---

## Executive summary

Marcus, Siedler & Ziebarth (2022) estimate the long-run effect of sports club vouchers distributed to primary school children in three German states on sports club membership, using a DiD design comparing cohorts who received the voucher (third-graders in 2008) against earlier and later cohorts in treated and control states. The headline TWFE result is beta = 0.0089 (SE = 0.0188), statistically indistinguishable from zero. Our replication reproduces this TWFE estimate with near-exact precision (0.00892, SE 0.01872). However, two methodological warnings are warranted: (1) the repeated cross-section data structure requires composition stability within cities across cohort years — a non-trivial identifying assumption that the stored result assumes but does not test; and (2) our CS-DID estimate (ATT = 0.01991, SE = 0.02779) diverges substantially from the paper's reported CS value (0.0058, SE 0.0118), with the discrepancy most plausibly explained by differences between R's `did` package and Stata's `csdid2` in handling RCS pseudo-panel aggregation and clustering. All estimators agree the effect is statistically insignificant. The stored consolidated_results value (TWFE beta = 0.00892) faithfully replicates the paper's point estimate, but the CS-DID column should be treated with caution due to the aggregation discrepancy.

---

## Per-reviewer verdicts

### TWFE (WARN)
- Point estimate 0.00892 matches paper's 0.0089 to 4 decimal places; SE 0.01872 matches 0.0188 to 4 significant figures. Fidelity is near-exact.
- WARN: Repeated cross-section data with city fixed effects requires that within-city cohort composition does not change endogenously with treatment; this assumption is plausible but untested in our replication.
- Effect is not statistically significant at any conventional level (t ≈ 0.48).
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT ATT = 0.01991 (SE 0.02779) is 3.4× the paper's reported CS value of 0.0058 (SE 0.0118).
- Divergence most plausibly due to RCS pseudo-panel aggregation differences between R `did` and Stata `csdid2`, and absence of cityno clustering in our CS run (`cs_cluster = "none"`).
- Pre-trend at t=-2 is 0.013 (SE 0.042), non-significant; parallel trends assumption not visibly violated given low power.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (N/A)
- Not applicable: treatment timing is single (not staggered) and data structure is repeated cross-section (not panel). The `bacon.csv` artifact with a single comparison row and anomalous negative sign (-0.012) is an RCS aggregation artifact, not a valid decomposition.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (N/A)
- Not applicable: only 2 pre-periods available (t=-2, t=-1). HonestDiD requires at least 3 pre-periods to identify the smoothness parameter.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Single-cohort absorbing binary treatment design has no staggered timing or continuous treatment heterogeneity. The TWFE estimator is free of the negative-weight problem that DCM addresses.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

---

## Material findings (sorted by severity)

**WARN — CS-DID estimate divergence (csdid-reviewer):** Our CS-NT ATT (0.01991) is 3.4× the paper's reported CSDID value (0.0058). The most likely cause is the R `did` package's RCS pseudo-panel aggregation versus Stata's `csdid2` native RCS support, combined with the absence of cityno clustering in our CS run. This does not change the qualitative conclusion (both are non-significant) but the stored CS column is not directly comparable to the paper's printed value.

**WARN — RCS composition stability (twfe-reviewer):** City-level fixed effects applied to repeated cross-section data require that the composition of students observed per city per year is not endogenously related to treatment. This is a design-level assumption inherited from the original paper and cannot be resolved without individual-level composition data.

---

## Recommended actions

- **For the repo-custodian agent:** Update `cs_cluster` from `"none"` to `"cityno"` in `data/metadata/80.json` and re-run the analyst to obtain a more comparable CS-DID estimate. This is the most likely source of the SE discrepancy.
- **For the repo-custodian agent:** Investigate whether R's `did` package applied to RCS data is producing the correct aggregation relative to Stata's `csdid2 ... agg(event)`. Consider adding a note in `knowledge/failure_patterns.md` about RCS pseudo-panel aggregation divergence between implementations.
- **For the user (methodological judgement):** The 2 pre-period limitation prevents HonestDiD sensitivity analysis. If robustness to violations of parallel trends is a concern, consider whether earlier administrative data (pre-2006) are available to extend the pre-treatment window.
- **For the pattern-curator:** Consider adding a pattern for "CS-DID divergence in RCS designs due to pseudo-panel aggregation differences between R `did` and Stata `csdid2`" to `knowledge/failure_patterns.md`.
- The qualitative conclusion — the voucher program had no statistically significant effect on sports club membership — is robust across all estimators (TWFE, CS-NT, SA, BJS). No action needed on the headline finding.

---

## Methodology rating detail

| Reviewer | Status | Verdict | Counted |
|---|---|---|---|
| twfe-reviewer | APPLICABLE | WARN | Yes |
| csdid-reviewer | APPLICABLE | WARN | Yes |
| bacon-reviewer | SKIPPED | NOT_APPLICABLE | No |
| honestdid-reviewer | SKIPPED | NOT_APPLICABLE | No |
| dechaisemartin-reviewer | APPLICABLE | NOT_NEEDED | No |
| paper-auditor | NOT_APPLICABLE | NOT_APPLICABLE | No (F-NA) |

**Methodology score:** 2 WARN, 0 FAIL → M-LOW
**Fidelity score:** F-NA (no PDF for independent verification)
**Combined rating (M-LOW x F-NA — using methodology alone):** LOW

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

