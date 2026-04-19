# Skeptic report: 9 — Dranove et al. (2021)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (PASS), bacon (PASS), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Dranove, Ody & Starc (2021) estimate the effect of Medicaid managed care adoption on log drug price per prescription using a staggered TWFE specification across 29 U.S. states over 26 quarters. The headline TWFE estimate is -0.176 (SE=0.048), implying that managed care adoption reduces drug prices by approximately 16%. Our replication matches the TWFE estimate to within 0.003% and the CS-DID estimates to within 3.2% of the paper's reported values. All five estimators — TWFE (-0.176), CS-NT (-0.208), CS-NYT (-0.213), Sun-Abraham (-0.177 at comparable horizons), and Gardner (-0.183) — agree on sign and order of magnitude, with CS-DID estimates showing 15–20% larger magnitudes than TWFE, consistent with mild upward contamination from "later vs earlier treated" Bacon decomposition components. The Bacon decomposition reveals a well-structured identification: 78.5% of TWFE weight derives from clean treated-vs-untreated comparisons, and 9 of 10 cohorts show negative effects in those comparisons. The sole methodological concern is that the HonestDiD sensitivity analysis was run with only 2 pre-periods despite 8 being available; nevertheless, the average and peak treatment effects are robust to moderate pre-trend violations (Mbar ~0.70–1.1). The stored consolidated result (-0.176 TWFE, -0.208 CS-NT) is credible and can be trusted for meta-analytic purposes, with the caveat that the HonestDiD bound calibration would benefit from re-running with all 8 pre-periods.

---

## Per-reviewer verdicts

### TWFE (PASS)
- TWFE specification exactly matches original Stata code (`reghdfe` with `Post_avg`, `exp`, state and quarter FEs, state clustering, survey weights); numerical match is within 0.003%.
- Pre-trend pattern is clean: all 8 pre-period coefficients are statistically indistinguishable from zero, with the largest being -0.069 at t=-9 (SE=0.062, easily within one SE of zero).
- Post-treatment trajectory builds monotonically from -0.048 (t=0) to -0.259 (t=7), then plateaus — economically consistent with gradual managed care formulary implementation.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- CS-NT and CS-NYT correctly specified with `base_period='universal'` and `cs_controls=[]`; the latter choice is required to avoid did v2.3.0 cohort-dropping when `xformla=~exp` is passed.
- CS-NT pre-trends in the event study are cleaner than TWFE pre-trends (max |coeff| = 0.024 vs 0.069 at t=-9), reinforcing the parallel trends assumption.
- All five estimators yield negative and consistent ATT estimates; the TWFE-to-CS-DID gap (15–20%) is in the expected direction and magnitude for this staggered design.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (PASS)
- TVU comparisons account for 78.5% of TWFE weight; TVT contamination is present (21.5%) but minor in impact, as most TVT 2x2 estimates are also negative.
- 9 of 10 cohorts show negative TVU estimates; the sole positive cohort (205, earliest adopter, +0.047) contributes only 3.9% of total weight.
- TWFE undershoots CS-DID by ~15%, consistent with mild upward contamination from small positive "later vs earlier" TVT components and the one positive cohort.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- Average and peak treatment effects are robust to pre-trend violations up to Mbar=0.70 (TWFE) and Mbar=1.1 (CS-NT), providing meaningful confidence that the result survives moderate violations of parallel trends.
- The "first period" (t=0) estimate is fragile — CI includes zero at Mbar=0 for both TWFE and CS-NT. This is expected for a gradual-implementation policy but should be noted.
- WARN issued because only 2 of 8 available pre-periods were used to calibrate the RM sensitivity bound; using all 8 would yield a more precise Mbar benchmark.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered adoption design with no dose heterogeneity and no treatment reversal. DCDH estimators add no diagnostic value beyond the CS-DID analysis already conducted.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF found at `pdf/9.pdf`; formal fidelity audit requires the PDF.
- Supplementary check via `metadata.original_result`: TWFE matches to 0.003% (EXACT); CS-DID gaps of 3.2%/2.4% are explained by package version differences documented in metadata notes.
- Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

---

## Rating computation

| Axis | Score | Basis |
|------|-------|-------|
| Methodology | M-MOD | 1 WARN (HonestDiD), 3 PASS (TWFE, CS-DID, Bacon), 1 NOT_NEEDED excluded |
| Fidelity | F-NA | paper-auditor NOT_APPLICABLE (no PDF) |
| **Combined** | **MODERATE** | M-MOD × F-NA → use methodology alone |

---

## Material findings (sorted by severity)

### WARN
- **HonestDiD n_pre=2 of 8 available**: The relative magnitudes sensitivity bound was calibrated using only 2 pre-periods despite 8 being in the event study. This under-utilises available variation and yields a less precise Mbar benchmark. The current bounds still support robustness of the avg/peak targets.
- **HonestDiD "first period" fragility**: The immediate treatment effect at t=0 (-0.057 for CS-NT) is not robustly distinguishable from zero under the RM method at Mbar=0. This is consistent with gradual implementation dynamics but limits causal claims about instant policy impact.
- **Cohort 205 positive TVU estimate**: The earliest-adopting cohort shows a positive treated-vs-untreated Bacon component (+0.047, weight=3.9%), contributing mild upward pressure on TWFE. Very low weight limits the impact.

---

## Recommended actions

- **Repo-custodian**: Update `analysis.event_pre` in metadata to confirm 8 pre-periods are being passed to the HonestDiD routine, or add an explicit `n_pre_honest` field to distinguish event-study pre-periods from HonestDiD calibration pre-periods. The current `honest_did_v3.csv` shows n_pre=2; re-run with n_pre=8.
- **Pattern-curator**: Consider adding a pattern documenting the HonestDiD n_pre underspecification issue — if the RM method in the R template defaults to 2 pre-periods regardless of `event_pre`, this will affect all articles with long pre-periods.
- **User (methodological)**: The gap between TWFE (-0.176) and CS-DID (-0.208 to -0.213) can be presented as evidence that TWFE understates the managed care effect by approximately 15–20% in this application. This finding strengthens the paper's conclusion rather than undermining it. No remedial action needed for the headline finding.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
