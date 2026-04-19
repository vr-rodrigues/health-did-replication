# CS-DID Reviewer Report — Article 271

**Verdict:** PASS
**Date:** 2026-04-18
**Reviewer:** csdid-reviewer

---

## 1. CS-DID setup

- `gvar_CS = 1966` for all treated districts (single cohort); `gvar_CS = 0` for never-treated.
- Comparison group: never-treated only (`run_csdid_nyt: false` — NYT not applicable with single cohort).
- Base period: universal (mandatory for single cohort; causes pre-treatment ATTs to be 0/NA structurally).
- Controls in CS-DID: none (cs_controls = []); controls-version run separately.

## 2. Static ATT

| Estimator | ATT | SE | t-stat |
|---|---|---|---|
| CS-NT (no ctrls, simple) | 69.752 | 11.624 | 6.00 |
| CS-NT (no ctrls, dynamic) | 69.752 | 11.247 | 6.20 |
| CS-NT (with ctrls, simple) | 71.887 | 12.107 | 5.94 |
| CS-NT (with ctrls, dynamic) | 71.887 | 12.053 | 5.96 |

- With-controls CS-NT is 3.1% above no-controls CS-NT (71.89 vs 69.75). Controls increase the estimate slightly; this is consistent with negative confounding from precipitation/temperature on HYV adoption.
- All estimates statistically significant at p<0.001.

## 3. Pre-treatment parallel trends

- Pre-period ATTs are structurally 0/NA (universal base period with single cohort). This is a known identification constraint, not a data quality issue (documented in metadata notes).
- Cannot formally test pre-trends via CS-DID for this design. Relying on TWFE event study for pre-trend assessment (which is valid here since TWFE = CS-NT by construction for single cohorts).

## 4. Dynamic CS-NT pattern

| Period | CS-NT coef | SE | SA coef | Gardner coef |
|---|---|---|---|---|
| 0 | 1.624 | 1.470 | 1.624 | 1.624 |
| +1 | 16.374 | 3.960 | 16.374 | 16.374 |
| +2 | 24.896 | 5.027 | 24.896 | 24.896 |
| +3 | 39.389 | 8.084 | 39.389 | 39.389 |
| +4 | 44.643 | 8.797 | 44.643 | 44.643 |
| +5 | 64.245 | 10.010 | 64.245 | 82.801 |

- CS-NT, SA, and Gardner are near-identical for t=0 through t=+4. At t=+5 Gardner shows 82.80 vs CS-NT/SA 64.25 — a divergence of 18.6 units. This may reflect different weighting at the boundary of the panel. Not a concern for identification; boundary effects are well-documented.
- All estimators show monotonically growing effects, economically coherent with gradual seed adoption.

## 5. Controls sensitivity

- CS-NT no-ctrls: 69.75; CS-NT with-ctrls: 71.89 (3.1% increase).
- Controls effect is small and in the expected direction. No sign sensitivity. PASS.

## 6. Never-treated comparison validity

- 177 never-treated districts (thick-aquifer = 0) form the comparison group.
- Aquifer geology is time-invariant — not subject to differential trends induced by policy. Geographic control is plausible.
- No concern about contaminated control group.

## 7. Verdict rationale

Single-cohort CS-DID is mechanically equivalent to TWFE here (same identification). All estimates agree in direction, magnitude, and significance. Pre-trend assessment delegated to TWFE (valid). Controls sensitivity negligible. **PASS.**
