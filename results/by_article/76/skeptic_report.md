# Skeptic report: 76 — Lawler, Yewell (2023)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (NOT_APPLICABLE), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

**Methodology score:** M-LOW (2 WARNs, 0 FAILs among 3 active reviewers)
**Fidelity score:** F-NA (PDF absent; TWFE is EXACT by metadata cross-check)
**Design credibility:** D-MODERATE (TWFE avg ATT robust to Mbar=0.25; peak robust to Mbar=0.5)

---

## Executive summary

Lawler & Yewell (2023) estimate that baby-friendly hospital certification regulations increase ever-breastfeeding rates by approximately 3.8 percentage points (TWFE, controlled, SE=0.0095). The TWFE estimate is reproduced to four significant figures (0.03832 vs paper's 0.0383, a 0.06% gap), confirming exact implementation. However, two methodological concerns reduce confidence. First, the CS-DID estimates stored in our database (0.00774 NT, 0.00781 NYT) substantially understate the paper's Stata-reported CS-DID values (0.018, 0.0212) due to an irreducible structural limitation (Pattern 25: i.fips as covariate in Stata CSDID cannot be replicated in R att_gt for repeated cross-section data). The CS-DID estimates with individual controls (0.01652 NT) narrow this gap to 8.2%, but the stored headline numbers are not directly comparable. Second, HonestDiD analysis shows the average ATT loses robustness at Mbar=0.25 — a modest threshold — suggesting that even small violations of parallel trends post-treatment could render the average effect statistically indistinguishable from zero. The peak effect (t=2: +5.5 pp) is more robust, surviving Mbar=0.5. The stored TWFE consolidated result (0.0383) should be trusted as correctly reproducing the paper's estimate, but the user should note: (1) CS-DID numbers in the database are not the paper's CS-DID estimates, and (2) the design provides moderate rather than strong protection against parallel trends violations.

---

## Per-reviewer verdicts

### TWFE (PASS)
- Beta reproduced to 0.06% (0.03832 vs paper's 0.0383); SE reproduced to 0.005%.
- Two implementation fixes documented and validated: month formula correction for Stata %tm/%td confusion; styr_pergt64 explicit omission matching Stata's collinearity drop.
- Pre-trend coefficients flat (all within 1.2 SEs of zero). Post-treatment dynamics show gradual buildup peaking at t=2 (+5.5 pp, SE 1.0 pp).
[Full report: reviews/twfe-reviewer.md]

### CS-DID (WARN)
- Stored CS-NT ATT (0.00774) is 57% below paper's reported 0.018; CS-NYT (0.00781) is 63% below 0.0212. Gap is fully explained by Pattern 25 (i.fips covariate in Stata, structurally irreproducible in R for RCS data).
- With individual controls, gap narrows to 8.2% (0.01652 vs 0.01799) — the relevant comparison for methodology assessment.
- CS-NYT event study shows elevated pre-period at t=-4 (+0.0207, approx. 3.3 SEs), raising a mild parallel trends concern.
[Full report: reviews/csdid-reviewer.md]

### Bacon (NOT_APPLICABLE)
- Data structure is repeated cross-section; Bacon decomposition requires panel data.
- Informational aggregated Bacon signals: 2015 cohort has negative TVU estimate (-0.035) and large negative "Later vs Earlier" estimates when used as control. This is a design signal, not a formal Bacon result.
[Full report: reviews/bacon-reviewer.md]

### HonestDiD (WARN)
- TWFE avg ATT: robust only to Mbar=0.25 (CI crosses zero at Mbar=0.50). Design credibility: D-MODERATE.
- TWFE peak ATT (t=2): robust to Mbar=0.50.
- CS-NYT avg ATT: fragile even at Mbar=0 (CI = [-0.000222, +0.042] barely excludes zero).
- CS-NYT peak ATT: robust at Mbar=0, fragile at Mbar=0.25.
- Driven by elevated CS-NYT pre-period at t=-4 and modest pre-trend magnitude relative to post-treatment effect size.
[Full report: reviews/honestdid-reviewer.md]

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary treatment at hospital level; continuous county-level share is a design feature, not a switching treatment. No evidence of treatment reversal. DeCDH estimator not warranted.
[Full report: reviews/dechaisemartin-reviewer.md]

### Paper Auditor (NOT_APPLICABLE)
- PDF absent from replication package.
- Metadata cross-check confirms TWFE EXACT (0.06% gap). CS-DID gap explained by structural limitation (Pattern 25), not an error.
[Full report: reviews/paper-auditor.md]

---

## Material findings (sorted by severity)

**WARN — CS-DID database gap not flagged as caveat:** The stored att_csdid_nt (0.00774) and att_csdid_nyt (0.00781) are 57–63% below the paper's reported CS-DID estimates. Downstream analyses using these stored values (e.g., consolidated_results.csv) will understate the paper's CS-DID result substantially. The with-controls estimates (0.01652 NT) are more comparable but still 8% below.

**WARN — HonestDiD avg ATT fragile at Mbar=0.25:** The average post-treatment effect (0.0343 TWFE) loses statistical significance when allowing post-treatment trend violations equal to 25% of the maximum observed pre-trend deviation. This is a relatively strict assumption. Users should not interpret the average ATT as robustly established; the peak at t=2 is more convincing.

**WARN — CS-NYT pre-period elevated at t=-4:** The CS-NYT event study shows a t=-4 coefficient of +0.0207 (SE ~0.006), approximately 3.3 SEs from zero. While not overwhelming evidence of pre-trend violation (pre-periods at t=-5, -3, -2 are near zero), this single elevated period inflates sensitivity bounds and reduces HonestDiD robustness for CS-NYT.

---

## Recommended actions

- **For the repo-custodian agent:** Add a `cs_did_caveat` flag to metadata indicating the stored att_csdid_nt/nyt values are the no-controls simple estimates, not the paper's Stata CSDID estimates. Consider adding a field `att_csdid_nt_with_state_fes` = 0.01652 (with Pattern 25 note) to distinguish the best-available R estimate from the stored one.
- **For the pattern-curator:** The Pattern 25 documentation should explicitly note that stored att_csdid_nt in results.csv for RCS papers with i.unit as Stata covariate will systematically understate the paper's CS-DID by 40–60%; the with-controls estimate (att_cs_nt_with_ctrls = 0.01652) is the preferred stored value for cross-paper comparison.
- **For the user (methodological judgement):** The headline result (baby-friendly regulations increase ever-breastfeeding by ~3.8 pp) is reproduced exactly and directionally consistent across all estimators. However, the average ATT is sensitive to modest parallel trends violations (Mbar=0.25). If using this paper's result in a meta-analysis, prefer the peak ATT (t=2, +5.5 pp, robust to Mbar=0.5) as the design-credible signal, with D-MODERATE designation.

---

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
