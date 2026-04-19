# Skeptic report: 65 — Akosa Antwi, Moriya & Simon (2013)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (N/A), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Akosa Antwi, Moriya & Simon (2013, AEJ:Economic Policy) estimate that the ACA dependent-coverage mandate raised any-insurance coverage among federally eligible young adults (age 19–25) by approximately 3.17 percentage points (TWFE, t=4.20, significant at 1%). Our replication confirms the direction and approximate magnitude: TWFE=0.0317, CS-NT=0.0248 (not significant due to no covariates), SA and Gardner event studies produce consistent post-period patterns. The design is a clean single-timing DiD (all treated units gain eligibility in October 2010 simultaneously), which avoids the staggered-timing negative-weighting pathologies. Pre-trends are clean across all 6 pre-periods in both TWFE and CS-NT event studies. However, two methodological WARNs are triggered: (1) the CS-DID without-controls estimate is non-significant (SE is 4x larger than TWFE due to omitting covariates), and the doubly-robust with-controls estimator returned a degenerate value of exactly 0; (2) HonestDiD reveals a D-FRAGILE design — the first-post and average ATT targets lose significance at Mbar=0, with only the peak month (t=2) remaining barely significant at Mbar=0. These WARNs collectively yield M-LOW methodology score. With no PDF available for fidelity auditing (F-NA), the rating is LOW. Users may still trust the positive direction of the ACA effect, but the magnitude (3.17pp) should be interpreted with caution given HonestDiD fragility. The stored consolidated result (TWFE=0.0317) is a fair representation of the implemented specification.

---

## Per-reviewer verdicts

### TWFE (PASS)
- TWFE coefficient 0.0317 (SE=0.0076, t=4.20) is positive and significant at 1%, consistent with the paper's headline finding.
- Pre-trends across all 6 free pre-periods are small and insignificant; largest deviation at t=-3 (-0.032, t=-1.62).
- Single-timing design avoids negative-weighting concern; template omits state-specific linear trends (known limitation documented in notes) but this does not constitute a failure.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- ATT_CS_NT = 0.0248 (SE=0.031) — positive and directionally consistent with TWFE, but individually non-significant (t=0.80) due to omission of covariates from the CS specification.
- Doubly-robust with-controls estimator returned exactly 0 with NA SE (numerical anomaly, likely RCS individual-level data incompatibility with DR estimator).
- CS-NT event study pre-trends are clean; post-period shape mirrors TWFE and SA.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Single-timing design ("unica") with repeated cross-section data: Goodman-Bacon decomposition does not apply. No staggered timing heterogeneity to diagnose.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- All three targets (first, avg, peak) have rm_Mbar=0: none remain significant beyond Mbar=0 except the peak (t=2) which survives at exactly Mbar=0 (TWFE CI [+0.008, +0.093]; CS-NT CI [+0.002, +0.095]) but loses significance at Mbar=0.25.
- Design credibility: D-FRAGILE for all targets. Fragility partly mechanical (large individual SIPP-level SEs, modest 3pp effect size).
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary single-timing design. No non-absorbing, continuous, or heterogeneous-dose treatment. de Chaisemartin (2020) negative-weighting concern does not arise.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF found at `pdf/65.pdf`. Fidelity axis cannot be evaluated. metadata.original_result is empty `{}`. Directional consistency with known paper results (~3–3.5pp) is noted informally.
- Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

---

## Material findings (sorted by severity)

### WARNs

1. **HonestDiD D-FRAGILE** (honestdid-reviewer): Average and first-post ATT targets lose significance at Mbar=0. Only peak (t=2) survives at Mbar=0 and breaks at Mbar=0.25. The causal claim is fragile to even minimal pre-trend violations under the HonestDiD framework. This is partly attributable to the large SEs in SIPP monthly micro-data.

2. **CS-DID precision loss and doubly-robust anomaly** (csdid-reviewer): The CS-NT estimator (no controls) yields ATT=0.0248 with SE=0.031 — non-significant and 4x noisier than TWFE. The doubly-robust with-controls variant returned exactly 0 (numerical failure). While the direction is consistent with TWFE, the CS-DID evidence alone does not establish a statistically significant effect.

---

## Recommended actions

- **For the repo-custodian**: Consider adding the PDF (`pdf/65.pdf`) to enable fidelity auditing and populating `original_result.beta_twfe` in the metadata with the paper's reported estimate (~0.030–0.035) for future audit runs.
- **For the repo-custodian**: Investigate the cs_nt_with_ctrls = 0 (NA SE) anomaly — check whether this is a known failure mode in the R `did` package when using individual-level RCS data with the doubly-robust estimator. If so, document as a new failure pattern (candidate Pattern 51: DR-CSDID zero-return on individual-level RCS).
- **For the user (methodological judgement call)**: The HonestDiD D-FRAGILE rating reflects structural properties of the data (large SEs from monthly SIPP micro-data, modest 3pp effect), not necessarily a weak causal effect. The conventional TWFE is strongly significant (t=4.2) and all estimators agree on direction. A reader comfortable with the parallel trends assumption — supported by visually clean pre-trends — can reasonably trust the 3.17pp finding. A reader who wants pre-trend-robust inference should note that only the peak-month effect is HonestDiD-robust at Mbar=0.
- **No action needed on design**: The single-timing design is clean; no staggered-timing heterogeneity, no negative weights, no de Chaisemartin concern.

---

## Rating derivation

| Axis | Score | Basis |
|------|-------|-------|
| Methodology | M-LOW | twfe=PASS, csdid=WARN, honestdid=WARN (2 WARNs, 0 FAILs → M-LOW) |
| Fidelity | F-NA | No PDF; fidelity not evaluable |
| Combined | **LOW** | M-LOW × F-NA → methodology alone → LOW |

HonestDiD design signal: D-FRAGILE (rm_first=0, rm_avg=0, rm_peak=0 for both TWFE and CS-NT)

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
