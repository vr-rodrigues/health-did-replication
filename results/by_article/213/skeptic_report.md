# Skeptic report: 213 — Estrada & Lombardi (2022)

**Overall rating:** HIGH  *(built from Fidelity × Implementation)*
**Design credibility:** FRAGILE  *(separate axis — a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (N/A — single timing), honestdid (impl=PASS; M̄_first=0, M̄_avg=0, M̄_peak=0; design=D-FRAGILE structural n_post=1), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT, -0.49%)

---

## Executive summary

Estrada & Lombardi (2022, AEJ:Applied) exploit Chile's 2014 reform granting permanent contracts to temporary teachers with 3+ consecutive years of seniority, using a sharp seniority-cutoff DiD (3yr treated vs 2yr control). The headline result is a 3.7pp reduction in the probability of leaving one's school within one year (TWFE = -0.0372, SE = 0.0103, t = 3.63). Our stored estimate reproduces the paper's Table 2 Col 1 coefficient to within 0.49% (EXACT). All five applicable reviewers PASS on implementation checks: the TWFE specification correctly uses group + year FEs without unit FEs (the right adaptation for RCS data), clustering at the school level matches the authors, and no controls are included, consistent with the `unica_sem_controles` group label. CS-DID (NT) returns -0.0299, directionally consistent and approximately 20% smaller — a gap attributable to RCS aggregation mechanics (Pattern 25), not misspecification. All four estimators (TWFE, CS-NT, SA, Gardner) agree on sign and rough magnitude. The HonestDiD D-FRAGILE classification is a design finding about the paper, not an implementation failure: with only 1 post-period, the CI at M̄=0 (exact parallel trends) is [-0.058, -0.002] and crosses zero at any M̄>0. The pre-trends are oscillating (not drifting), and the sharp seniority cutoff provides quasi-experimental credibility beyond what HonestDiD captures. The stored consolidated result (TWFE = -0.0372) is correctly implemented and faithfully reproduces the paper. **Rating: HIGH (F-HIGH × I-HIGH). Design credibility: FRAGILE (structural, n_post=1).**

---

## Per-reviewer verdicts

### TWFE (PASS)
- Specification matches Table 2 Col 1 exactly: group indicator + year FEs + school-level clustering; no controls.
- Pre-trends oscillating, non-monotonic (t-3: +0.024, t-2: -0.015, t-1: +0.027); no systematic violation.
- Single-timing design eliminates staggered-timing bias; Gardner/BJS replicate TWFE exactly (-0.0372).
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- ATT (CS-NT simple) = -0.0299, directionally consistent with TWFE; ~20% gap explained by RCS aggregation (Pattern 25).
- NYT correctly not run (single timing; NT = NYT by construction).
- No controls spec (`N/A_no_twfe_controls`) correctly populated; Spec A not attempted (no TWFE controls to match).
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Single-timing design: all treated units adopt 2014 simultaneously; no staggered adoption. Correctly not run.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS — implementation; D-FRAGILE — design finding)
- M̄ threshold = 0 for all targets (first/avg/peak identical; single post-period). CI at M̄=0: [-0.058, -0.002] excludes zero; breaks at M̄=0.25.
- **Design finding (Axis 3):** D-FRAGILE classification is structural — n_post=1 means all targets collapse to a single estimate; any M̄>0 expands the CI to include zero. This is not a pipeline error.
- Mitigating context: oscillating pre-trends inconsistent with systematic violation; sharp seniority cutoff provides external credibility; 4-estimator directional unanimity.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary treatment, single timing, RCS data — none of the DcDH relevance conditions met.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper-auditor (EXACT)
- Our beta_twfe = -0.037180 vs paper Table 2 Col 1 = -0.037; relative delta = -0.49%. SE gap 2.53% (negligible). N = 24,002 matches.
- Full report: [`paper_audit.md`](../paper_audit.md)

---

## Three-way controls decomposition

N/A — paper has no original covariates; unconditional comparison only. `twfe_controls = []`, `cs_controls = []`. Spec A is not attempted; `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"`.

---

## Material findings (sorted by severity)

**Design findings (Axis 3 — informational, not demerits):**
- **HonestDiD D-FRAGILE (all targets):** M̄ = 0 mechanically, driven by n_post=1 + tight baseline CI. Pre-trends are oscillating, not drifting. Result relies on approximate parallel trends holding; the sharp seniority-cutoff design (RD-like) provides credibility not captured by HonestDiD's Delta^RM model.
- **RCS aggregation gap (TWFE vs CS-NT ~20%):** Pattern 25. Direction preserved across all 4 estimators.

**Implementation findings:** None.

---

## Recommended actions

- No action needed on implementation — all reviewers PASS.
- Update `reviews/paper-auditor.md` to reflect the EXACT verdict from `paper_audit.md` (dated 2026-04-19); the cached review pre-dates the fidelity audit.
- No pattern-curator action needed: RCS aggregation gap is documented as Pattern 25; HonestDiD structural fragility for n_post=1 is noted in the metadata.
- For downstream analysis: note that the result depends on near-exact parallel trends; cite the sharp seniority cutoff as supporting credibility evidence.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`paper_audit.md`](../paper_audit.md)
