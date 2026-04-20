# Skeptic report: 60 -- Schmitt (2018)

**Overall rating:** HIGH  *(built from Fidelity x Implementation)*
**Design credibility:** D-FRAGILE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS, design-WARN: pre-trend drift t=-4), csdid (impl=PASS), bacon (impl=PASS, TVU=93.8%), honestdid (impl=PASS, M_first_CS=0.25, M_avg=0, M_peak=0), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT, gap=0.25%)

## Executive summary

Schmitt (2018) estimates that multimarket contact among hospitals raises non-medical prices by approximately 7% (TWFE: beta=0.070, SE=0.017). Our reanalysis confirms this direction unanimously across all five estimators (TWFE, CS-NT, CS-NYT, SA, Gardner), with ATTs ranging 0.053-0.093 depending on specification. The paper-auditor now returns EXACT (gap=0.25%), upgrading the fidelity axis to F-HIGH. The implementation axis is also I-HIGH: all reviewer WARNs concern design properties of the paper (pre-trend drift at t=-4, HonestDiD fragility at Mbar=0.25), not errors in our pipeline. Under the three-axis framework -- which explicitly separates Fidelity x Implementation from Design Credibility -- the overall rating is **HIGH**. The design-credibility finding is **D-FRAGILE**: aggregate ATTs lose significance at Mbar=0.25 under HonestDiD, though the contemporaneous (first-period) CS-NT effect is more robust (M_first_CS=0.25). This paper is also the 6th canonical Spec A behavior documented in the Lesson 7 hexagon (Chapter 4 sec:spec_a_hexagon): 6 direct-level controls in a staggered panel produce an **AMPLIFY** pattern (+57% ATT magnitude, 0.059 to 0.093), contrasting with the COLLAPSE and INFLATE pathologies seen in other Spec A cases.

## Per-reviewer verdicts

### TWFE (impl=PASS; design-WARN)
- Specification faithfully matches Schmitt (2018): areg lnprnonmed post lncmi pctmcaid lnbeds fp hhi sysoth i.year [aw=dis_tot], absorb(h) cluster(h) if indirect==0. All elements reproduced: 6 controls, aweights, cluster by hospital, unit+year FE, sample filter. Implementation PASS.
- Pre-trend drift at t=-4 (coef=-0.059, t=-1.05) and t=-3 (coef=-0.026, t=-1.05): individually insignificant but representing 70-84% of ATT in magnitude. This is a **design finding** (Axis 3), not an implementation error.
- TWFE with vs. without controls: beta=0.0702 vs 0.0639 (10% gap); modest and expected.

Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (impl=PASS)
- CS-NT and CS-NYT unconditional ATTs (0.053) are 24.6% below TWFE (0.070), fully explained by controls: conditional CS-DID with 6 direct-level controls rises to 0.080-0.093, exceeding TWFE (AMPLIFY pattern, Lesson 7 sec:spec_a_hexagon).
- NT and NYT comparators agree within 0.4 pp -- no contamination from already-treated units.
- CS-NT pre-trends clean at conventional significance: all t-stats below |1.22|. Mild negative drift at t=-4/-3 consistent with TWFE (design signal, Axis 3).
- With-controls CS-DID status: OK for both NT and NYT. Convergence confirmed.

Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (impl=PASS, TVU=93.8%)
- TVU weight = 93.8%; forbidden (LvE/EvL) comparisons = 6.2%. The TWFE estimate is overwhelmingly identified from clean never-treated comparisons -- the best possible Bacon profile.
- TVU weighted mean = 0.053, matching CS-NT ATT exactly. Confirms TWFE staggered-adoption heterogeneity bias is negligible here.
- Three cohorts show negative TVU estimates (2007: -0.002, 2003: -0.012, 2010: -0.078) but combined weight is 19.0%; dominant cohorts 2000 (21.7% wt, +0.114) and 2001 (11.6% wt, +0.019) are positive. Note: metadata has run_bacon=false but bacon.csv was computed; reviewer used available data.

Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (impl=PASS; design=D-FRAGILE)
- CS-NT first-period ATT (att_first=0.044) is robust to Mbar=0.25 (CI=[+0.007, +0.079]): most credible single-number summary.
- TWFE and CS-NT average/peak ATTs lose significance at Mbar=0.25 for all estimators: D-FRAGILE for aggregate targets.
- Fragility driver: systematic negative pre-trend at t=-4/-3 (~-0.047 to -0.059) sets a baseline pre-trend magnitude that HonestDiD extrapolates into post-treatment periods. This is a **design finding** (Axis 3).
- M_first (CS-NT) = 0.25; M_avg = 0; M_peak = 0 (both TWFE and CS-NT).

Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design: treatment post is binary and irreversible. CS-DID fully covers this design. de Chaisemartin estimator adds no additional information.

Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (EXACT, gap=0.25%)
- Fidelity check: EXACT. Our stored beta_twfe=0.0702 reproduces the paper published TWFE coefficient within 0.25%. F-HIGH confirmed.
- Updated 2026-04-19 with original result extracted from Schmitt (2018). Previous run (2026-04-18) returned NOT_APPLICABLE due to missing PDF; now resolved.

Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

## Three-way controls decomposition

Paper has 6 non-empty twfe_controls (lncmi, pctmcaid, lnbeds, fp, hhi, sysoth). All three specs from the template are available.

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | 0.0702 (SE=0.0172) | 0.0804 (SE=0.0216) | OK -- AMPLIFY |
| (B) both without controls | 0.0639 (SE=0.0166) | 0.0529 (SE=0.0198) | OK |
| (C) TWFE with, CS without (prior default) | 0.0702 (SE=0.0172) | 0.0529 (SE=0.0198) | -- (headline) |

Key ratios:
- Estimator margin (protocol-matched, Spec A): (0.0702 - 0.0804) / |0.0702| = -14.5% (CS-DID marginally above TWFE with matched controls; sign flip from headline gap)
- Covariate margin (TWFE side): (0.0702 - 0.0639) / |0.0702| = +9.0%
- Covariate margin (CS side): (0.0804 - 0.0529) / |0.0804| = +34.2%
- Total gap (headline, Spec C): (0.0702 - 0.0529) / |0.0702| = +24.6%

Verbal interpretation: Matching the control protocol (Spec A) almost entirely closes the TWFE vs. CS-DID gap -- the 24.6% headline gap collapses to -14.5% (sign flips; CS-DID marginally exceeds TWFE) -- confirming that the original gap was driven by the control-specification mismatch, not by estimator choice or staggered-timing heterogeneity. This is the canonical AMPLIFY pattern: 6 direct-level controls in a staggered panel cause CS-DID to overshoot TWFE by 14.5% rather than collapse. The covariate margin on the CS side (+34.2%) far exceeds the TWFE side (+9.0%), producing the AMPLIFY dynamic. Documented as the 6th canonical Spec A behavior in Lesson 7 (Chapter 4 sec:spec_a_hexagon), contrasting with COLLAPSE (papers 79, 335, 358, 47) and INFLATE (paper 125).

This decomposition feeds Deliverable D1 of the QJE review (Sant'Anna, 2026-04-17).

## Material findings (sorted by severity)

### Design findings (Axis 3 -- findings about the paper, not demerits against our reanalysis)

- [D-FRAGILE -- HonestDiD] Aggregate ATTs fragile at Mbar=0.25. Both TWFE and CS-NT average/peak ATTs lose statistical significance when parallel trends is allowed to deviate by 0.25 Mbar units per period. Only the first-period CS-NT ATT survives to Mbar=0.25 (CI=[+0.007, +0.079]). Direction (positive price effect of multimarket contact) is robust; magnitude is fragile.
- [Design signal -- pre-trends] Negative drift at t=-4 and t=-3. TWFE (-0.059, t=-1.05) and CS-NT (-0.047, t=-1.22) show consistent downward pre-trend at t=-4, representing 70-84% of ATT in magnitude. Individually insignificant, jointly suggestive. Direct cause of HonestDiD fragility.

### Implementation notes (no failures or warnings)
- All implementation checks PASS across twfe, csdid, bacon, and honestdid reviewers. No remedial action required on our pipeline.

## Recommended actions

- No remedial action needed on implementation: rating is HIGH on Fidelity x Implementation axes. The pipeline is correct and the paper estimate is reproduced exactly.
- For the dissertation (Chapter 4 sec:spec_a_hexagon): Document this as the AMPLIFY case in the Lesson 7 hexagon. Key numbers: Spec A TWFE=0.070, Spec A CS-NT=0.080 (gap closes from +24.6% to -14.5%); covariate margin CS-side +34.2% vs TWFE-side +9.0%. Contrast with COLLAPSE papers (79, 335, 358, 47) and INFLATE paper (125). Intermediate count of 6 direct-level controls in staggered panel is the distinguishing feature.
- For the dissertation (D-FRAGILE disclosure): Report HonestDiD D-FRAGILE classification alongside the HIGH implementation rating. Direction unanimous across all 5 estimators (0.053-0.093 log points). The contemporaneous CS-NT effect (M_first=0.25, CI=[+0.007, +0.079]) is the most credible single summary.
- For the repo-custodian: Update paper-auditor.md for article 60 to reflect the updated EXACT verdict (gap=0.25%) replacing the prior NOT_APPLICABLE from 2026-04-18. Populate metadata original_result with the extracted numeric value to make the EXACT verdict self-documenting for future runs.
- For the repo-custodian: Confirm whether run_bacon should be updated to true in metadata, given that bacon.csv already exists with valid data.

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
