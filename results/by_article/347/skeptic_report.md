# Skeptic report: 347 — Courtemanche et al. (2025)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A — RCS data structure), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF)

## Executive summary

Courtemanche et al. (2025) study the effect of chain restaurant calorie posting laws on BMI using BRFSS data for counties around 5 treated metro areas (DC, NYC, Seattle, Philadelphia, Albany) over 1994–2012. The paper's headline TWFE ATT is -0.174 BMI units (SE = 0.081, p < 0.05 from Table 3, Column 1), which the replication matches to within 0.23% using the same county-specific linear trends specification. However, three methodological concerns jointly drive a LOW rating. First, CS-DID estimates are approximately 2.5x larger in magnitude than TWFE (CS-NT = -0.448, CS-NYT = -0.439), suggesting TWFE attenuation — most likely from county-specific linear trends absorbing genuine pre-treatment dynamics rather than from negative Bacon weights (timing comparisons constitute only 4.6% of the decomposition). Second, the RCS data structure means CS-DID is estimated on a collapsed county-year panel (44 of 89 counties, without individual controls), creating an estimand mismatch relative to TWFE. Third, HonestDiD finds the average ATT loses significance at any Mbar > 0 (D-FRAGILE), the first-period event-study estimate is sign-reversed (+0.105), and the peak ATT is fragile at Mbar = 0. The stored consolidated result of TWFE = -0.174 is numerically faithful to the paper, but the causal interpretation should be treated with caution given these three concurrent concerns.

## Per-reviewer verdicts

### TWFE (WARN)
- TWFE = -0.1744 matches paper Table 3 (-0.174) within 0.23%. Implementation is sound.
- CS-DID is 2.5x larger in magnitude, consistent with TWFE attenuation from county-specific linear trends (`fips[tt]`) absorbing treatment variation.
- County-specific linear trends introduce parametric sensitivity: if true effects are gradual, these controls can attenuate or contaminate the TWFE estimate.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT = -0.448 and CS-NYT = -0.439 are directionally consistent with TWFE but 2.5x larger in magnitude.
- CS-DID is estimated on a collapsed county-year panel without individual-level controls, creating an estimand mismatch relative to TWFE's conditional specification.
- Cohort 2009 is a near-singleton after panel balancing; the `did` package flags this, and the Bacon-proxy estimate for this cohort is an outlier (-0.692).

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Bacon decomposition requires a balanced panel; data structure is repeated cross-section.
- Informational decomposition on the county-year aggregate shows 95.4% TVU weight and minimal timing comparisons (4.6%). TWFE attenuation is not primarily driven by negative Bacon weights.
- TVU estimates range from -0.331 to -0.692, all directionally consistent with CS-DID.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- TWFE avg ATT: robust only at Mbar = 0 (CI = [-0.338, -0.028]); loses significance at Mbar = 0.25. D-FRAGILE.
- TWFE first-period ATT: CI = [-0.092, +0.303] at Mbar = 0 — positive and not significant. Sign-reversed relative to the headline estimate, suggesting delayed treatment onset.
- CS-NT avg/peak ATTs: D-FRAGILE at Mbar = 0; all break at Mbar = 0.25.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design. The de Chaisemartin-D'Haultfoeuille estimator adds no information beyond CS-DID for this specification.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- PDF not found at `pdf/347.pdf`. Fidelity axis is F-NA.
- Metadata documents TWFE EXACT MATCH (R = -0.1744 vs paper = -0.174, 0.23% gap). Informally: EXACT.

Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

## Material findings (sorted by severity)

- **WARN (HonestDiD — D-FRAGILE):** Average ATT loses significance at Mbar = 0.25; peak ATT not robust at Mbar = 0. The result is sensitive to even small violations of parallel trends.
- **WARN (HonestDiD — first-period sign reversal):** First post-period estimate in the event study is positive (+0.105 ATT), suggesting a delayed or gradual treatment response, not an immediate BMI reduction.
- **WARN (CS-DID — magnitude divergence):** CS-NT/CS-NYT are ~2.5x TWFE. The primary driver appears to be county-specific linear trends in TWFE absorbing genuine variation, not negative Bacon weights.
- **WARN (CS-DID — estimand mismatch):** RCS-to-panel collapse drops 45 counties and all individual controls; CS-DID identifies a different (unconditional, balanced-sample) parameter than TWFE.
- **WARN (TWFE — parametric sensitivity):** County-specific linear trends (`fips[tt]`) are a strong absorbing specification; the TWFE result is conditional on this parametric structure being correctly specified.
- **INFO (Bacon — cohort 2009 near-singleton):** After panel balancing, cohort 2009 (Seattle+Westchester) collapses to approximately 1 county with a full panel, making its cohort-specific ATT (-0.692) highly unreliable.

## Recommended actions

- **For the repo-custodian agent:** No metadata changes required. Implementation is faithful to the paper's specification.
- **For the pattern-curator:** Consider adding or cross-referencing a pattern for "county-specific linear trend absorption attenuates TWFE relative to CS-DID in staggered RCS designs." This parallels Pattern 25 (RCS composition effects) but the mechanism here is trend controls, not county dropout.
- **For the user (methodological judgement):** The calorie posting law effect on BMI appears directionally consistent across all estimators (all estimates negative), but the magnitude is uncertain. TWFE = -0.174 likely understates the true ATT given the trend control specification and CS-DID estimates of -0.44 to -0.45. The result is NOT robust to small pre-trend violations (HonestDiD D-FRAGILE). Before citing this result as definitive, consider: (a) whether county-specific linear trends are theoretically motivated or are an over-control that absorbs treatment effects, and (b) the delayed treatment onset pattern visible in the event study.
- **For the user:** The stored TWFE = -0.174 is the paper's preferred estimate and is reproduced exactly. The rating is LOW due to the confluence of three methodological concerns, not a single critical failure.

## Methodology score
**M-LOW** (3 WARNs on applicable methodology reviewers: twfe, csdid, honestdid; 0 FAILs; bacon NOT_APPLICABLE; dechaisemartin NOT_NEEDED)

## Fidelity score
**F-NA** (no PDF available; paper-auditor NOT_APPLICABLE)

## Combined rating
**LOW** (M-LOW × F-NA → use methodology score alone → LOW)

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
