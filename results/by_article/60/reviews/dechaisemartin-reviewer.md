# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 60 (Schmitt 2018)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability check
The de Chaisemartin & D'Haultfoeuille (2020) estimator (`did_multiplegt`) is designed for settings with:
- Non-absorbing (switching) treatment
- Continuous treatment
- Heterogeneous dose at adoption

For Schmitt (2018):
- Treatment indicator: `post` (binary, absorbing — once a hospital enters multimarket contact, it stays treated)
- Treatment is binary (0/1), not continuous or dose-varying
- Treatment is absorbing: hospitals do not switch in and out of multimarket contact
- This is a standard staggered binary absorbing DiD setting

The Callaway-Sant'Anna estimator (already run as CS-NT and CS-NYT) is the appropriate modern estimator for this design. The de Chaisemartin estimator is designed for different data structures and offers no additional insights beyond what CS-DID already provides.

## Decision
Standard absorbing binary staggered design: de Chaisemartin estimator is NOT_NEEDED. CS-DID already addresses the heterogeneous treatment timing concern.

**Verdict: NOT_NEEDED**
