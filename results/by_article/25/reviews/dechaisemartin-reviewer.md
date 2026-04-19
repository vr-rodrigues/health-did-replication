# de Chaisemartin Reviewer Report: Article 25 — Carrillo, Feres (2019)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Treatment Characteristics
- Treatment: `POLICY = Treatment * post` (binary, absorbing)
- Treatment timing: staggered (multiple municipality cohorts)
- Absorbing: municipalities remain treated once physicians arrive
- No continuous dose / no heterogeneous dose at adoption
- No non-absorbing switching

## Assessment

### Applicability
The de Chaisemartin & D'Haultfoeuille (2020) DID_M estimator is most valuable when:
(a) Treatment is non-absorbing (units can switch off) — NO
(b) Treatment is continuous or has heterogeneous dose — NO
(c) Treatment has multiple levels — NO

This is a standard absorbing binary staggered design. CS-DID (Callaway-Sant'Anna) and SA already address heterogeneity-robust estimation for this design.

### Forbidden Comparison Evidence
- TWFE/CS-NT convergence: 1.3% gap (no controls) — inconsistent with large negative DID_M weights
- Pre-trends clean (3/4 pre-periods non-significant)
- Growing effects pattern consistent with no forbidden-comparison contamination

## Verdict: NOT_NEEDED
CS-DID provides the appropriate heterogeneity-robust estimate for this design. The 1.3% TWFE/CS convergence is inconsistent with significant DID_M negative-weight contamination. No additional diagnostic value from this estimator.
