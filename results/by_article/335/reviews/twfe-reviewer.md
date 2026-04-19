# TWFE Reviewer Report — Article 335
# Le Moglie, Sorrenti (2022) — "Revealing 'Mafia Inc.'?"

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. Treatment variable specification
- Treatment variable: `crisis_mafia_n3_int` — a pre-computed interaction (mafia_n3 × post-crisis indicator). This is a standard DiD binary indicator encoding treatment as the interaction of group membership and post-period.
- Single cohort, single treatment date (2007). All treated units adopt simultaneously. This is the cleanest TWFE case — no heterogeneous timing, no staggered rollout.
- PASS: The treatment variable is correctly specified for a single-cohort DiD.

### 2. Fixed effects structure
- Unit FEs (province `id`) and time FEs (`year`) are implied by the TWFE regression.
- Additional macro-region × year interactions (`year_k_north`) are included as controls, capturing differential time trends for northern provinces. This is a well-motivated design choice given Italy's economic geography.
- PASS: FE structure is appropriate.

### 3. Control variable set
- 18 time-varying controls included: `pop_urb`, `tourism`, `trial`, `wastes_xc`, `big_banks`, `self_emp`, `blood`, `newspapers_ln`, and 10 north×year interaction dummies.
- TWFE controls are richer than CS controls (cs_controls = []). This asymmetry is common in practice but means CS estimates are unconditional on these covariates. Noted — does not fail TWFE itself.
- PASS: Controls appropriate for TWFE estimation.

### 4. Standard errors
- Paper uses Conley spatial HAC SEs (200km bandwidth, 11-year lag). Our replication uses clustered SEs at province level (cluster = id).
- Paper SE: 0.0107 (Conley). Our SE: 0.01274 (clustered). Our clustered SE is 19% larger than Conley — plausible given spatial correlation inflating cluster SEs relative to spatial SEs. Coefficients are identical.
- WARN-level discrepancy on SEs but this is expected and documented in metadata notes. Not a FAIL.
- PASS: Coefficient reproduced exactly (0.04053 vs 0.0405). SE difference is documented and expected.

### 5. Coefficient magnitude and plausibility
- beta_twfe = 0.04053. Implies a ~4% increase in new enterprise formation (ln scale) for mafia-exposed provinces after 2007.
- Effect is modest and consistent with economic theory (crisis creates entry opportunities for mafia-controlled capital).
- PASS: Magnitude plausible.

### 6. Event study pre-trends (TWFE)
- Pre-periods (t = -4 to -1): coefficients are -0.0073, -0.0024, 0.0070, 0 (reference).
- All pre-period coefficients small and near zero. Joint visual inspection suggests flat pre-trend.
- SE for pre-period coefficients: 0.0140, 0.0135, 0.0100 — pre-period estimates are all within ±1 SE of zero.
- PASS: No evidence of pre-trend violation in TWFE event study.

### 7. Post-period dynamics
- Post-period coefficients: 0.0145, 0.0250, 0.0227, 0.0351, 0.0375, 0.0380, 0.0310 — monotonically growing through period 5, then slight decline at period 6.
- Pattern consistent with gradual enterprise formation response to mafia infiltration post-crisis.
- PASS: Post-period dynamics plausible.

### 8. Sample size
- N = 924. With 84 provinces and 11 years (2003–2013), this is 84 × 11 = 924. Checks out perfectly.
- PASS.

## Summary
The TWFE estimation is clean and technically sound. Single-cohort DiD eliminates the heterogeneous treatment timing concerns that plague staggered designs. Pre-trends look flat. The SE difference (Conley vs. clustered) is expected and documented. Coefficient matches the paper exactly.

**Overall: PASS**
