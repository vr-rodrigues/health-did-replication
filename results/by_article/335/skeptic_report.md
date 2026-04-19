# Skeptic report: 335 — Le Moglie, Sorrenti (2022)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (N/A — single cohort), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF)

## Executive summary

Le Moglie and Sorrenti (2022) estimate the effect of mafia presence on new enterprise formation in Italian provinces following the 2007 financial crisis, using a single-cohort DiD where 28 high-mafia provinces (top tertile of Transcrime Mafia Index) are treated from 2007 onward, compared to 56 never-treated provinces. The TWFE estimate is beta=0.0405 (SE=0.0107 Conley), implying a roughly 4% increase in new enterprise formation in mafia-exposed provinces. This is a methodologically clean design: single treatment cohort, absorbing binary treatment, no staggered timing issues. TWFE and CS-DID agree closely (0.041 vs. 0.046), and the event study pre-trends are visually flat. The one methodological concern is that the CS-DID lacks the controls used in TWFE (pop_urb, tourism, banking variables, etc.), creating a slight upward bias in the unconditional CS estimate. Additionally, HonestDiD shows the result is robust under the maintained parallel trends assumption but fragile to even small violations (Mbar=0.25 includes zero). The stored consolidated result of beta_twfe=0.04053 reliably reflects the paper's headline estimate and is obtained from a design where TWFE is appropriate. Trust the stored result, but note its fragility under HonestDiD sensitivity.

## Per-reviewer verdicts

### TWFE (PASS)
- Single-cohort DiD eliminates heterogeneous timing concerns; TWFE is appropriate and unambiguous here.
- Coefficient reproduced exactly (0.04053 vs paper's 0.0405). SE divergence (clustered vs Conley) is expected and documented.
- Pre-period coefficients are small and near zero (-0.007, -0.002, +0.007 at t=-4,-3,-2); no pre-trend concern.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT ATT (0.04636) is 14% higher than TWFE (0.04053), attributable to CS using no controls vs. TWFE's 18 controls — a covariate asymmetry that inflates the unconditional CS estimate.
- CS pre-trend shows a mild rising pattern at t=-3 (0.016) and t=-2 (0.020) — not individually significant but worth noting as possible anticipation or differential pre-trends.
- SA event study is identical to CS-NT (correct for single cohort), providing no additional diagnostic power.

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Skipped: treatment_timing = "single". No staggered timing, no decomposition meaningful.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS)
- Average ATT is robust under strict parallel trends (Mbar=0): TWFE avg interval [0.005, 0.053], CS-NT avg interval [0.010, 0.083] — both exclude zero.
- Fragility emerges at Mbar=0.25: all intervals include zero, indicating limited robustness to even modest violations of parallel trends.
- First post-period (t=0) is not individually robust even at Mbar=0 due to wide SEs; average and peak targets are robust.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary treatment, single cohort, no switchers or dose heterogeneity. DH estimator is not required and would replicate CS-NT results.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF at `pdf/335.pdf`. Formal fidelity verification against paper tables not possible.
- Metadata-recorded original result (0.0405) matches our estimate (0.04053) to 4 decimal places.

Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

## Material findings (sorted by severity)

**WARN items:**
- [WARN — CS pre-trend] CS-NT event study shows rising pre-period coefficients at t=-3 (0.016, SE=0.019) and t=-2 (0.020, SE=0.017). Not individually significant but suggestive of differential pre-trends or anticipation effects in treated provinces.
- [WARN — CS control asymmetry] CS estimation uses no controls (cs_controls=[]) while TWFE uses 18 time-varying controls. The 14% gap between CS-NT ATT (0.046) and TWFE (0.041) reflects this asymmetry. The unconditional CS estimate may overstate the causal effect if control variables are negatively correlated with treatment assignment.
- [WARN — HonestDiD fragility] Effect is not robust to Mbar=0.25 deviations from parallel trends. Any modest anticipation or differential dynamics erases statistical significance.

**No FAIL items.**

## Rating derivation

| Axis | Score | Basis |
|------|-------|-------|
| Methodology | M-MOD | 1 WARN (csdid), rest PASS or N/A |
| Fidelity | F-NA | No PDF available |
| Combined | MODERATE | M-MOD × F-NA → use methodology alone |

## Recommended actions

- **For the repo-custodian:** Consider adding time-varying controls to the CS specification (update `cs_controls` in metadata to include key economic covariates from `twfe_controls`, specifically `pop_urb`, `big_banks`, `self_emp`). This would narrow the gap between TWFE and CS-NT estimates and provide a tighter unconditional CS-DID.
- **For the user (methodological judgement call):** The HonestDiD fragility at Mbar=0.25 is a disclosable limitation. If the paper is used in a meta-analysis or policy context, report that the average effect survives under parallel trends but is sensitive to even mild violations. The pre-trends look flat, making Mbar=0 the most credible maintained assumption.
- **For the user:** Obtain the PDF (`pdf/335.pdf`) to enable formal fidelity auditing via paper-auditor on a future run.
- No action needed on TWFE, Bacon, or de Chaisemartin axes.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
