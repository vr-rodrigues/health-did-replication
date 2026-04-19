# HonestDiD Reviewer Report — Article 309

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** honestdid-reviewer

---

## Checklist

### 1. Applicability

- has_event_study: true — YES
- n_pre (TWFE): 4; n_pre (CS-NT): 4 — both ≥ 3 — YES
- **Applicable**

### 2. HonestDiD sensitivity — TWFE estimator

Using the relative magnitudes restriction (RM) with linear extrapolation.

**Target: first post-period ATT (-0.112)**

| Mbar | LB | UB | Robust? |
|------|----|----|---------|
| 0 | -0.213 | -0.011 | YES |
| 0.25 | -0.231 | -0.003 | YES (barely) |
| 0.5 | -0.252 | +0.011 | NO |
| 1.0 | -0.306 | +0.053 | NO |

rm_first_Mbar (TWFE) = 0.25

**Target: average post-period ATT (-0.199)**

| Mbar | LB | UB | Robust? |
|------|----|----|---------|
| 0 | -0.289 | -0.109 | YES |
| 0.25 | -0.367 | -0.037 | YES |
| 0.5 | -0.471 | +0.062 | NO |
| 1.0 | -0.687 | +0.271 | NO |

rm_avg_Mbar (TWFE) = 0.25

**Target: peak post-period ATT (-0.323 at t=+4)**

| Mbar | LB | UB | Robust? |
|------|----|----|---------|
| 0 | -0.455 | -0.192 | YES |
| 0.25 | -0.542 | -0.094 | YES |
| 0.5 | -0.684 | +0.049 | NO |

rm_peak_Mbar (TWFE) = 0.25

### 3. HonestDiD sensitivity — CS-NT estimator

**Target: first post-period ATT (-0.127)**

| Mbar | LB | UB | Robust? |
|------|----|----|---------|
| 0 | -0.236 | -0.019 | YES |
| 0.25 | -0.265 | +0.001 | NO (barely) |
| 0.5 | -0.298 | +0.025 | NO |

rm_first_Mbar (CS-NT) = 0.0 (fails at Mbar=0.25)

**Target: average post-period ATT (-0.187)**

| Mbar | LB | UB | Robust? |
|------|----|----|---------|
| 0 | -0.256 | -0.119 | YES |
| 0.25 | -0.379 | -0.026 | YES |
| 0.5 | -0.532 | +0.110 | NO |

rm_avg_Mbar (CS-NT) = 0.25

**Target: peak post-period ATT (-0.239)**

| Mbar | LB | UB | Robust? |
|------|----|----|---------|
| 0 | -0.383 | -0.095 | YES |
| 0.25 | -0.537 | +0.026 | NO |

rm_peak_Mbar (CS-NT) = 0.0 (fails at Mbar=0.25)

### 4. Design classification

- rm_first_Mbar: 0.25 (TWFE) / 0 (CS-NT) → D-MODERATE (TWFE) / D-FRAGILE (CS-NT)
- rm_avg_Mbar: 0.25 (both) → D-MODERATE
- rm_peak_Mbar: 0.25 (TWFE) / 0 (CS-NT) → D-MODERATE (TWFE) / D-FRAGILE (CS-NT)

Overall design classification: **D-MODERATE**

The average effect (primary inferential target) is robust to Mbar=0.25 under both TWFE and CS-NT. It breaks down at Mbar=0.5, meaning the design requires that pre-trend violations in post-period are no more than 25% of the largest pre-period deviation.

### 5. Assessment

Mbar=0.25 is a moderate restriction. Given that pre-trend estimates are small and non-significant (largest: -0.079 at t=-5), a 25% extrapolation assumption is defensible but not generous. The negative direction of the average ATT is credible under this restriction. The peak effect is more fragile (CS-NT breaks at Mbar=0.25).

---

## Material findings

- **WARN:** All three ATT targets (first, avg, peak) lose statistical significance at Mbar=0.5 under TWFE; CS-NT peak and first break at Mbar=0.25.
- **NOTE:** Average effect robust to Mbar=0.25 under both estimators — this is the primary inferential target and is supported.
- **NOTE:** Design is D-MODERATE, not D-FRAGILE; the negative sign is credible under moderate pre-trend violation assumptions.

**Verdict: WARN**
