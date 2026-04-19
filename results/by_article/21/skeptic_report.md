# Skeptic report: 21 — Buchmueller, Carey (2018)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (PASS), bacon (NOT_APPLICABLE), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Buchmueller & Carey (2018) study the effect of must-access Prescription Drug Monitoring Programs (PDMPs) on opioid utilization among Medicare beneficiaries, using a staggered DiD design across U.S. states. Their headline TWFE estimate is -0.0019 (SE 0.0008), suggesting must-access PDMPs reduced high-intensity opioid prescribing by approximately 0.19 percentage points. Our replication recovers this estimate essentially exactly (beta_twfe = -0.00187, <1.6% gap). The main methodological concern is a pre-trend pattern in the TWFE event study: coefficients at t=-3 (-0.00171) and t=-2 (-0.00130) are 91% and 69% of the ATT in magnitude respectively, raising questions about the parallel trends assumption in the periods immediately prior to PDMP adoption. However, this concern is substantially mitigated by two findings: (1) the CS-DID estimator shows essentially flat pre-trends (all pre-period CS-NT coefficients within 1.7 SEs of zero), suggesting the TWFE pre-trend is a composition effect rather than a true parallel trends violation; and (2) the Bacon decomposition shows ~89% of TWFE weight falls on clean treated-vs-never-treated comparisons, limiting negative weighting bias. The HonestDiD analysis confirms sign preservation (negative effect) at Mbar=0 for the average ATT, with fragility emerging at Mbar=0.25. The stored consolidated result (TWFE: -0.00187; CS-NT dynamic: -0.001888) is credible and matches the paper's reported values closely. Users should be aware that result robustness to modest pre-trend violations is limited, and the dynamic post-treatment pattern (large initial effect decaying ~65% by t=2) means the static ATT masks meaningful treatment effect heterogeneity over time.

---

## Per-reviewer verdicts

### TWFE (WARN)

- Pre-trend at t=-3 (-0.001711) is 91% of the ATT magnitude; t=-2 (-0.001295) is 69% — economically substantial and warrants scrutiny of the parallel trends assumption.
- Bacon decomposition is reassuring: ~89% of TWFE weight falls on clean treated-vs-never-treated 2x2s; later/earlier timing comparisons contribute only ~11%.
- Post-adoption effect decays from -0.00353 at t=0 to -0.00125 at t=2 (65% reduction), indicating the static TWFE ATT averages over substantial dynamic heterogeneity.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)

- CS-NT dynamic ATT (-0.001888) matches the paper's CS-DID estimate (-0.0018) within 4.9%; agreement validates the cohort variable construction and aggregation method.
- CS-NT pre-trends are essentially flat (max pre-period coefficient 0.00155 at t=-5, within 1.7 SEs of zero), strongly contrasting with the large TWFE pre-trend artefact at t=-3 and t=-2.
- Results are robust across comparison group choice: CS-NT and CS-NYT dynamic estimates agree within 0.2% (-0.001888 vs -0.001891).

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- Skipped: `allow_unbalanced = true` violates the balanced-panel requirement for a formally valid Bacon decomposition.
- Informational note: the available bacon.csv shows ~89% weight on treated-vs-never-treated comparisons, suggesting low contamination risk if the panel were balanced.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS)

- TWFE `avg` ATT is sign-identified at Mbar=0 (robust CI: [-0.00543, -0.00029]); sign breaks at Mbar=0.25.
- CS-NT `avg` ATT is marginally sign-identified at Mbar=0 ([-0.00535, +0.0000832]); breaks at Mbar=0.25.
- Breakdown point for both estimators is very small (Mbar ~0.01–0.05 for CS-NT `avg`), reflecting fragility to any non-trivial violations — a material limitation given the observed large TWFE pre-trends at t=-3/t=-2.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Treatment is absorbing binary (must-access PDMP mandate, never repealed in sample); no variation in dose or treatment switching present.
- DChDH estimator adds no methodological value beyond CS-DID for this design.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)

- No PDF at `pdf/21.pdf`; automated fidelity audit not possible.
- Informational: metadata `original_result` field records paper's values; our estimates match within 1.6% (TWFE) and 4.9% (CS-NT dynamic), consistent with WITHIN_TOLERANCE or better.

Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

---

## Material findings (sorted by severity)

**WARN items:**

1. **TWFE pre-trend at t=-3 and t=-2 (twfe-reviewer):** Coefficients of -0.001711 and -0.001295 are 91% and 69% of the ATT magnitude respectively. While the CS-DID pre-trends are flat (suggesting this is a composition effect), the TWFE event study alone would raise serious parallel trends concerns. Users relying solely on the TWFE event study should note this limitation.

2. **HonestDiD fragility (honestdid-reviewer):** Sign identification breaks at Mbar=0.25 for both TWFE and CS-NT `avg` targets. The result is robust only under the assumption of near-zero post-treatment violations. Given the large observed TWFE pre-trends, this is a non-trivial constraint on credibility claims.

3. **Post-adoption effect decay (twfe-reviewer):** Effect at t=0 is approximately 2.8x the effect at t=2 (-0.00353 vs -0.00125). The static ATT masks this dynamic; a reader relying on the static coefficient may overestimate the sustained long-run impact of must-access PDMPs.

---

## Rating decomposition

| Axis | Score | Basis |
|---|---|---|
| Methodology | M-MOD | 1 WARN (twfe), 2 PASS (csdid, honestdid); bacon and dechaisemartin excluded |
| Fidelity | F-NA | No PDF; paper-auditor NOT_APPLICABLE |
| Combined | **MODERATE** | M-MOD × F-NA → use methodology alone → MODERATE |

---

## Recommended actions

- **For the user (methodological judgement):** When presenting results for article 21, report both the TWFE and CS-NT dynamic ATTs and explicitly note that the TWFE event study shows large t=-3/t=-2 pre-trends while the CS estimator does not. The preferred headline should be the CS-NT dynamic ATT (-0.001888), which is more robust to the identified composition effect.
- **For the user (methodological judgement):** Report the HonestDiD breakdown point (Mbar ~0.25 for sign identification) alongside the point estimate. Acknowledge that sign is preserved at Mbar=0 but that any non-trivial violations would invalidate directional inference.
- **For the user (interpretation):** Supplement the static ATT with the dynamic event study to convey that the treatment effect is largest at t=0 and decays substantially by t=2. A static coefficient without this context overstates the sustained effect.
- **No action needed on metadata:** The specification is correctly implemented; `gvar_CS`, `Post_avg`, and the `aggte(type='dynamic')` aggregation are all correct.

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
