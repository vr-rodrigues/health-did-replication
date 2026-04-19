# CS-DID Reviewer Report — Article 358
## Bargain, Boutin, Champeaux (2019)

**Verdict:** WARN

**Date:** 2026-04-18

---

## Checklist

### 1. Estimator applicability

- Data structure: repeated cross-section (RCS). The `did` package (Callaway-Sant'Anna) supports RCS via the `panel = FALSE` option. The template correctly handles this mode.
- Treatment timing: single cohort (gvar_CS = 2014 for treated, 0 for never-treated). CS-DID collapses to a single (g, t) pair — equivalent to a simple ATT(2014, 2014). This is a valid but degenerate CS-DID application.
- No NYT estimator attempted — correct, since there is only one treatment cohort and single timing.

### 2. Results comparison

| Estimator | ATT | SE |
|---|---|---|
| TWFE (with 30 controls) | 4.181 | 1.053 |
| CS-DID NT (no controls) | 4.591 | 1.024 |
| CS-DID NT with controls | 0 (status: OK) | NA |

- **WARN — covariate specification mismatch.** The TWFE estimate uses 30 controls (including post × covariate interactions). The CS-DID estimate uses `cs_controls = []` (no controls). This is a meaningful methodological choice: the 2x2 setting means that including controls in TWFE via post-interaction is standard practice, but CS-DID with RCS and no controls estimates a raw comparison. The ~10% gap between TWFE (4.181) and CS-DID NT (4.591) is plausible given this difference.

- **WARN — cs_nt_with_ctrls returns 0 with status OK.** The `att_cs_nt_with_ctrls` field is 0 and `att_cs_nt_with_ctrls_dyn` is also 0, despite `cs_nt_with_ctrls_status = "OK"`. This is anomalous. A coefficient of exactly 0 with no SE is likely a model-fitting issue (possibly the doubly-robust estimator degenerating when `cs_controls` is empty but the `with_ctrls` path is attempted, or a variable name/availability problem). This should be investigated.

### 3. Direction and magnitude

- CS-DID NT (4.591) and TWFE (4.181) are directionally consistent and close in magnitude. The main result — a positive effect of women's political participation exposure on intrahousehold empowerment — is corroborated.
- The 10% gap is within expected range for the covariate difference and RCS structure.

### 4. Parallel trends

- With only 2 time periods, pre-trend testing is impossible in both TWFE and CS-DID. The CS-DID estimator's conditional parallel trends assumption rests on the validity of never-treated governorates (below-median protest intensity) as a counterfactual. This is a substantive assumption that cannot be empirically verified in these data.
- The paper notes that protest intensity is potentially endogenous (higher-intensity areas may differ systematically). The authors address this through geographic controls, but the parallel trends assumption remains untestable.

### 5. Never-treated vs. not-yet-treated

- NYT estimator not applicable (single timing, no not-yet-treated group possible). Correctly omitted.
- Never-treated comparison is the only available CS-DID variant.

### 6. RCS-specific concerns

- With repeated cross-section data, the CS-DID estimator computes group-time ATTs using conditional independence assumptions across different samples at each period, not the same individuals. This is valid statistically but means the "treatment effect" captures a combination of individual-level effects and compositional differences across survey waves (2008 vs. 2014). This limitation is inherent to the data, not the replication.

---

## Summary

CS-DID NT (no controls) corroborates the TWFE sign and approximate magnitude. Two WARNs are flagged: (1) the CS-DID estimate was produced without covariates while TWFE uses a rich control set — the comparison is not apples-to-apples; (2) the "with controls" CS-DID path returns 0, which is anomalous and warrants investigation. The overall conclusion from the paper (positive empowerment effect) is supported by the CS-DID results.

**Verdict: WARN**
