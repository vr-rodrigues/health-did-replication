# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 76 (Lawler & Yewell 2023)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability check

The de Chaisemartin & D'Haultfoeuille (2020) estimator is primarily needed when:
- Treatment is **non-absorbing** (units can switch treatment status on and off), OR
- Treatment is **continuous** with a heterogeneous dose, OR
- There are explicit concerns about sign-reversal from negative TWFE weights in a non-binary setting.

### Assessment for article 76

The treatment in this paper (`Post_avg` = `baby_babyfr × post6`) is:
- **Binary absorbing at the county-hospital level**: once a hospital becomes baby-friendly, it does not de-certify within the study period.
- **Continuous at the county level**: `baby_babyfr` is the share of baby-friendly hospitals in the county. This varies 0–1 continuously.

The continuous-dose aspect does raise a question about the de Chaisemartin estimator. However:
1. The paper explicitly models this as a continuous treatment (share × post), not as a switching treatment.
2. The CS-DID already handles staggered binary adoption at the county level (using county-level adoption as the group variable).
3. The de Chaisemartin & D'Haultfoeuille (2020) `did_multiplegt` estimator is designed for the switching case, not for dose-response heterogeneity.
4. No evidence of switching (treatment reversal) is present in the data.

The Bacon decomposition signals (see bacon-reviewer) show that later-treated units (2015 cohort) enter as "controls" with negative weights, but this is handled by the CS-DID comparison group specification, not by the de Chaisemartin estimator.

**Verdict: NOT_NEEDED** — Standard absorbing (at hospital level) staggered binary design. Continuous county-level dose is a design feature handled by the paper's TWFE specification, not a switching treatment requiring did_multiplegt.
