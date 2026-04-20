# Skeptic report: 347 -- Courtemanche et al. (2025)

**Overall rating:** HIGH  *(Fidelity x Implementation; upgraded from LOW on 2026-04-19)*
**Design credibility:** D-FRAGILE  *(separate axis -- a finding about the paper)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (NOT_APPLICABLE -- RCS, TvT=4.6pct), honestdid (impl=PASS, M_first=+0.105 sign-rev, M_avg_rm=0 breaks at Mbar=0.25, M_peak_rm=0), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT, 0.23pct)

**Rating upgrade note:** Prior report (2026-04-18) rated LOW under the pre-3-axis rubric, which conflated design findings with implementation failures. All WARNs in that report are Design findings (Axis 3), not Implementation failures (Axis 2). Correct framework: F-HIGH (EXACT 0.23pct) x I-HIGH = HIGH. Design credibility remains D-FRAGILE.

## Executive summary

Courtemanche et al. (2025) study the effect of chain restaurant calorie posting laws on BMI using BRFSS data for counties around 5 treated metro areas over 1994-2012. The paper headline TWFE ATT is -0.174 BMI units (SE=0.081, Table 3 Col 1), which our replication matches to 0.23pct (EXACT fidelity). Our reanalysis is technically clean: TWFE, CS-DID, and HonestDiD are all correctly implemented. The stored TWFE=-0.174 can be cited with confidence from a replication standpoint.

What our faithful reanalysis reveals about the paper design is a different matter. This paper is the 4th member of the Chapter 4 Lesson 2 amplification quartet (alongside 253 Bancalari, 267 Bhalotra et al., 241 Soliman): TWFE=-0.174 vs CS-NT=-0.448 (2.5x) vs CS-NYT=-0.439 (2.5x). The amplification is driven by county-specific linear trends (fips[tt]) absorbing treatment-period variation -- confirmed by the informational Bacon decomposition showing 95.4pct TvU weight (minimal forbidden comparisons, only 4.6pct). All three estimators agree on the negative sign; the magnitude uncertainty is a design-credibility finding. HonestDiD classifies the design as D-FRAGILE: average ATT loses significance at Mbar=0.25 for both TWFE and CS-NT, and the first post-period TWFE estimate is sign-reversed (+0.105), suggesting delayed treatment onset consistent with the behavioral mechanism.

The user should trust the stored TWFE=-0.174 as a faithful reproduction. The causal interpretation and true magnitude should be treated with caution given the D-FRAGILE design signal.

## Per-reviewer verdicts

### TWFE (impl=PASS)
- TWFE=-0.1744 matches paper Table 3 Col 1 (-0.174) within 0.23pct. Implementation clean: FE structure, controls, clustering, and monthly time variable correctly mirror the paper areg specification.
- Design finding: CS-DID is 2.5x larger in magnitude -- Lesson 2 attenuation mechanism. County-specific linear trends (fips[tt]) absorb pre-treatment variation that CS-DID attributes to treatment. A property of the paper specification, not a pipeline error.
- Direction unanimous: TWFE, CS-NT, and CS-NYT all negative.

Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (impl=PASS)
- CS-NT=-0.448 (SE=0.099), CS-NYT=-0.439 (SE=0.100). Correctly estimated on collapsed yearly county panel (44 of 89 counties with full balanced panel), appropriate method for RCS data.
- Custom 3-row schema (TWFE/CS-NT/CS-NYT) correctly documented as legacy_analysis=true; no Spec A because individual controls cannot pass through the RCS collapse.
- Design finding: 2.5x TWFE/CS-DID gap and cohort 2009 near-singleton are structural features of the paper data, not pipeline errors.

Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE -- informational TvT = 4.6pct)
- Formal Bacon not valid for RCS data structure. NOT_APPLICABLE on Axis 2.
- Informational decomposition on county-year aggregate: TvU weight=95.4pct, timing (forbidden) comparisons=4.6pct. Very clean.
- Design finding: TWFE attenuation NOT driven by negative Bacon weights (4.6pct timing share negligible). Mechanism is county-specific linear trends. TvU estimates range -0.331 to -0.692, all directionally consistent with CS-DID.

Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (impl=PASS -- design finding: D-FRAGILE)
- Computation correct: sensitivity table covers TWFE and CS-NT across first/avg/peak at Mbar=0 through 2.0.
- TWFE avg ATT: CI=[-0.338,-0.028] at Mbar=0 (marginally sig); loses significance at Mbar=0.25. rm_avg_Mbar in (0,0.25).
- TWFE first ATT: +0.105 (sign-reversed). CI at Mbar=0: [-0.092,+0.303]. Never significant for negative effect. Consistent with delayed treatment onset.
- TWFE peak ATT: CI at Mbar=0: [-0.891,+0.064]. Includes zero even with exactly parallel pre-trends.
- CS-NT avg: CI=[-0.640,-0.255] at Mbar=0 (sig); loses significance at Mbar=0.25. D-FRAGILE.
- CS-NT peak: CI=[-0.992,-0.350] at Mbar=0 (sig); loses significance at Mbar=0.25. D-FRAGILE.
- Design credibility: D-FRAGILE. Average and peak ATTs sensitive to any pre-trend violation (Mbar > 0).

Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design. No continuous dose, no time-varying treatment intensity.
- The de Chaisemartin-DHaultfoeuille estimator adds no information beyond CS-DID for this specification.

Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (EXACT)
- paper_audit.md (2026-04-19): stored TWFE=-0.17440 vs paper Table 3 Col 1=-0.174. Relative deviation=-0.23pct (< 1pct EXACT threshold). SE: 0.08077 rounds to paper 0.081. Fidelity axis: F-HIGH (EXACT).
- Note: prior reviews/paper-auditor.md (2026-04-18) returned NOT_APPLICABLE due to missing PDF. Superseded by paper_audit.md.

Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

## Three-way controls decomposition

N/A -- Spec A (TWFE with controls + CS-DID with controls) is not computable. The BRFSS RCS data structure prevents passing individual-level controls through the RCS-to-yearly-county-panel collapse required by CS-DID. cs_controls=[] and legacy_analysis=true are correctly documented. Only Spec C (TWFE with controls + CS-DID without controls) is available; headline TWFE=-0.174 is from this configuration.

This paper uses the custom 3-row schema (TWFE / CS-NT / CS-NYT). The estimator gap reflects a structural estimand difference (conditional with trend controls vs unconditional without trend controls) -- the Lesson 2 attenuation mechanism.

## Lesson 2 quartet context

This paper is the 4th member of the Chapter 4 Lesson 2 amplification quartet:

| Paper | TWFE | CS-DID | Ratio | Mechanism |
|---|---|---|---|---|
| 253 Bancalari (2024) | 0.737 | 1.79 (NYT) | 2.4x | Forbidden LvE comparisons; cohort2005 attenuates |
| 267 Bhalotra et al. (2022) | -0.082 | -0.112 (NT) | 1.4x | Late-cohort positive TVU; trend control absorption |
| 241 Soliman (2025) | -31.52 | -40.96 (NT) | 1.3x | Bacon TvT=1.3pct; clean but TWFE understates |
| 347 Courtemanche (2025) | -0.174 | -0.448 (NT) | 2.5x | Staggered 2008-2011 + county trend absorption |

Article 347 shows the strongest amplification ratio (2.5x) in the quartet. The informational Bacon decomposition confirms the mechanism is trend-control absorption (not negative weights): 95.4pct of TWFE weight falls on clean TvU comparisons, yet all TvU estimates (-0.33 to -0.69) are already 2-4x the TWFE, demonstrating that trend controls absorb substantial treatment variation.

## Material findings (sorted by severity)

**Design findings (Axis 3 -- about the paper, not our pipeline):**
- D-FRAGILE: TWFE average ATT loses significance at Mbar=0.25; sensitive to even small pre-trend violations.
- D-FRAGILE: First post-period TWFE estimate sign-reversed (+0.105); delayed treatment onset; peak ATT not significant even at Mbar=0.
- D-FRAGILE: CS-NT avg and peak ATTs equally fragile -- lose significance at Mbar=0.25.
- Lesson 2 amplification: CS-NT/CS-NYT are 2.5x TWFE. Mechanism confirmed as county-specific linear trend absorption (TvT=4.6pct, not negative Bacon weights).
- Cohort 2009 near-singleton after panel balancing: ATT estimate (-0.692) unreliable for this cohort.

**Implementation findings (Axis 2):** None. All applicable reviewers PASS on implementation.

## Recommended actions

- No implementation actions needed. Our reanalysis is technically clean. TWFE reproduced exactly, CS-DID correctly implemented for RCS, HonestDiD correctly computed.
- For the dissertation (Chapter 4 Lesson 2): Article 347 is the 4th quartet member with ratio 2.5x (strongest in quartet). The metadata notes field erroneously tags this as LESSON 8 in the 2026-04-19 audit note -- should be corrected to Lesson 2 amplification quartet.
- For the user (methodological judgement): Direction unanimous (all negative) but magnitude uncertain. TWFE=-0.174 likely understates the true ATT given trend-control absorption; CS-DID=-0.448 may overstate due to balanced-subsample composition. D-FRAGILE by HonestDiD standards. Whether county-specific linear trends are theoretically motivated or over-controlling is a substantive question for the paper authors.
- For the user: Stored TWFE=-0.174 is a faithful reproduction and can be cited from a replication standpoint. D-FRAGILE is a finding about the paper design, not about the quality of our reanalysis.

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
