# Skeptic report: 744 -- Jayachandran et al. (2010)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Jayachandran, Lleras-Muney & Smith (2010) estimate the effect of the 1937 introduction of sulfa drugs on mortality from sulfa-treatable diseases (MMR) versus tuberculosis as control, using a cross-disease DiD on state-level mortality data 1925-1943. The headline TWFE estimate is -0.281 log-points (se=0.108). CS-DID (never-treated) yields ATT=-0.333 (se=0.026). All estimators agree on direction and approximate magnitude. Three methodological concerns collectively warrant LOW rating: (1) TWFE uses a non-standard statepost FE absorbing structure with a parametric linear trend control -- the estimate flips to +13.6 without controls, making the result entirely dependent on functional-form assumptions; (2) strong monotonic pre-trend drift over 12 pre-years in both TWFE and CS-NT event studies is a material threat to parallel trends; (3) HonestDiD shows CS-NT average ATT is only robust to Mbar=0.50. The fidelity axis cannot be evaluated (no PDF). The conclusion is directionally supported by CS-DID but is parameter-dependent and should be treated with caution.

## Per-reviewer verdicts

### TWFE (WARN)
- Non-standard statepost FE (state x post-period dummies) absorbing structure -- closer to triple-differences than canonical unit+time TWFE.
- Catastrophic control sensitivity: beta_twfe_no_ctrls=+13.616 vs beta_twfe=-0.281; sign flips and magnitude explodes when trend controls removed.
- Monotonic pre-trend drift in event study (t=-12: -0.259 to t=-3: +0.013) signals pre-existing differential trends between MMR and TB.

Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT ATT=-0.333 (se=0.026), consistent direction with TWFE; single cohort (1937) so no heterogeneity across adoption dates.
- Cross-disease counterfactual (TB for MMR) is a design validity concern -- TB had its own disease-specific trends.
- Pre-trend drift in CS-NT event study mirrors TWFE -- a data feature, not a TWFE artifact.

Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Single treatment cohort (1937); Bacon decomposition requires staggered adoption timing. run_bacon=false is correct.

Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- TWFE sensitivity: rm_first_Mbar=1.0, rm_avg_Mbar=0.75, rm_peak_Mbar=1.0.
- CS-NT sensitivity (binding constraint): rm_first_Mbar=1.0, rm_avg_Mbar=0.50, rm_peak_Mbar=0.75.
- Strong monotonic pre-trend slope (~0.022 log-pts/year over 12 pre-years) makes Mbar thresholds practically meaningful.

Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary single-cohort design; DChDH heterogeneity corrections not applicable.
- CS-DID already recovers the single group-time ATT correctly.

Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF at pdf/744.pdf; original_result field in metadata is empty. Fidelity axis cannot be evaluated.

Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

## Material findings (sorted by severity)

- [WARN -- TWFE] Extreme control sensitivity: estimate flips sign (+13.6 vs -0.28) without trend controls; entire result depends on the linear trend adjustment assumption.
- [WARN -- TWFE] Non-standard statepost FE deviates from canonical TWFE; idiosyncratic specification that the modern DiD template does not replicate natively.
- [WARN -- TWFE/CS-DID] Strong monotonic pre-trend drift across 12 pre-periods in both TWFE and CS-NT event studies.
- [WARN -- HonestDiD] CS-NT average ATT robust only to Mbar=0.50; moderate post-treatment violations would overturn result.
- [WARN -- CS-DID] Cross-disease comparison validity depends on TB being a clean counterfactual for MMR mortality trends.

## Recommended actions

- For the repo-custodian agent: Populate original_result in data/metadata/744.json with Table 4 Panel B Column 1 value once PDF is available, to enable fidelity verification.
- For the repo-custodian agent: Assess whether twfe_fe_override=statepost faithfully replicates Stata absorb(statepost); consider adding a canonical unit+time FE version as a robustness check alongside the paper-spec version.
- For the user (methodological judgement): The entire result rests on the parametric linear trend control (treatedXyear_c). Examine whether the approximately linear pre-trend pattern justifies this functional form and whether the authors defend it adequately in the paper.
- For the pattern-curator: Add new pattern to knowledge/failure_patterns.md -- cross-disease DiD with diverging pre-trends repaired by parametric trend control; document the statepost FE absorb pattern as distinct from standard unit+time TWFE.
- For the user: LOW rating reflects fragility of parametric assumptions, not evidence the paper is wrong. Direction and approximate magnitude are confirmed by CS-DID. Interpret as conditional on trend-adjustment validity.

## Individual reports

- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)

## Methodology score detail

| Reviewer | Verdict | Counted? |
|---|---|---|
| twfe-reviewer | WARN | Yes |
| csdid-reviewer | WARN | Yes |
| bacon-reviewer | NOT_APPLICABLE | No |
| honestdid-reviewer | WARN | Yes |
| dechaisemartin-reviewer | NOT_NEEDED | No |
| paper-auditor | NOT_APPLICABLE | Fidelity axis only |

Methodology: 3 WARN, 0 FAIL -- M-LOW
Fidelity: NOT_APPLICABLE -- F-NA
Combined (F-NA uses methodology alone): **LOW**

HonestDiD design credibility signal: **D-FRAGILE** (CS-NT rm_avg_Mbar=0.50; TWFE rm_avg_Mbar=0.75)
