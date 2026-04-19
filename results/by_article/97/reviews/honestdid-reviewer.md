# HonestDiD Reviewer Report — Article 97 (Bhalotra et al. 2021)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Applicability

- `has_event_study = true`: YES
- `event_pre = 6`: 6 pre-periods (well above the 3-period threshold)
- APPLICABLE.

### 2. Pre-trend summary (context for sensitivity analysis)

The TWFE event study has 5 usable pre-period coefficients (t=-6 to t=-2; t=-1 is reference):
- Maximum pre-trend deviation: +0.335 (t=-4)
- These are large, structured, positive pre-trends. HonestDiD is thus testing robustness of a headline estimate whose baseline parallel-trends assumption is already visually violated.

### 3. HonestDiD results — Relative Magnitudinality (RM) approach

From `honest_did_v3.csv` and `honest_did_v3_sensitivity.csv`:

**Parameters:**
- n_pre = 5, n_post = 5
- ATT targets: first-post (t=0: -0.035), average (avg: -0.352), peak (t=3: -0.556)

**Critical Mbar thresholds (smallest Mbar where CI excludes zero):**

For **TWFE**:
| Target | Mbar at sign change | ATT point | CI at Mbar=0 |
|---|---|---|---|
| first | Zero already in CI at Mbar=0 | -0.035 | [-0.128, +0.059] |
| avg | 0 (CI excludes zero at Mbar=0) | -0.352 | [-0.427, -0.277] |
| peak | 0 (CI excludes zero at Mbar=0) | -0.556 | [-0.656, -0.457] |

For **CS-NT**:
| Target | Mbar at sign change | ATT point | CI at Mbar=0 |
|---|---|---|---|
| first | Zero in CI at Mbar=0 | -0.035 | [-0.176, +0.106] |
| avg | 0 (CI excludes zero at Mbar=0) | -0.352 | [-0.461, -0.242] |
| peak | 0 (CI excludes zero at Mbar=0) | -0.556 | [-0.695, -0.419] |

**rm_first_Mbar = 0** (the "first-post" coefficient loses significance immediately under any pre-trend violation).

**rm_avg_Mbar = 0.25** (TWFE) and **0.25** (CS-NT): the average ATT remains significant even with pre-trend violations 25% as large as the largest observed pre-trend.

**rm_peak_Mbar = 0.5** (TWFE) and **0.25** (CS-NT): the peak treatment effect loses significance only when pre-trend violations reach 50% (TWFE) or 25% (CS-NT) of the maximum observed pre-trend.

### 4. Interpretation

**First-post period (t=0):** The impact coefficient at t=0 is -0.035 (SE 0.048), which is not statistically significant even under no pre-trend assumption (Mbar=0). HonestDiD confirms fragility — this early post-treatment estimate is not credibly distinguishable from zero.

**Average ATT (-0.352):** Survives sensitivity to pre-trend violations at Mbar=0 (CI: [-0.427, -0.277] for TWFE; [-0.461, -0.242] for CS-NT). The treatment effect remains significantly negative as long as pre-trend violations are less than 25% of the largest observed pre-trend. Given that observed pre-trends are very large (+0.335), Mbar=0.25 translates to allowable confounders of ~0.084 units — not negligible.

**Peak ATT (-0.556 at t=3):** The largest treatment effect is robust to pre-trend violations up to Mbar=0.5 (TWFE) and 0.25 (CS-NT). The peak result is the most robust.

### 5. Critical concern: pre-trends undermine the validity of RM sensitivity

The HonestDiD RM sensitivity analysis assumes that pre-period violations bound post-period violations. However, the observed pre-trend path (rising from t=-6 to t=-4, then falling to near-zero at t=-2) is non-monotone and large. The RM restriction may not be the right restriction here: the pre-trend pattern suggests a possible level difference that reverses, which would require the "level restriction" (SmoothBounds or Intercept shift) rather than RM alone.

The very large pre-trends (+0.335 at peak) mean that Mbar=1 (pre-trend violation as large as the largest observed) still yields wide CIs that encompass zero for the "avg" target. At Mbar=0.5 for the average ATT, the CI already approaches zero from the positive side.

### 6. Verdict assessment

The HonestDiD results reveal:
- The average ATT is moderately robust (survives to Mbar=0.25 but not beyond)
- The first-post coefficient is not significant even at baseline
- The pre-trends are so large that the RM sensitivity analysis provides only limited reassurance

**WARN** — the average and peak ATTs survive modest deviations from parallel trends but the pre-trend evidence is itself so strong that the HonestDiD sensitivity analysis starts from a compromised baseline. A fuller analysis allowing for intercept shifts (not just RM) would be warranted.

### 7. Summary

| Check | Verdict |
|---|---|
| Applicability | PASS |
| First-post ATT significance | WARN — not significant even at Mbar=0 |
| Average ATT sensitivity | PASS — survives Mbar=0.25 |
| Peak ATT sensitivity | PASS — survives Mbar=0.5 (TWFE) |
| Pre-trend magnitude | WARN — very large pre-trends compromise the baseline |

**Top-line WARN.**
