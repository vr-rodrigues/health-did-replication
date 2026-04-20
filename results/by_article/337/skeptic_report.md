# Skeptic report: 337 — Cameron, Seager, Shah (2021)

**Overall rating:** HIGH  *(Fidelity × Implementation)*
**Design credibility:** MODERATE  *(separate axis — finding about the paper, not a demerit against our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS; SE-inflation is Axis-3 design finding), bacon (SKIPPED — single timing), honestdid (SKIPPED — 0 pre-periods), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT, 0.16%)

---

## Executive summary

Cameron, Seager, and Shah (QJE 2021) estimate a 27.3 pp increase in STI positivity (sept_any) among sex workers at criminalized worksites following the Nov 2014 closings in Malang, East Java, Indonesia. The design is a 2x2 DiD: single sharp treatment date, 2 survey waves, N=12 worksites (6 treated, 6 control). Our stored TWFE (0.2726) reproduces the paper's Table II Col 1 Panel A (0.273) to within 0.16%, satisfying the EXACT criterion. Implementation is clean: fixed effects, sample filter, treatment variable, and clustering are all correctly specified. Fidelity is F-HIGH; implementation has zero WARNs → rating is HIGH.

The only substantive concern — CS-DID's bootstrap SE being 13.7x larger than TWFE's — is an Axis-3 design finding: with K=6 treated clusters, any cluster-bootstrap estimator yields unstable variance, a limitation the paper itself addresses via wild cluster bootstrap (Cameron-Gelbach-Miller 2008). The CS-NT coefficient is directionally correct (+0.211 vs TWFE +0.273); the SE is uninformative, not our pipeline's error. Bacon and HonestDiD are structurally inapplicable (single timing, 0 pre-periods). The stored 0.2726 is the reliable causal estimate for this setting; downstream inference should follow the paper's bootstrap p-values, not our stored conventional SE.

---

## Per-reviewer verdicts

### TWFE (PASS)
- Coefficient EXACT: stored 0.2726 vs paper 0.273 (0.15% rounding difference, within floating-point).
- 2x2 design is free of negative weights and staggered-timing contamination by construction.
- Conventional SE (0.0316) is smaller than paper's bootstrap SE (0.101); divergence expected and documented — wild cluster bootstrap is appropriate with K=6 treated clusters.

[Full report: reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (impl=PASS; Axis-3: few-cluster SE inflation)
- CS-NT ATT = 0.211 — directionally consistent with TWFE (+0.273); 22.5% gap is within RCS-aggregation norms (Pattern 25).
- CS-NT SE = 0.434–0.469 (13.7–14.8x TWFE SE); t-statistic = 0.49 — statistically uninformative.
- Root cause is the paper's own sample size (K=6 treated clusters), not a pipeline error. gvar_CS correctly specified; no forbidden comparisons; no implementation fault. Classified as Axis-3 design finding.
- Pre-trends: untestable (0 pre-periods — only 2 survey waves in the paper).

[Full report: reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (SKIPPED)
Treatment timing is single. Bacon decomposition is not applicable. Axis-3 TvT share: N/A.

### HonestDiD (SKIPPED)
has_event_study = false; 0 pre-periods available. HonestDiD requires ≥3 pre-periods. Axis-3 M̄: N/A.

### de Chaisemartin (NOT_NEEDED)
Absorbing, binary, single-timing design — the de Chaisemartin estimator adds no identification value here.

[Full report: reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (EXACT)
- Stored beta_twfe = 0.272563 vs paper Table II Col 1 Panel A = 0.273: relative delta −0.16%, within EXACT threshold (|Δ| < 1%).
- N=459 matches paper. SE divergence (−68.7%) is expected and non-comparable (bootstrap vs. analytical); not a fidelity failure.
- Fidelity axis: F-HIGH.

[Full report: paper_audit.md](../paper_audit.md)

---

## Three-way controls decomposition

N/A — `twfe_controls = []`. No original covariates; unconditional comparison only. Specs A and B are identical to Spec C by construction. No decomposition warranted.

---

## Three-axis summary

| Axis | Score | Basis |
|---|---|---|
| Axis 1 — Fidelity | F-HIGH | paper-auditor EXACT (0.16%) |
| Axis 2 — Implementation | I-HIGH | 0 impl-WARNs, 0 impl-FAILs across all applicable reviewers |
| Axis 3 — Design credibility | D-MODERATE | K=6 clusters → few-cluster inference limitation; 2x2 design otherwise clean; pre-trends untestable (0 pre-periods); no staggered-timing concerns |

**F-HIGH × I-HIGH → HIGH**

The CS-DID SE inflation was previously miscounted as an Axis-2 WARN (prior report dated 2026-04-18). It is correctly classified as an Axis-3 design finding: our implementation is correct; the SE instability is a structural consequence of the paper's sample size (K=6 treated clusters), a limitation the paper itself acknowledges and corrects via wild cluster bootstrap.

---

## Material findings (sorted by severity)

- **Axis-3 finding — few-cluster CS-DID inference (design constraint, not our error):** CS-NT SE = 0.434–0.469 (13.7x TWFE SE). Downstream users must not use `se_csdid_nt` from results.csv for inference on article 337. The paper's wild cluster bootstrap p-values (Cameron-Gelbach-Miller 2008) remain the authoritative inferential measure. Coefficient direction (+0.211) is confirmed.

---

## Recommended actions

- No action needed on methodology or implementation: rating is HIGH, our reanalysis is clean.
- For repo-custodian: consider adding a flag or note in consolidated_results.csv indicating that `se_csdid_nt` for article 337 is a few-cluster bootstrap artefact (K=6 treated clusters) and should not be used for inference without the wild cluster bootstrap correction.
- For user: when citing the CS-NT result, note that N=6 treated clusters renders the CS-DID SE uninformative; the coefficient direction (positive, ~21 pp) is confirmed, but magnitude uncertainty is very large. The paper's bootstrap-based inference (p=0.038) remains the appropriate inferential standard.
- Prior skeptic report (2026-04-18) carried rating MODERATE due to incorrectly classifying the CS-DID SE inflation as an Axis-2 implementation WARN. Corrected to HIGH per 3-axis rubric: SE inflation is a design-level finding (Axis 3), not a pipeline error (Axis 2).

---

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [paper_audit.md](../paper_audit.md)

Skipped (not applicable): bacon-reviewer, honestdid-reviewer.
