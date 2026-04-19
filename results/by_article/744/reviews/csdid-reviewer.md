# CS-DID Reviewer Report — Article 744

**Article:** Jayachandran, Lleras-Muney & Smith (2010) — "Modern Medicine and the 20th Century Decline in Mortality"
**Reviewer:** csdid-reviewer
**Date:** 2026-04-18
**Verdict:** WARN

---

## Checklist

### 1. CS-DID applicability
- [PASS] CS-DID with never-treated comparison is applicable: TB group (gvar=0) serves as the clean never-treated control
- [PASS] `gvar_CS = 1937` for treated units (MMR disease), 0 for control (TB) — single cohort design
- [NOTE] With a single treatment cohort (all treated units adopt simultaneously in 1937), CS-DID collapses to a single ATT estimate. There is no heterogeneity across adoption cohorts to estimate or worry about.

### 2. Comparison group validity
- [PASS] Never-treated group is TB mortality — a distinct disease. Using disease-level control rather than geographic control is methodologically acceptable for this design (intended to isolate drug-specific mortality effects)
- [WARN] The validity of TB as a control for MMR hinges on the assumption that TB mortality trends would have continued to parallel MMR mortality trends absent sulfa drugs. TB was affected by different public health interventions (BCG vaccine, streptomycin development was later). However, the authors explicitly argue TB was not treated by sulfa drugs in this period, making it a valid control for common shocks.
- [NOTE] This is a design-level concern (cross-disease rather than cross-geography DiD), not a CS-DID implementation failure.

### 3. CS-DID estimates
- [PASS] `att_csdid_nt = -0.3332`, `se = 0.0260` — statistically significant, consistent in direction with TWFE (-0.281)
- [PASS] Simple aggregation equals dynamic aggregation (-0.3332 both), confirming single-cohort design where these must be identical
- [NOTE] CS-NT ATT is larger in magnitude than TWFE (-0.333 vs -0.281), which is expected when TWFE absorbs some of the treatment effect through the `treatedXyear_c` linear trend interaction control

### 4. Controls in CS-DID
- [FAIL] `att_cs_nt_with_ctrls = 0` (status: "OK" but value is 0). This appears to indicate that controls were not successfully incorporated into the CS-DID estimation, returning a null result. The with-controls estimate of exactly 0 is implausible and suggests a computational issue.
- [NOTE] The metadata specifies `cs_controls: []` (empty), so the CS-DID intentionally runs without additional controls. The `att_cs_nt_with_ctrls = 0` likely reflects that the template stored a placeholder value, not an actual estimation failure.

### 5. Pre-trend pattern in CS-NT
- [WARN] CS-NT event study pre-periods show the same monotonic drift as TWFE: t=-12: -0.261, t=-3: +0.030, t=-2: +0.038. This pre-trend drift persists in the CS-DID estimates, confirming it is a data feature rather than a TWFE artifact. With a single cohort there is no "clean" pre-treatment period comparison beyond using TB as counterfactual.

### 6. NYT comparison
- [PASS] `run_csdid_nyt = false` — correct, as treatment timing is single (1937), not staggered. There is no "not-yet-treated" group.

---

## Summary of concerns

| # | Severity | Finding |
|---|---|---|
| 1 | WARN | Cross-disease counterfactual (TB for MMR) is design-level validity concern |
| 2 | WARN | Pre-trend drift in CS-NT event study mirrors TWFE pattern |
| 3 | NOTE | `att_cs_nt_with_ctrls = 0` likely placeholder, not estimation failure |

The core CS-DID estimate (-0.333) is robust and directionally consistent with TWFE. Two WARNs on design validity and pre-trend. Verdict: **WARN**
