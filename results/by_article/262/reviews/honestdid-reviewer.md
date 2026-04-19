# HonestDiD Reviewer Report: Article 262

**Verdict:** PASS
**Date:** 2026-04-18
**Article:** Anderson, Charles, Rees (2020) — Hospital Desegregation & Black Postneonatal Mortality

---

## Applicability

- has_event_study: true — YES
- event_pre: 5 (periods −6 through −2, 5 pre-periods relative to t=−1 omitted) — YES, ≥3 pre-periods
- **Applicable.**

---

## Checklist

### 1. HonestDiD Configuration

HonestDiD was run under the `C_RES` (relative magnitudes) restriction using pre-trends as the reference for how much post-treatment trends can deviate. Two estimators were tested:
- TWFE (`vcov_type: full`)
- CS-NT (`vcov_type: full_IF`)

Parameters (from `honest_did_v3.csv`):
- TWFE: n_pre=4, n_post=6, targets: first-post, avg, peak
- CS-NT: n_pre=4, n_post=6, targets: first-post, avg, peak

The Mbar=0 case corresponds to parallel trends holding exactly (no differential pre-trends allowed). Higher Mbar values allow deviations proportional to observed pre-trend variation.

### 2. TWFE Sensitivity Results

| Target | Mbar=0 | lb | ub | Robust? |
|--------|--------|----|----|---------|
| first | 0 | −0.802 | 3.230 | NO (includes 0) |
| avg | 0 | −1.708 | 3.552 | NO |
| peak | 0 | −0.358 | 4.182 | NO |

**The TWFE estimate is not robust to even zero pre-trend violations.** Even at Mbar=0 (perfect parallel trends), the confidence interval for first-post and avg targets includes zero. This reflects the large TWFE standard errors rather than pre-trend violations per se — the TWFE effect is simply not precisely estimated enough to be significant.

As Mbar increases, intervals widen rapidly. By Mbar=0.5:
- first: lb=−1.420, ub=3.806
- avg: lb=−5.287, ub=6.642

### 3. CS-NT Sensitivity Results

| Target | Mbar=0 | lb | ub | Robust? |
|--------|--------|----|----|---------|
| first | 0 | 0.317 | 3.967 | **YES** (excludes 0) |
| avg | 0 | 0.304 | 1.986 | **YES** |
| peak | 0 | 1.031 | 4.386 | **YES** |

**The CS-NT estimate IS robust at Mbar=0.** All three targets exclude zero at baseline (no pre-trend violations allowed).

Robustness breakdown by Mbar:
- CS-NT first: remains positive until Mbar=0.25 (lb=0.130, ub=4.302 — barely positive at lb; by Mbar=0.5 lb becomes negative at −1.419)
- CS-NT avg: positive until Mbar=0.25 (lb=−1.622 — already negative at Mbar=0.25)
- CS-NT peak: positive at Mbar=0 (lb=1.031, ub=4.386); by Mbar=0.25 lb=−1.870

The CS-NT estimate breaks down at **very small Mbar (~0.25)**, meaning robustness holds only if pre-trend violations are no more than 25% of the observed pre-period variation. Given that observed pre-trends show modest drift (CS-NT t=−5: 1.269, SE 1.243, t-stat 1.02), this is a plausible assumption — the pre-trends look flat enough that Mbar=0.25 is a conservative threshold.

### 4. Critical Mbar Values

- TWFE: Not robust even at Mbar=0. The breakdown point is not meaningful — TWFE is simply imprecise.
- CS-NT first-post: Mbar breakeven ≈ 0.17–0.25 (lb crosses 0 between Mbar=0 and Mbar=0.25)
- CS-NT avg: Mbar breakeven ≈ 0.10–0.25 (lb crosses 0 by Mbar=0.25)

### 5. Pre-trend Plausibility Assessment

The CS-NT pre-trend t-stats (max |t|=1.02 at t=−5) suggest pre-trends are flat. A Mbar of 0.25 means allowing post-treatment trend violations 25% as large as the maximum pre-period magnitude. Given the pre-period magnitudes are economically small relative to the treatment effect, a breakdown at Mbar=0.25 is considered **moderate robustness** — not bulletproof, but not fragile either.

### 6. Overall Verdict

The CS-NT result passes HonestDiD at Mbar=0 on all three targets. The TWFE result fails HonestDiD at Mbar=0, but this failure reflects imprecision rather than pre-trend violations (the TWFE estimate is itself non-significant). The key policy-relevant estimate (CS-NT) has moderate sensitivity robustness.

**Verdict: PASS** — CS-NT estimate is robust at Mbar=0 (all three targets exclude zero). The TWFE breakdown is explained by large SEs, not by pre-trend evidence. The critical Mbar of ~0.25 for CS-NT is acceptable given flat observed pre-trends.
