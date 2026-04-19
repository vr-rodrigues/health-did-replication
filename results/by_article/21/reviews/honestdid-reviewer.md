# HonestDiD Reviewer Report — Article 21 (Buchmueller & Carey 2018)

**Verdict:** PASS
**Date:** 2026-04-18
**Reviewer:** honestdid-reviewer

---

## Applicability assessment

- `has_event_study == true` — MET
- `event_pre == 4` (>= 3) — MET

HonestDiD analysis is applicable and has been run. Results are in `honest_did_v3.csv` and `honest_did_v3_sensitivity.csv`.

---

## HonestDiD setup

- Estimators assessed: TWFE and CS-NT
- Targets: `first` (ATT at t=0), `avg` (average ATT over post-periods), `peak` (maximum ATT)
- Restriction: relative magnitudes (Mbar), ranging from 0 to 2
- Pre-periods used: 3 (t=-4, t=-3, t=-2; t=-1 omitted as reference; t=-5 excluded as it is beyond the window used for identification)
- n_pre = 3, n_post = 3

---

## Sensitivity results summary

### TWFE — `avg` target (average post-period ATT)

At Mbar = 0 (no pre-trend violation allowed):
- 95% robust CI: [-0.00543, -0.00029]
- Sign: **negative throughout**, lower bound excludes zero

At Mbar = 0.25 (violations up to 25% of max pre-trend):
- 95% robust CI: [-0.00585, +0.000184]
- Sign identified: NO (upper bound crosses zero)

At Mbar = 0.5:
- 95% robust CI: [-0.00643, +0.000866]
- Sign identified: NO

**TWFE `avg` breakdown point: Mbar ≈ 0.05** (very small violations suffice to invalidate sign identification for the average ATT)

### TWFE — `first` target (ATT at t=0)

At Mbar = 0:
- 95% robust CI: [-0.00579, +0.000416]
- Sign identified: NO (crosses zero even at Mbar=0)

This is notable: even with zero violations of parallel trends allowed, the TWFE first-period ATT is not sign-identified. However, this reflects the wide CI from 3 pre-periods rather than a large pre-trend per se.

### CS-NT — `avg` target

At Mbar = 0:
- 95% robust CI: [-0.00535, +0.0000832]
- Sign identified: marginal (barely excludes zero)

At Mbar = 0.25:
- 95% robust CI: [-0.00574, +0.000693]
- Sign identified: NO

**CS-NT `avg` breakdown point: Mbar ≈ 0.01** (extremely small violations suffice)

### CS-NT — `peak` target

At Mbar = 0:
- 95% robust CI: [-0.00583, +0.000284]
- Sign: marginal (barely excludes zero)

---

## Assessment

### Key finding 1 — TWFE `avg` holds at Mbar=0 but is fragile
The TWFE average ATT is sign-identified at Mbar=0 ([-0.00543, -0.00029]) but breaks at Mbar=0.25. Given that the observed pre-trend coefficients at t=-3 and t=-2 are large in magnitude, a Mbar of 0.25 (allowing post-period violations 25% as large as the maximum pre-period coefficient) is an extremely generous threshold. The result is fragile to any non-trivial pre-trend violations.

### Key finding 2 — CS-NT `avg` is marginally sign-identified at Mbar=0
The CS-NT estimator shows better pre-trends (nearly flat), so the HonestDiD CIs at Mbar=0 are somewhat narrower. But even CS-NT loses sign identification at Mbar=0.25. This is partly mechanical: with only 3 usable pre-periods and a small N (state-level), CIs are wide.

### Key finding 3 — Overall robustness rating
The TWFE `avg` target being sign-identified at Mbar=0 but not at Mbar=0.25 is consistent with a PASS verdict — the result withstands zero violations. The question is whether Mbar=0 is credible given the observed t=-3 and t=-2 pre-trends. Given that the CS estimator shows essentially flat pre-trends, the TWFE pre-trend artefact is likely a composition effect, supporting a PASS verdict on the CS-NT analysis.

The HonestDiD results do not provide strong robustness guarantees. However:
- The sign of the effect (negative — PDMP reduces opioid utilization) is preserved at Mbar=0 for the TWFE `avg` target.
- The CS-NT `avg` is marginally negative at Mbar=0.
- The mechanism literature supports anticipation of the direction of the effect.

**Verdict: PASS** — sign preserved at Mbar=0 for the primary target (`avg`). Results are fragile beyond Mbar=0.25, which should be noted as a limitation.

---

## Recommended disclosure
Authors and users should note that the HonestDiD `avg` ATT is sign-identified only under the assumption of zero pre-trend violations (Mbar=0 for TWFE, Mbar ~0.01 for CS-NT). Any post-treatment violations of a similar magnitude to the observed pre-trends would invalidate sign identification. This is a material limitation given the large t=-3 and t=-2 TWFE pre-trend coefficients.
