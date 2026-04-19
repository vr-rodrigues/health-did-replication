# Skeptic report: 271 — Sekhri, Shastry (2024)

**Overall rating:** HIGH
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (PASS), bacon (NOT_APPLICABLE), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Sekhri and Shastry (2024), published in AEJ: Applied Economics, estimate the causal effect of the Green Revolution (post-1966 high-yielding variety seed adoption) on agricultural outcomes across 271 Indian districts over 32 years (1956–1987). The headline TWFE result is beta = 67.81 (SE = 11.86, t = 5.72), representing a large and highly significant increase in total HYV crop area for districts with thick aquifers (the first-stage agricultural effect enabling the paper's downstream health analysis). This is one of the cleanest designs in the audit sample: single treatment timing (1966) with 94 treated districts against 177 never-treated controls identified by time-invariant geology. All three applicable methodology reviewers pass without qualification. TWFE, CS-NT, SA, and Gardner produce near-identical ATT estimates (67.8–71.9 for static; convergent dynamic paths for t=+1..+4). HonestDiD finds the average and peak effects are D-ROBUST, surviving intact at Mbar=2.0. The stored consolidated result of 67.81 is fully trustworthy as a causal estimate of Green Revolution adoption intensity on HYV crop area.

---

## Per-reviewer verdicts

### TWFE (PASS)

- TWFE beta = 67.81 (t = 5.72), highly significant; controls reduce estimate by only 2.7% (69.75 → 67.81), confirming robustness to specification.
- Pre-trends are economically flat: maximum pre-period coefficient is 2.86 (t=-5), representing 3.5% of the peak post-treatment effect of 82.
- Post-treatment path grows monotonically (3.0, 15.9, 25.0, 39.4, 45.6, 82.2) — economically coherent with gradual seed adoption after 1966.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)

- CS-NT (no controls) = 69.75, exactly matching TWFE-no-controls — expected for single-cohort design (CS-DID collapses to Treated vs Never-Treated comparison).
- CS-NT with controls = 71.89 (3.1% above baseline), consistent direction; controls sensitivity negligible.
- SA and Gardner produce near-identical dynamic estimates through t=+4; t=+5 boundary divergence (Gardner=82.8 vs CS-NT=64.2) is a known edge effect, not a concern.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- Single treatment cohort (1966). Bacon.csv confirms one pair: Treated(1966) vs Never-Treated, weight=1.0. No forbidden comparisons. Staggered-timing bias absent by design.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS)

- Average ATT robust to Mbar=2.0 (CI=[9.09, 32.33] — entirely positive). D-ROBUST.
- Peak ATT (t=+3) robust to Mbar=2.0 (CI=[17.80, 60.71] — entirely positive). D-ROBUST.
- First-period ATT (t=0, coef=3.02) loses significance at Mbar=0.75 (D-MODERATE), but this is economically expected — seed adoption in year zero of the Green Revolution was minimal.
- CS-NT HonestDiD infeasible (universal base period with single cohort); TWFE-only analysis is appropriate and sufficient given TWFE = CS-NT by construction.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Treatment is binary and absorbing (1966 adoption, no switching off). Single cohort. No continuous dose or heterogeneous treatment intensity concerns.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

---

## Material findings (sorted by severity)

No FAIL items.

**WARN items:** None.

**Informational notes (not scored as WARNs):**

- First-period HonestDiD is D-MODERATE (rm_first_Mbar=0.50). This is structurally expected for a growing-effect design where t=0 captures only initial adoption; not a methodological concern.
- CS-NT HonestDiD was infeasible due to universal base period (single cohort). TWFE HonestDiD is adequate and the two estimators are equivalent here.
- The health outcomes in the paper (child height/weight from IHDS/NFHS data, Table 9) use restricted data not in the replication package. Only the agricultural first-stage (Table 3, Col 2) is replicable. This is a data access limitation, not a methodological concern.
- PDF not available for formal paper-auditor fidelity audit; metadata-encoded reference confirms exact replication (67.8101 vs 67.81, difference = 0.0001, 0.00015%).

---

## Recommended actions

- No action needed. The stored result (TWFE = 67.81) is a well-identified causal estimate from a clean single-cohort design, confirmed by all applicable estimators and robust to pre-trend violations up to Mbar=2.0 on the avg/peak targets.
- Optional: If the restricted IHDS/NFHS health data becomes available, extend the audit to the downstream health outcomes (Table 9) which are the paper's primary contribution.

---

## Methodology and fidelity scores

| Axis | Score | Basis |
|---|---|---|
| Methodology | M-HIGH | twfe=PASS, csdid=PASS, honestdid=PASS; bacon=N/A; dcm=NOT_NEEDED |
| Fidelity | F-NA | No PDF available; metadata-encoded reference shows EXACT match |
| **Final rating** | **HIGH** | M-HIGH × F-NA → use methodology alone |

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
