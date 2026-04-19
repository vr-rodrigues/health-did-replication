# Skeptic report: 79 — Carpenter, Lawler (2019)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (N/A — repeated cross-section), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — PDF absent)

---

## Executive summary

Carpenter & Lawler (2019) study the effect of state-level Tdap vaccine mandate requirements for middle school children on vaccination rates among children under 13 (NIS-Teen survey). The headline TWFE estimate (β = 0.135, SE = 0.014) is reproduced exactly from the paper's Table 2 Column 3 and reflects a staggered, state-level policy adoption design over a 9-year window (2004–2012 adoption cohorts) using a continuous mandate intensity variable (`TDcont_mandate`). The stored result is credible. The main methodological concern is that the CS-NYT estimator — the most credible comparison group for this staggered design — yields an ATT of approximately 0.090, roughly 33% smaller than the TWFE headline, and the NT comparison group shows significant pre-trends in Stata validation (Pattern 24), indicating heterogeneity across cohorts. HonestDiD finds the contemporaneous effect highly robust (Mbar > 1.50 for both estimators) but the average post-treatment effect is moderately robust under TWFE (Mbar = 0.50) and fragile under CS-NYT (Mbar = 0.25). The user should trust the stored TWFE as faithful to the paper's specification, but should weight the lower CS-NYT ATT (~0.090) as the more design-defensible estimate for policy inference.

---

## Per-reviewer verdicts

### TWFE (PASS)

- β = 0.135036 reproduced exactly from paper (Table 2, Col 3); SE = 0.014 matches exactly.
- Three-way fixed effects (state × year × age group) with 71 covariates and survey weights correctly specified.
- Mild systematic negative pre-trend pattern (all pre-periods negative, max |t| ≈ 1.53) is a soft concern shared with the paper, not an implementation error.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)

- CS-NYT ATT ≈ 0.090 — ~33% below TWFE headline (0.135), indicating cohort-level treatment effect heterogeneity.
- NT comparison group has significant pre-trends in Stata validation (Pre_avg = -0.048, p = 0.001); NYT is the more credible estimator (Pre_avg = -0.022, p = 0.143).
- CS controls reduced from 71 to 2 (female, married) due to singularity in att_gt cells with few state-level observations per cohort.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- Skipped: data_structure = repeated_cross_section; Bacon decomposition requires a true panel.
- Informational note: a Bacon decomposition file exists from R template run on aggregated state-year data; all component estimates positive, with a few near-zero "Later vs. Always Treated" comparisons using cohort 2003 as always-treated reference.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS)

- Contemporaneous effect (t=0) is robust: Mbar > 1.50 for both TWFE and CS-NYT (highly robust).
- Average post-treatment ATT: TWFE robust to Mbar = 0.50 (D-MODERATE); CS-NYT fragile at Mbar = 0.25 (D-FRAGILE).
- Peak ATT: fragile at Mbar = 0.25–0.50 for both estimators.
- 5 free pre-periods used; no implementation errors.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing staggered design with continuous mandate intensity variable. Continuous treatment is the original authors' design choice, not non-absorbing/reversible treatment.
- CS-NYT already captures cohort-level ATT heterogeneity. DH adds no material additional information.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)

- PDF not found at `pdf/79.pdf`. Formal fidelity extraction not possible.
- Metadata benchmark: original_result.beta_twfe = 0.135; stored result = 0.135036 (<0.1% discrepancy); consistent with exact replication.
- Fidelity axis: F-NA.
- Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

---

## Methodology score derivation

| Reviewer | Verdict | Counted? |
|---|---|---|
| twfe | PASS | Yes |
| csdid | WARN | Yes |
| bacon | NOT_APPLICABLE | No |
| honestdid | PASS | Yes |
| dechaisemartin | NOT_NEEDED | No |

Applicable: 2 PASS + 1 WARN = M-MOD (1 WARN, rest PASS).
Fidelity: F-NA (PDF absent).
Combined (M-MOD × F-NA): Use methodology alone → **MODERATE**.

---

## Material findings (sorted by severity)

**WARN items:**

1. [csdid] CS-NYT ATT (~0.090) is 33% below TWFE headline (0.135): indicates cohort-level heterogeneity in mandate effects; NYT is the preferred estimator but gives a materially different headline number.
2. [csdid] NT comparison group has significant pre-trends (Stata validation: Pre_avg = -0.048, p = 0.001): parallel trends assumption is suspect for the NT pool due to early cohort composition differences between Stata and R implementations.
3. [honestdid] CS-NYT average ATT is fragile at Mbar = 0.25 (D-FRAGILE): the smaller CS-NYT ATT has a lower signal-to-noise ratio, and even modest violations of parallel trends erode the average post-treatment confidence interval to include zero.
4. [twfe] Mild systematic negative pre-trend pattern in TWFE event study (all t=-6 to t=-2 coefficients negative): soft concern consistent across all estimators; not individually significant but systematic.

---

## Recommended actions

- For the **repo-custodian**: the `notes` field in metadata.json correctly documents the NT vs. NYT divergence (Pattern 24) and the CS control singularity. No metadata update needed.
- For the **user**: When citing results from this paper, prefer CS-NYT ATT (~0.090) over the TWFE headline (0.135) as the more design-defensible estimate. The gap (~0.045 pp) is substantively meaningful and reflects genuine cohort-level heterogeneity in mandate compliance effects.
- For the **user**: The contemporaneous effect (t=0, β ≈ 0.104–0.112 across estimators) is the most robust estimate across HonestDiD sensitivity analysis (Mbar > 1.50). This represents the immediate-year uptake response to mandate adoption.
- For the **pattern-curator**: No new failure patterns to add. Pattern 24 (CS-NT vs CS-NYT divergence in RCS designs with early cohorts) is already documented.
- If the PDF becomes available, re-run the paper-auditor to formally close the F-NA axis.

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
