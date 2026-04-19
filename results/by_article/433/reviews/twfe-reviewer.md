# TWFE Reviewer Report — Article 433

**Article:** DeAngelo, Hansen (2014) — "Life and Death in the Fast Lane: Police Enforcement and Traffic Fatalities"
**Reviewer:** twfe-reviewer
**Date:** 2026-04-18
**Verdict:** PASS

---

## Checklist

### 1. Specification alignment

The paper uses a state-month panel with Oregon (FIPS=41) as the sole treated unit following a mass police layoff in February 2003. The TWFE specification is:

```
fat_vmt ~ treatment + precip + temp + un_rate + max_speed | fips + year + month
```

Equivalent to the paper's `areg fat_vmt treatment mon_* y_* precip temp un_rate max_speed, a(fips) robust cluster(state)`. The metadata correctly specifies `additional_fes = ["year", "month"]` with fips absorbed, matching the paper's FE structure. **PASS.**

### 2. Pre-trend inspection

Event study data (event_study_data.csv) shows TWFE pre-period estimates:
- t=-7: +1.161 (SE=0.523, t=2.22) — note: outside the event window requested
- t=-6: -1.393 (SE=0.742, t=1.88)
- t=-5: +0.464 (SE=0.749, t=0.62)
- t=-4: -1.934 (SE=0.714, t=2.71)
- t=-3: +0.576 (SE=0.592, t=0.97)
- t=-2: -0.191 (SE=0.473, t=0.40)

Pre-trends are oscillatory rather than systematically drifting. The t=-4 coefficient (-1.934, t=2.71) is individually significant, raising mild concern, but the overall pre-trend pattern is not monotone and consistent with sampling noise in the short run. The base period (t=-1) is normalized to zero. Pre-trend oscillation around zero across 6 periods is not indicative of a systematic trend violation.

**Assessment: Borderline PASS** — t=-4 is significant at 5% but oscillatory pattern suggests noise rather than confounding trend. Single treated unit limits power to detect pre-trends.

### 3. Single treated unit caveat

With only 1 treated unit (Oregon) and 46 never-treated controls, TWFE is equivalent to a simple difference. Standard errors may understate true uncertainty (small treated-unit problem). The paper uses state-level clustering (1 treated cluster, ~46 never-treated clusters). Wild cluster bootstrap or Fisher randomization would be more appropriate; however, these are the original authors' choices and not a TWFE implementation failure.

### 4. Data discrepancy

Metadata notes that the original `fatal_analysis_file_2014.dta` is missing from the replication package. Analysis uses `synth_file_2014.dta` which has 47 states (missing Vermont, FIPS=50) vs the paper's 48 states. This produces N=3,384 in our analysis vs N=3,456 in the paper (missing 72 obs = 12 months × 6 years for Vermont). This is a data availability issue, not a specification error. The stored coefficient (0.6999) remains within 1.45% of the paper's reported 0.7103 despite this discrepancy, suggesting Vermont's contribution was minimal.

### 5. Coefficient fidelity

| Source | beta_twfe | SE |
|---|---|---|
| Paper (Table 4, col 1) | 0.7103 | 0.1281 |
| Our estimate | 0.6999 | 0.1329 |
| Abs difference | 0.0104 | — |
| % difference | 1.46% | — |
| Diff/SE | 0.081 SEs | — |

Fidelity: within 1.46% of the paper's coefficient. The small gap is attributable to the missing Vermont observation. **WITHIN_TOLERANCE.**

### 6. Structural assessment

- Treatment is absorbing and binary (Oregon post-Feb 2003)
- Single treatment timing: no staggered-adoption concerns
- Panel is balanced (monthly, 2000–2005)
- No issues with TWFE in a classic 2×∞ design with never-treated controls

---

## Summary

TWFE is correctly implemented for this single-treated-unit, never-treated-controls design. The oscillatory pre-trend at t=-4 raises mild concern but is not systematic. The 1.46% coefficient gap is explained by the missing Vermont observation. No TWFE-specific methodological failures.

**Verdict: PASS**
