# CS-DID Reviewer Report: Article 65
# Akosa Antwi, Moriya & Simon (2013) — ACA Dependent-Coverage Mandate

**Verdict:** WARN

**Date:** 2026-04-18

---

## Checklist

### 1. Group variable (gvar_CS) construction
- gvar_CS = 34 for treated units (fedelig=1), 0 for never-treated (fedelig=0).
- yearmonth = (year-2008)*12 + month. October 2010: year=2010, month=10 → yearmonth = (2010-2008)*12 + 10 = 24+10 = 34. CORRECT.
- Never-treated group (gvar_CS=0): individuals outside age 19–25 band (ages 16–18 and 26–29).

### 2. Single-cohort design implications for CS-DID
- With treatment_timing="unica", there is exactly one cohort (g=34). CS-DID collapses to a single-cohort DID.
- CS-NT ATT(g=34, t≥34) = comparison of treated vs never-treated across all post-periods.
- The NYT estimator (not-yet-treated) is conceptually identical to NT in a single-timing design — hence att_csdid_nyt = NA (correctly not computed or returned NA in results).

### 3. ATT estimates
- ATT_CS_NT (simple/dynamic): 0.0248 (SE=0.0310). Not significant at 5% (t=0.80).
- TWFE estimate: 0.0317 (SE=0.0076, t=4.17). Significant at 1%.
- Gap: CS-NT is 22% below TWFE in magnitude. More importantly, the CS-NT SE is 4x larger than TWFE SE.

### 4. Why is the CS-NT standard error so much larger?
- CS-DID is estimated without controls (cs_controls=[]), while TWFE includes 12 controls.
- In individual-level RCS data with a single cohort, CS-DID essentially does the equivalent of a two-sample comparison of treated vs untreated, without the precision gains from conditioning on covariates.
- The metadata notes that cs_controls=[] — no controls passed to CS-DID. This is consistent with Callaway-Sant'Anna (2021) recommendations for RCS data (where controlling in CS-DID is complex), but it means the CS-DID estimate loses all the precision from the 12 TWFE controls.
- WARN: The loss of precision from omitting controls in CS-DID is material here. The CS-DID estimate (0.0248) is directionally consistent with TWFE but individually non-significant (t=0.80), partly because no controls are used.

### 5. CS-DID with controls (att_cs_nt_with_ctrls)
- att_cs_nt_with_ctrls = 0 (value is literally 0, status="OK"). This indicates the doubly-robust estimator returned 0 — likely a numerical failure or the controls caused collinearity that defaulted the estimate to zero.
- This is an implementation anomaly. A CS-DID ATT of exactly 0 with status="OK" but SE=NA is suspicious.
- WARN: The cs_nt_with_ctrls result appears to have encountered a numerical issue (returned 0 with NA SE despite status="OK"). This should be investigated — may be a pattern related to individual-level RCS data with controls in CS-DID (similar to Pattern 24 in the knowledge base).

### 6. Pre-trends in CS event study
- CS-NT pre-period coefficients from event_study_data.csv: t-7=-0.035 (SE=0.045), t-6=-0.011 (SE=0.043), t-5=+0.005 (SE=0.027), t-4=-0.007 (SE=0.041), t-3=-0.021 (SE=0.040), t-2=+0.004 (SE=0.046).
- All pre-period CS-NT coefficients are smaller than their SEs. None significant. Pre-trends CLEAN.

### 7. Post-period CS-NT event study
- Post-period: t=0: 0.007, t=1: 0.003, t=2: 0.049, t=3: 0.001, t=4: 0.021, t=5: 0.029, t=6: 0.042.
- Pattern similar to TWFE. Spike at t=2 present in both. Convergence in shape is reassuring.
- CS-NT coefficients are individually noisy (SEs 0.025–0.050) due to no controls.

### 8. Comparison with SA and Gardner
- SA event study: very similar shape to TWFE. t=2: 0.044. t=6: 0.039.
- Gardner event study: t=2: 0.056, t=6: 0.039.
- All estimators agree on positive post-treatment effect, with peak at t=2.

### 9. NYT not attempted
- att_csdid_nyt = NA, cs_nyt_with_ctrls_status = "NOT_ATTEMPTED".
- Single-timing design: NYT and NT are equivalent, so skipping NYT is correct.

### 10. Design-level concern: treated vs never-treated pool
- Treated = age 19–25; Never-treated = age 16–18 and 26–29.
- The never-treated pool is defined by age band exclusion. This is the paper's original design — the skeptic does not override the author's design choice. However, it is worth noting that ages 26–29 are close to the eligibility boundary and may have differential pre-trends (e.g., anticipation, differential age effects on labour market). The clean pre-trends observed in CS-NT suggest this is not a major concern empirically.

---

## Material findings

1. **WARN: CS-DID without controls yields non-significant ATT** (0.0248, SE=0.031, t=0.80) vs TWFE significant at 1%. The direction is consistent but precision is lost due to no covariates in CS estimation. Users interpreting the CS-NT estimate should note the large SE is a feature of the CS specification (no controls), not a sign of an underlying effect reversal.

2. **WARN: cs_nt_with_ctrls anomaly** — the doubly-robust estimator returned exactly 0 with NA SE (status="OK"). This is a numerical issue, likely related to individual-level RCS data exceeding the capacity of the doubly-robust CS-DID estimator (see Pattern 5/Pattern 4 in knowledge base). The result should not be interpreted substantively.

---

## Summary

CS-DID is correctly specified for the single-timing design. The ATT_CS_NT estimate (0.0248) is directionally consistent with TWFE (0.0317) — both positive, indicating the ACA mandate increased coverage. The large CS-NT standard error (4x TWFE) reflects the absence of covariates in the CS specification, not a contradictory finding. The doubly-robust with-controls variant failed numerically (returned 0). Pre-trends are clean across all 6 pre-periods for both TWFE and CS-NT. Two WARNs: precision loss from no controls, and the numerical anomaly in the with-controls estimate.

**Verdict: WARN**
