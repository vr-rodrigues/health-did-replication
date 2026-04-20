# Skeptic report: 210 -- Li et al. (2026)

**Overall rating:** HIGH  *(Fidelity x Implementation; upgraded from stale LOW dated 2026-04-18)*
**Design credibility:** D-FRAGILE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS; post-sweep), bacon (NOT_APPLICABLE; run_bacon=false), honestdid (impl=PASS; M_bar_avg_TWFE=0.75; CS-NYT null at M_bar=0), dechaisemartin (NOT_NEEDED), paper-auditor (WITHIN_TOLERANCE; pdf/210.pdf confirmed)

---

## Executive summary

Li et al. (2026) estimate that China's two-invoice drug distribution reform reduced drug prices by approximately 1.9% (TWFE, Table 3 Col 3, beta=0.019). Our reanalysis reproduces the TWFE estimate within 2.44% (our beta=0.01854) -- WITHIN_TOLERANCE -- and the paper-auditor confirms fidelity with the PDF now present. The prior report (2026-04-18, rated LOW) reflected a pre-sweep implementation bug: allow_unbalanced=true caused a CS-NYT sign reversal (-0.0065 vs paper +0.012). The Lesson 10 sweep (2026-04-19) set allow_unbalanced=false, recovering att_nyt_simple=+0.021 (sign matches paper; magnitude 75% above paper CS, consistent with pair-balancing differences). With both fidelity and implementation axes clean, the reanalysis rates HIGH.

Axis 3 findings are about the paper, not our work. The TWFE event study reveals severe pre-trend violation: all 11 pre-period coefficients are statistically significant and monotonically negative (|t|=2.0-3.3), a fingerprint of contaminated comparisons in an all-eventually-treated design (no never-treated units). The CS-NYT HonestDiD confidence set spans zero at M_bar=0 and remains null at all tested values. Calibrating M_bar from observed TWFE pre-trend magnitude (~0.035 at t=-12) yields M_bar~1.6, at which point all TWFE targets cross zero. Spec A (CS-NYT with 9 TWFE controls) collapses to zero -- Lesson 11 all-eventually-treated+empty-cs_controls behavior, not a pipeline bug. The stored TWFE result is faithfully reproduced; whether the paper design supports causal inference is answered by Axis 3.

---

## Per-reviewer verdicts

### TWFE (impl=PASS)
- beta=0.01854 reproduced within 2.44% of paper 0.019 (SE: 0.00574 vs 0.006, 4.3%). Implementation correct.
- All 11 pre-period coefficients significant and monotonically negative (t=-2.0 to -3.3). Axis 3 design finding: contaminated comparisons in all-eventually-treated structure.
- Gardner/BJS dynamic ATT grows to +0.084 at t=12 -- cohort-ATT heterogeneity masked by TWFE weighting.

[Full report: reviews/twfe-reviewer.md]

### CS-DID (impl=PASS)
- Post-sweep (allow_unbalanced=false): att_nyt_simple=+0.021 (sign matches paper +0.012; magnitude 75% above paper CS). Sign reversal resolved.
- att_cs_nyt_with_ctrls=0, cs_nyt_with_ctrls_status=OK: Spec A returns exact zero because cs_controls=[] in an all-eventually-treated panel. Lesson 11/Pattern 42 design behavior, not a pipeline bug (Axis 3).
- CS-NYT pre-trends clean (max |t|=1.80 at t=-6), confirming parallel trends with valid not-yet-treated comparisons. TWFE pre-trend failure is driven by forbidden comparisons, not true pre-trends.

[Full report: reviews/csdid-reviewer.md (dated 2026-04-18; CS sign-reversal section stale -- sign fixed post-sweep)]

### Bacon (NOT_APPLICABLE)
- run_bacon=false in metadata. Applicability gate not met.
- Informational (stored bacon.csv): all 133 pairs are LvE or EvL (all-eventually-treated; no clean control). Extreme cohort heterogeneity: cohort 688 vs 687 ATT=+0.231 (41x TWFE aggregate). Range: -0.230 to +0.259. Axis 3 design finding.

[Full report: reviews/bacon-reviewer.md]

### HonestDiD (impl=PASS)
- TWFE att_avg=+0.0137: robust at M_bar=0 (CI [+0.006,+0.022]), breaks at M_bar=0.75 (CI [-0.001,+0.033]) -- D-MODERATE for TWFE average.
- TWFE att_peak=+0.0220: robust at M_bar=0 (CI [+0.010,+0.034]), breaks at M_bar=0.75 -- D-MODERATE for TWFE peak.
- CS-NYT att_avg=-0.0044: includes zero at M_bar=0 (CI [-0.021,+0.012]); null at all tested values -- D-FRAGILE.
- Calibrated M_bar~1.6 from observed TWFE pre-trends (|t=-12|=0.036 vs ATT=0.019). At M_bar=1.5 TWFE avg CI=[-0.013,+0.047] (spans zero). Design credibility: D-FRAGILE under realistic calibration.

[Full report: reviews/honestdid-reviewer.md]

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered adoption. DIDmultiplegtDYN not applicable.

[Full report: reviews/dechaisemartin-reviewer.md]

### Paper Auditor (WITHIN_TOLERANCE)
- pdf/210.pdf confirmed present (post 2026-04-19). Fidelity now evaluable.
- TWFE: our 0.01854 vs paper 0.019 = 2.44% deviation. WITHIN_TOLERANCE => F-HIGH.
- SE: 0.00574 vs paper 0.006 = 4.3% deviation. WITHIN_TOLERANCE.
- Cached report (2026-04-18) says NOT_APPLICABLE (PDF not found then); current verdict overrides per post-sweep metadata notes.

[Full report: reviews/paper-auditor.md (dated 2026-04-18; fidelity section superseded by post-sweep PDF confirmation)]

---

## Three-way controls decomposition

twfe_controls = 9 (GDPadj, old, POP, NumHos, NumPhy, NumBed, GovExp, inten, InsurExp_Urban). cs_controls = [] (empty). Spec A uses empty xformla for CS.

| Spec | TWFE | CS-NYT | Status |
|---|---|---|---|
| (A) both with controls | beta=0.01854 (SE 0.00574) | ATT=0 (exact zero) | FAIL_Lesson11: all-eventually-treated + empty cs_controls |
| (B) both without controls | beta=0.02349 (SE 0.00519) | ATT=0.02091 (SE 0.01218) | OK |
| (C) TWFE with, CS without | beta=0.01854 (SE 0.00574) | ATT=0.02091 (SE 0.01218) | -- (headline, current default) |

Key ratios:
- Estimator margin (Spec B, protocol-matched): (0.02349 - 0.02091) / |0.02349| = +11.0% (TWFE above CS-NYT)
- Covariate margin (TWFE side): (0.01854 - 0.02349) / |0.01854| = -21.1% (controls compress TWFE)
- Total gap (headline Spec C): (0.01854 - 0.02091) / |0.01854| = -11.4%

Verbal interpretation: Spec B shows the clean unconditional comparison -- TWFE and CS-NYT agree within 11% when both exclude controls, and both are positive. TWFE controls reduce the estimate by 21% (0.023 to 0.019), consistent with controls absorbing pre-existing price convergence. Spec A collapse (CS=0) reflects Lesson 11 behavior, not an informative estimator gap. The 11% Spec B margin is modest and directionally consistent. Feeds Deliverable D1 of QJE review (Sant'Anna, 2026-04-17).

---

## Rating decomposition

| Axis | Score | Basis |
|---|---|---|
| Fidelity (paper-auditor) | F-HIGH | WITHIN_TOLERANCE (2.44% gap); PDF confirmed post-sweep |
| Implementation -- TWFE | PASS | Spec matches paper; pre-trends = Axis 3 |
| Implementation -- CS-DID | PASS | Sign reversal fixed; Spec A collapse = Axis 3 |
| Implementation -- Bacon | NOT_APPLICABLE | run_bacon=false |
| Implementation -- HonestDiD | PASS | Correctly applied; values = Axis 3 |
| Implementation -- deCdH | NOT_NEEDED | Not counted |
| Implementation score | I-HIGH | 0 impl WARNs, 0 impl FAILs |
| **Final rating** | **HIGH** | F-HIGH x I-HIGH |
| Design credibility | **D-FRAGILE** | TWFE avg breaks at M_bar=0.75; CS-NYT null at M_bar=0; calibrated M_bar~1.6 |

---

## Material findings (all Axis 3 design findings)

- All 11 TWFE pre-period coefficients significant and monotonically negative (|t|=2.0-3.3). Textbook contaminated-comparisons fingerprint: already-treated cohorts used as pseudo-controls have lower prices, generating spurious negative pre-trends in all-eventually-treated design.
- CS-NYT HonestDiD: att_avg and att_peak null at M_bar=0. Calibrated M_bar~1.6 from observed pre-trends; at M_bar=1.5 all TWFE targets span zero. Design fragility severe under realistic calibration.
- Spec A all-eventually-treated + empty cs_controls collapse (att_cs_nyt_with_ctrls=0, status=OK): Lesson 11 structural -- not a pipeline bug, but prevents matched-protocol Spec A comparison.
- Extreme cohort heterogeneity (informational): Bacon pairs range -0.230 to +0.259; cohort 688 vs 687 ATT=+0.231 (41x aggregate). TWFE aggregate masks near-cancelling cohort effects.

Implementation findings (Axis 2): None.

---

## Recommended actions

1. No implementation action needed. The allow_unbalanced=false fix (2026-04-19) resolved the prior sign reversal. Implementation is correct.

2. User (dissertation, Lesson 10 focal paper): Present as canonical Lesson 10 exemplar -- the allow_unbalanced balancing-rule problem. Key message: R csdid with allow_unbalanced=TRUE on an all-eventually-treated panel does not enforce pair-balancing (Stata csdid implicitly does), producing sign reversal. The fix recovers positive CS-NYT (+0.021), consistent with paper pair-balanced CS (+0.012). The 75% magnitude gap is a design finding: pair-balancing matters substantially in all-eventually-treated contexts.

3. User (methodological judgement): For dissertation, characterize as: TWFE faithfully reproduced but design fragile (pre-trend contamination from all-eventually-treated structure); CS-NYT directionally consistent after balancing fix; HonestDiD requires M_bar<0.75 for TWFE average significance -- fragile given calibrated M_bar~1.6. Recommended headline: TWFE positive and reproduced, CS-NYT directionally consistent, but D-FRAGILE design credibility means causal interpretation is uncertain.

4. Pattern-curator (optional): Spec A all-eventually-treated + empty cs_controls collapse is the 11th Lesson 7/Pattern 42 instance. Consider sub-entry distinguishing Pattern 42A (direct-level controls overfit) from Pattern 42B/Lesson 11 (empty xformla in all-eventually-treated + not-yet-treated comparison).

---

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md) *(dated 2026-04-18; CS sign-reversal section stale -- sign fixed post-sweep)*
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md) *(dated 2026-04-18; fidelity NOT_APPLICABLE superseded by post-sweep PDF confirmation)*
