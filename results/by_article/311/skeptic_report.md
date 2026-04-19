# Skeptic report: 311 — Galasso & Schankerman (2024)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (FAIL), bacon (WARN), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Galasso & Schankerman (2024) estimate the effect of Medicines Patent Pool (MPP) membership on drug access for developing countries using a staggered DiD design across 6,746 country×product units over 2005–2018 (7 treatment cohorts, 84.6% never-treated). The headline TWFE ATT is 0.663 (se = 0.050) — a large, highly significant effect. However, the audit flags three methodological concerns that jointly warrant a LOW rating: (1) the CS-DID estimator — the primary modern robustness check — failed to produce a valid ATT in the main results pipeline (all fields NA in results.csv), most likely because the panel-balancing instruction conflicted with the dataset's 84.8% fill rate; (2) pre-period TWFE coefficients at t=-4 and t=-3 are statistically significant and positive, raising concern about pre-trends or anticipation effects that could inflate the post-period estimates; (3) the Bacon decomposition was disabled without adequate justification (the 7-cohort design is trivial for `bacondecomp`). The positive finding is that HonestDiD analysis confirms the TWFE first-post-period estimate is robust to violations up to Mbar=2, and the CS-NT estimate in the HonestDiD auxiliary run (~0.644) aligns closely with TWFE, giving indirect reassurance. The stored TWFE result (0.663) likely captures a real access effect but should be treated with caution pending a clean CS-DID run.

---

## Per-reviewer verdicts

### TWFE (WARN)
- Pre-period coefficients at t=-4 (+0.046, 2.8σ) and t=-3 (+0.042, 3.8σ) are statistically significant, suggesting possible pre-trend or anticipation effects violating parallel trends.
- Staggered adoption with 7 cohorts creates contaminated TWFE comparisons; effect direction is consistent but weight sign cannot be verified without Bacon output.
- Clustering specification differs from paper (one-way vs. two-way), likely underestimating standard errors.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (FAIL)
- All CS-DID ATT fields in results.csv are NA — the estimator did not converge in the main pipeline.
- Likely cause: forced panel balancing (`allow_unbalanced = false`) on an 84.8% fill-rate panel produces an overly sparse balanced subset.
- A CS-NT estimate of ~0.644 appears in the HonestDiD auxiliary analysis, close to TWFE, but is not formally recorded as a robust check.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (WARN)
- `run_bacon = false` in metadata, citing "large dataset size" — but a 7-cohort design requires only 28 two-by-two comparisons, well within `bacondecomp` capacity.
- Cannot formally verify whether TWFE negative-weight comparisons exist or their magnitude.
- TWFE and SA event-study consistency across post-periods provides indirect reassurance of limited contamination.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS)
- First post-period ATT survives violations up to Mbar=2 (TWFE) and Mbar=2 (CS-NT) — very robust.
- Average ATT survives Mbar=0.75 (TWFE) and Mbar=1.25 (CS-NT) — moderate-to-strong robustness.
- CS-NT HonestDiD CI [0.576, 0.705] at Mbar=0 is tight and reassuring.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Treatment is absorbing binary staggered — standard design where CS-DID is the appropriate estimator.
- No evidence of dose heterogeneity or treatment reversals.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper-Auditor (NOT_APPLICABLE)
- `pdf/311.pdf` not found; `original_result` field in metadata is empty `{}`.
- Fidelity axis cannot be evaluated. Rating uses methodology score alone.

---

## Material findings (sorted by severity)

**FAIL:**
- CS-DID (never-treated) produced NA estimates in results.csv. The primary modern estimator is unavailable for formal comparison, leaving the TWFE estimate unvalidated against heterogeneous-treatment-effects-robust alternatives.

**WARN:**
- Pre-trend violation: TWFE pre-period coefficients at t=-4 (β=+0.046, se=0.016) and t=-3 (β=+0.042, se=0.011) are statistically significant, indicating the parallel trends assumption may not hold in the pre-period window.
- Bacon decomposition disabled on an inadequate justification. A 7-cohort design is computationally trivial for `bacondecomp`; re-enabling would formally verify TWFE weight signs.
- Clustering mismatch: template uses one-way clustering on `product_code` while the paper employs two-way clustering (`product_code × country_code`). Standard errors in results.csv are likely underestimated relative to the paper.

---

## Recommended actions

- **Repo-custodian:** Set `run_bacon = true` in `data/metadata/311.json` and re-run the Analyst stage. The 7-cohort staggered design is not computationally prohibitive.
- **Repo-custodian:** Investigate the CS-DID failure. Options: (a) set `allow_unbalanced = true` in metadata to allow the `did` package to handle the unbalanced panel natively; or (b) verify the balanced-panel subset size — if it is tiny relative to the full dataset, `allow_unbalanced` should be set to `true` and the gvar_CS construction verified on the resulting subset.
- **User (methodological judgement):** The significant pre-period coefficients at t=-3 and t=-4 are a substantive concern. These may reflect anticipatory effects (countries applying for MPP membership before formal approval) or a genuine pre-trend. The authors should be asked whether they report pre-trend tests and whether their specification includes a specific pre-treatment window for the parallel trends assumption.
- **Pattern-curator:** Add or update failure pattern: "CS-DID NA when allow_unbalanced=false on dataset with <90% fill rate — balanced panel subset is too sparse. Resolution: set allow_unbalanced=true."
- **Paper-auditor:** Obtain `pdf/311.pdf` and populate `original_result` in metadata if a comparable TWFE estimate is reported in the paper, to enable fidelity auditing.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
