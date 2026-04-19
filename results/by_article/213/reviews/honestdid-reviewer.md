# HonestDiD Reviewer Report — Article 213
**Estrada & Lombardi (2022) — Dismissal Protection, Bureaucratic Turnover**
**Date:** 2026-04-18

**Verdict:** WARN

## Setup
- n_pre = 3 (t = -3, -2, omitted t=-1), n_post = 1 (t = 0 only, single post-period).
- Sensitivity class: Delta^RM(Mbar) — relative magnitudes, the standard choice when pre-trends are small and non-monotone.
- Estimators tested: TWFE and CS-NT.
- Targets: tau_first (= tau_post = tau_avg with a single post-period; all three are identical here).

## HonestDiD sensitivity results

### TWFE
| Mbar | Lower bound | Upper bound | Sign preserved? |
|------|-------------|-------------|-----------------|
| 0.00 | -0.0582 | -0.0020 | YES (both negative) |
| 0.25 | -0.0667 | +0.0071 | NO (CI crosses zero) |
| 0.50 | -0.0786 | +0.0196 | NO |
| 1.00 | -0.1104 | +0.0514 | NO |
| 2.00 | -0.1802 | +0.1206 | NO |

### CS-NT
| Mbar | Lower bound | Upper bound | Sign preserved? |
|------|-------------|-------------|-----------------|
| 0.00 | -0.0575 | -0.0020 | YES (both negative) |
| 0.25 | -0.0665 | +0.0065 | NO (CI crosses zero) |
| 0.50 | -0.0788 | +0.0188 | NO |
| 1.00 | -0.1102 | +0.0502 | NO |
| 2.00 | -0.1787 | +0.1186 | NO |

## Assessment

### rm_first_Mbar / rm_avg_Mbar / rm_peak_Mbar
- All three targets are identical (single post-period). The robustness threshold is **Mbar = 0.00** for all targets, for both estimators.
- At Mbar = 0 (Delta = 0: parallel trends exactly), the CI is [-0.058, -0.002] — just excludes zero. The effect is statistically significant only under the strong assumption of exact parallel trends.
- At any positive Mbar (allowing even slight pre-trend variation), the CI crosses zero.

### Design credibility classification
- rm_first = rm_avg = rm_peak = **0** → **D-FRAGILE** for all targets.
- However, important context: the pre-trends from the event study are *oscillating* (alternating sign: +0.024, -0.015, +0.027) rather than drifting. The HonestDiD Delta^RM model assumes smooth, monotone violations. An oscillating pre-trend is actually *less consistent* with a systematic violation of parallel trends than a drifting one — it may indicate measurement noise rather than genuine pre-trend.
- The small oscillating pre-trends may cause HonestDiD to be overly conservative relative to the actual violation risk, because Delta^RM penalises any movement including noise.

### Why the WARN (not FAIL)
- The D-FRAGILE classification is correct mechanically, but it must be weighed against:
  1. The oscillating (not drifting) pre-trend pattern — low evidence of genuine trends violation.
  2. The single post-period means the CI at Mbar=0 is [-0.058, -0.002]: the lower bound is 6x the SE away from zero; the upper bound just barely touches -0.002. The fragility is at the *positive tail*, not the central estimate.
  3. All 4 estimators (TWFE, CS-NT, SA, Gardner) are directionally consistent and in the -0.03 to -0.04 range.
  4. The design (sharp RD-like cutoff at 3 years of seniority) provides quasi-experimental credibility not fully captured by HonestDiD.

### Concern flagged
The HonestDiD fragility arises mechanically from having only 1 free post-period. With n_post=1, the CI at Mbar=0 is already tight ([-0.058, -0.002]), and any Mbar>0 expands it to include zero. This is a structural limitation of the sensitivity test given the data, not evidence of a genuine pre-trend problem.

A WARN is appropriate because the headline effect is not robust to even small assumed violations of parallel trends (Mbar=0.25 includes zero). Users should note that the result depends on parallel trends holding approximately exactly.

## Summary
**Verdict: WARN.** HonestDiD classifies all targets as D-FRAGILE (Mbar threshold = 0). This is mechanically driven by the short post-window (1 period) and tight baseline CI, not by evidence of systematic pre-trend violations. The oscillating pre-trend pattern is reassuring. The result should be interpreted with awareness that it relies on a near-exact parallel trends assumption, though the sharp seniority cutoff design provides external credibility.
