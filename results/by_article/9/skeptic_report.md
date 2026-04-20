# Skeptic report: 9 -- Dranove et al. (2021)

**Overall rating:** MODERATE  *(Fidelity x Implementation: F-HIGH x I-MOD)*
**Design credibility:** MODERATE  *(separate axis -- finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (impl=PASS, TvT=21.5%), honestdid (impl=WARN, n_pre=2 of 8, Mbar_avg approx 0.5-1.0, Mbar_peak approx 0.75-1.0), dechaisemartin (NOT_NEEDED), paper-auditor (WITHIN_TOLERANCE, TWFE=EXACT)

---

## Executive summary

Dranove, Ody and Starc (2021) estimate the effect of Medicaid managed care adoption on log drug price per prescription using a staggered TWFE specification across 29 U.S. states over 26 quarters. The headline TWFE coefficient is -0.176 (SE=0.048), implying managed care reduces drug prices by approximately 16%. Our replication matches this to within 0.003% (effectively exact). Modern estimators (CS-NT: -0.208, CS-NYT: -0.213) agree on sign and are 15-20% larger in magnitude, consistent with mild upward contamination in TWFE from the later-vs-earlier-treated Bacon TVT component (21.5% of weight). Pre-trends are flat across all 8 pre-periods under both TWFE and CS-NT. HonestDiD shows the average and peak effects are robust to moderate pre-trend violations (Mbar_avg approximately 0.5-1.0), though our pipeline used only 2 of 8 available pre-periods for calibration -- a correctable implementation gap. The stored result (-0.176 TWFE, -0.208 CS-NT) is credible and trustworthy for meta-analytic purposes. Design credibility is MODERATE: the finding survives honest inference at moderate Mbar values.
---

## Per-reviewer verdicts

### TWFE (PASS)
- Specification matches original Stata code exactly; numerical match within 0.003%.
- Pre-trend pattern clean: all 8 pre-period coefficients within 1-2 SE of zero; largest is -0.069 at t=-9 (SE=0.062). [Design finding -- Axis 3]
- Post-treatment trajectory builds monotonically from -0.048 (t=0) to -0.259 (t=7) then plateaus -- consistent with gradual formulary implementation.
- Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- cs_controls=[] correctly applied: passing xformla=~exp in did v2.3.0 drops cohorts 205-216 -- correct avoidance documented as Pattern 42/26.
- base_period=universal applied per mandatory default (Pattern 26).
- CS-NT pre-trends cleaner than TWFE (max |coeff|=0.024 vs 0.069 at t=-9). [Design finding -- Axis 3]
- Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (PASS)
- TVU weight 78.5% -- identification majority from clean treated-vs-untreated comparisons; TVT share 21.5%, below 30% D-ROBUST threshold. [Design finding -- Axis 3]
- 9 of 10 cohorts show negative TVU estimates; cohort 205 (earliest, +0.047) contributes only 3.9% of weight. [Design finding -- Axis 3]
- TWFE undershoots CS-DID by approx 15%, consistent with mild upward TVT contamination.
- Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- Average effect robust through Mbar approx 0.5 (TWFE) and Mbar approx 1.0 (CS-NT); peak robust through Mbar approx 0.75 (TWFE) and 1.0 (CS-NT). [Design finding -- Axis 3]
- First-period (t=0) CI includes zero at Mbar=0 for both estimators -- consistent with gradual rollout. [Design finding -- Axis 3]
- Implementation WARN (Axis 2): n_pre=2 passed to HonestDiD despite 8 pre-periods available (event_pre=8). Re-running with n_pre=8 would yield more precise and likely higher Mbar bounds.
- Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered adoption; no dose heterogeneity, no reversal. DCDH adds no information beyond CS-DID.
- Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (WITHIN_TOLERANCE / TWFE=EXACT)
- PDF confirmed at pdf/9.pdf. TWFE matches paper Table 2 to 0.003% (EXACT). SE matches to 0.02%.
- CS-DID gap 3.2% (NT) / 2.4% (NYT): within tolerance; explained by did v2.3.0 cohort-dropping when xformla=~exp is passed -- documented in metadata; our no-controls spec is methodologically superior.
- Note: prior audit (2026-04-18) incorrectly reported PDF as absent; corrected in this run.
- Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

---

## Three-way controls decomposition

variables.twfe_controls = exp (non-empty) -- decomposition is relevant.

| Spec | TWFE | CS-DID NT | Status |
|------|------|-----------|--------|
| (A) both with controls | -0.176 (0.048) | -0.013 (0.014) | FAIL_overfit: Pattern 42 propensity-score collapse with single covariate |
| (B) both without controls | -0.186 (0.046) | -0.208 (0.053) | OK |
| (C) TWFE with, CS without | -0.176 (0.048) | -0.208 (0.053) | (headline, current default) |

Key ratios:
- Estimator margin, protocol-matched Spec B: (-0.186 - (-0.208)) / |-0.186| = +11.8% (TWFE undershoots CS-NT)
- Covariate margin, TWFE side: (-0.176 - (-0.186)) / |-0.176| = -5.7% (controls slightly shrink TWFE magnitude)
- Covariate margin, CS side: Spec A non-informative (Pattern 42 overfit); not computable
- Total gap, current headline Spec C: (-0.176 - (-0.208)) / |-0.176| = +18.2%

Interpretation: The TWFE-CS gap persists in the protocol-matched Spec B (11.8%), confirming that estimator choice -- not covariate handling -- drives the magnitude difference. Spec A collapses due to propensity-score overfit with a single continuous covariate (Pattern 42, Lesson 7). The unconditional Spec B CS-DID (-0.208) is the clean matched-protocol estimate for meta-analysis.

---

## Rating computation (3-axis framework)

| Axis | Score | Basis |
|------|-------|-------|
| Axis 1 -- Fidelity (paper-auditor) | F-HIGH | WITHIN_TOLERANCE: TWFE=EXACT, CS-DID within 3.2% with documented explanation |
| Axis 2 -- Implementation (methodology reviewers) | I-MOD | 1 WARN (HonestDiD n_pre=2 of 8); twfe/csdid/bacon PASS; dechaisemartin NOT_NEEDED excluded |
| Overall rating (Fidelity x Implementation) | MODERATE | F-HIGH x I-MOD |
| Axis 3 -- Design credibility (finding, not demerit) | D-MODERATE | Mbar avg: TWFE=0.5 (lower bound [0.5,1]), CS-NT=1.0 (ROBUST boundary); TvT=21.5% (<30%); pre-trends flat |

---

## Material findings (sorted by severity)

### Implementation WARN (Axis 2)
- HonestDiD n_pre underspecification: our pipeline passed n_pre=2 to the RM calibration despite 8 pre-periods available (event_pre=8). Current bounds (Mbar_avg approx 0.5 TWFE, 1.0 CS-NT) still support robustness, but re-running with n_pre=8 is recommended for more precise bounds.

### Design findings (Axis 3 -- informative, not demerits)
- Spec A collapse (Pattern 42): CS-DID with covariate exp collapses to -0.013 (vs -0.208 without), due to propensity-score overfit with a single continuous regressor in a balanced panel. Spec A is non-informative for this paper.
- TWFE Mbar_avg=0.5: the TWFE average effect becomes fragile at Mbar approx 0.5. CS-NT Mbar_avg=1.0 is more reassuring and should anchor the main design-credibility claim.
- TVT share 21.5%: present but below the 30% concern threshold; most TVT estimates are also negative, limiting net contamination.
- Cohort 205 anomaly: earliest adopter shows positive TVU estimate (+0.047, 3.9% weight) -- minor.

---

## Recommended actions

- Repo-custodian: Verify whether code/analysis/03_honest_did.R defaults to n_pre=2 regardless of event_pre. If so, add a metadata field (n_pre_honest=8) for article 9 and re-run HonestDiD with all 8 pre-periods. This is likely a systematic pipeline gap affecting all papers with event_pre > 2.
- Pattern-curator: Confirm Pattern 42 (propensity-score overfit in Spec A with single continuous covariate) is documented in knowledge/failure_patterns.md with Lesson 7 as cross-reference.
- User (methodological): The 15-20% TWFE-CS gap (TWFE undershoots) should be reported as a finding strengthening the conclusion -- modern estimators suggest the managed care effect may be somewhat larger than TWFE indicates. D-MODERATE design credibility is appropriate; the result survives honest inference at moderate Mbar values. No remedial action needed for the headline finding.

---

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
