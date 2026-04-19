# CS-DID Reviewer Report: Article 337 — Cameron, Seager, Shah (2021)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. CS-DID applicability
- With 2 periods and single treatment timing, the CS-NT estimator reduces algebraically to a standard 2x2 DiD (group 2 = treated in wave 2; group 0 = never-treated).
- This is the minimal case for CS-DID and is valid, though the estimator adds no identification power beyond TWFE in this setting.
- gvar_CS = 2 for closing==1, 0 otherwise: correctly specified.

### 2. Coefficient comparison
| Estimator | ATT | SE |
|---|---|---|
| TWFE | 0.2726 | 0.0316 |
| CS-NT (simple) | 0.2112 | 0.4340 |
| CS-NT (dynamic) | 0.2112 | 0.4436 |

- Gap: CS-NT is 22.5% smaller than TWFE (0.2112 vs 0.2726).
- Directional consistency: both positive.
- The 22.5% gap in an RCS design with N=12 worksites is within the bounds documented for RCS aggregation artefacts (Pattern 25 in knowledge base).

### 3. Standard error inflation — PRIMARY CONCERN
- CS-NT SE = 0.4340–0.4688 vs TWFE SE = 0.0316.
- SE ratio: **13.7x to 14.8x**.
- This renders the CS-NT t-statistic = 0.2112/0.4340 = **0.49** — completely uninformative.
- Root cause: the CS-DID bootstrap variance estimator (based on cluster-level resampling) is applied to N=6 treated worksites and N=6 control worksites. With only 6 treated clusters, the cluster bootstrap variance is extremely unstable.
- This is a known limitation of applying CS-DID to micro-RCT-scale datasets. It does not invalidate the coefficient, but makes the CS-NT result statistically uninformative.

### 4. Pre-trend assessment
- Only 2 periods — 0 pre-periods available.
- Pre-trends are untestable (no pre-period data).
- This applies equally to TWFE and CS-NT.

### 5. Forbidden comparisons
- Single treatment timing: no Later-vs-Earlier or Earlier-vs-Later pairs.
- All comparisons are Treated-vs-Untreated: clean by construction.

### 6. CS-NYT
- Not run (single treatment timing; all units treated simultaneously or never).
- Correct decision per applicability rules.

## Material findings
- **WARN**: CS-NT SE is 13.7–14.8x the TWFE SE, rendering the CS-NT result statistically uninformative (t=0.49). This is a structural consequence of applying CS-DID to N=6 clusters per arm.
- The 22.5% coefficient gap is within RCS aggregation norms but should be noted.
- No pre-trends testable; no forbidden comparisons.

## Verdict rationale
The CS-DID coefficient is directionally consistent with TWFE and the gap is within known RCS bounds. However, the extreme SE inflation renders the CS-NT estimate statistically uninformative for downstream use. This is not a fatal methodological failure (the coefficient is correct; the paper uses wild bootstrap for inference), but it represents a limitation of the CS-DID application at this sample size. WARN.
