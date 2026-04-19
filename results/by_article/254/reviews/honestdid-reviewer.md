# HonestDiD Reviewer Report — Article 254

**Article:** Gandhi et al. (2024) — The Effect of Medicaid Reimbursement Rates on Nursing Home Staffing
**Verdict:** PASS
**Date:** 2026-04-18

---

## Applicability check
- `has_event_study == true`: YES
- Pre-periods: TWFE has 9 pre-periods (weekly), CS-NT has 3 pre-periods (quarterly). Both exceed the minimum threshold of 3. APPLICABLE.

---

## HonestDiD sensitivity analysis

Data source: `honest_did_v3.csv` and `honest_did_v3_sensitivity.csv`.

### Breakdown Mbar values (from honest_did_v3.csv)

| Estimator | Target | Breakdown Mbar |
|-----------|--------|---------------|
| TWFE | first | 2.00 |
| TWFE | avg | 0.50 |
| CS-NT | first | 1.75 |
| CS-NT | avg | 1.25 |

The breakdown Mbar is the maximum deviation from parallel trends (as a multiple of the largest pre-trend deviation) at which the confidence set still excludes zero.

### Interpretation

**TWFE, "first" target (impact in first post-period):**
- Breakdown Mbar = 2.0. This means that even if the post-treatment trend deviates from parallel trends by up to 2x the observed pre-trend variation, the effect remains statistically distinguishable from zero. This is a high level of robustness.
- Sensitivity path at Mbar=0 (point identified): CI = [3.159, 6.547]. At Mbar=2: CI = [0.406, 9.264]. The lower bound remains positive throughout the sensitivity range.

**TWFE, "avg" target (average post-period effect):**
- Breakdown Mbar = 0.5. The confidence set breaks at relatively modest deviations from parallel trends. At Mbar=0: CI = [7.278, 10.447]. At Mbar=0.75: CI = [-0.116, 16.487] — the lower bound crosses zero.
- This indicates that the average post-period effect is less robust to violations of parallel trends than the first-period effect. This is expected given the growing treatment effects (ramp-up) — the "avg" target is a larger number and has more uncertainty.

**CS-NT, "first" target:**
- Breakdown Mbar = 1.75. Strong robustness. At Mbar=1.75: CI = [0.275, 10.194] — still excludes zero. At Mbar=2: CI = [-0.372, 10.808] — just barely crosses zero.

**CS-NT, "avg" target:**
- Breakdown Mbar = 1.25. At Mbar=1.25: CI = [0.238, 15.871]. At Mbar=1.5: CI = [-1.382, 15.871] — crosses zero.

### Assessment

- For both estimators, the **first-period effect** is highly robust (Mbar >= 1.75). This is the most conservative and credible measure of the immediate policy impact.
- The **average post-period effect** is less robust (Mbar = 0.5 for TWFE), but this is partly mechanical: the ramp-up in effects over time means the average effect is higher and the confidence set is wider relative to the breakdown threshold.
- The pre-trends in the event study are visually clean and flat, suggesting the true Mbar for this design is likely low, making the breakdown values of 1.75–2.0 for "first" target comfortably above the plausible range of violations.
- No concerns about the sensitivity analysis implementation.

---

## Conclusion

Both TWFE and CS-NT show strong robustness of the first-period effect to violations of parallel trends (Mbar >= 1.75). The average effect is more sensitive, as expected for a design with growing post-treatment effects. Overall, HonestDiD supports confidence in the headline result.

**Verdict: PASS** — First-period effects are robust at Mbar >= 1.75 for both estimators. Average-effect robustness is more limited (Mbar = 0.5 for TWFE) but this reflects the growing treatment effects rather than a parallel trends failure.

---

*Full report. Sensitivity data at: results/by_article/254/honest_did_v3_sensitivity.csv*
