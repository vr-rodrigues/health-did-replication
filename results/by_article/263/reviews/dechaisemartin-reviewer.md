# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 263

**Article:** Axbard, Deng (2024) — "Informed Enforcement: Lessons from Pollution Monitoring in China"
**Reviewer:** dechaisemartin-reviewer
**Date:** 2026-04-18

**Verdict:** NOT_NEEDED

---

## Applicability assessment

The de Chaisemartin & D'Haultfoeuille (2020) estimator (`did_multiplegt`) is most relevant when:
1. Treatment is non-absorbing (units can switch in and out of treatment), OR
2. Treatment is continuous or has heterogeneous dose at adoption, OR
3. The design has staggered adoption with potential for heterogeneous treatment effects across cohorts.

**Article 263 characteristics:**
- Treatment: binary, absorbing (firm is either within 10 km of monitor or not — a geographic assignment that does not change over time once the monitor is installed).
- Treatment timing: single date (Q1 2015, time=21) for all treated firms simultaneously.
- No dose heterogeneity — all treated firms receive the same binary treatment (proximity to monitor).
- No staggered adoption — all treated units adopt at the same time.

**Conclusion:** This is a standard absorbing binary single-timing design. The TWFE estimator with a single treatment date is equivalent to a clean 2x2 DiD. There are no forbidden comparisons (early vs. late adopters) because there is only one treatment cohort. The main threat addressed by de Chaisemartin & D'Haultfoeuille — heterogeneous effects across adoption cohorts contaminating the TWFE estimate — does not apply here.

The CS-DID analysis already adequately covers robustness for this design. The de Chaisemartin estimator adds no incremental insight for a single-timing design.

**Verdict: NOT_NEEDED** — standard absorbing binary single-timing design; no forbidden comparisons; CS-DID provides adequate robustness check.
