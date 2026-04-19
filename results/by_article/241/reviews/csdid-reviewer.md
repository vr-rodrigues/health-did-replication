# CS-DiD Reviewer Report — Article 241 (Soliman 2025)

**Verdict:** PASS
**Date:** 2026-04-19
**Re-run reason:** Fix applied 2026-04-19 — cs_sample_filter='' now documented; cs_min_e=-3, cs_max_e=3 restrict dynamic aggregation to event window.

## Checklist

### 1. Comparison group
- CS-NT uses never-treated (gvar_CS == 0 → 2,911 counties) as control group. With 95 treated vs 2,911 never-treated, this is a deep and credible control group. PASS.
- CS-NYT also run; results closely track CS-NT (NT simple=-50.34, NYT simple=-50.42). Robustness confirmed. PASS.

### 2. Sample handling
- `cs_sample_filter = ""`: CS-DID runs on the FULL unbalanced 9-year panel. This is correct — running CS on the TWFE-filtered sample causes a `did` package C-code segfault (unbalanced panel with treated 4-7 years, never-treated 9 years triggers numerical instability). PASS.
- `cs_min_e = -3`, `cs_max_e = 3`: dynamic aggregation restricted to the paper's event window [-3, +3]. Dynamic ATTs now reflect the same event window as the TWFE event study. PASS.

### 3. Parallel trends and pre-testing
- Event study pre-periods (2 periods available, t=-1 normalised):
  - CS-NT: t=-3: -4.66 (SE=6.36), t=-2: +0.30 (SE=3.71). Neither significant at 5%. PASS.
  - CS-NYT: t=-3: -4.55 (SE=6.68), t=-2: +0.35 (SE=3.63). Also flat. PASS.

### 4. ATT aggregation (post-fix values)
- Simple (calendar-time) aggregation: CS-NT = -50.34 (SE=7.72); CS-NYT = -50.42 (SE=8.05).
- Dynamic (event-time) aggregation clipped to [-3,+3]: CS-NT = **-40.96** (SE=6.65); CS-NYT = **-41.06** (SE=7.48).
- The dynamic ATT (-40.96) is 30% larger in magnitude than TWFE (-31.52). Consistent with TWFE attenuating growing treatment effects (Lesson 8). PASS on methodology; flagged as Axis-3 design finding.
- Dynamic ATT is smaller than simple ATT (-50.34) because the simple aggregation is calendar-time weighted (later calendar years have more treated units experiencing later event-time horizons with larger effects).

### 5. Controls
- No controls in main CS spec (`cs_controls: []`), matching `twfe_controls: []`. Protocol-matched (Spec B: no controls on either side). PASS.
- `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"` correctly records that Spec A (with controls) is not applicable. PASS.

### 6. xformla handling
- `cs_controls = []` → xformla = ~1 (unconditional). Correct for a no-covariates design. PASS.

### 7. Sign and magnitude
- Both TWFE and CS-DID negative (DEA crackdowns reduce MME per capita). Direction consistent. PASS.
- CS-NT dynamic (-40.96) vs TWFE (-31.52): 30% gap. Explained by Lesson 8 (TWFE attenuation with growing effects). NOT an implementation error.

## Implementation findings
None.

## Design findings (Axis 3)
- The 30% magnitude gap between CS-NT dynamic and TWFE is a finding about the paper's design: TWFE attenuates the effect because treatment effects grow with event time (post-period coefficients escalate from -13.5 at t=0 to -61.0 at t=+3 for CS-NT). This confirms the standard Callaway-Sant'Anna critique of TWFE in growing-effect settings.

**Overall:** PASS
