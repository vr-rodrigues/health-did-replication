# CS-DID Reviewer Report — Article 253 (Bancalari 2024)

**Verdict:** WARN

**Date:** 2026-04-18

## Checklist

### 1. Estimator configuration
- CS-NT (never-treated): run=true. ATT(simple)=2.569, ATT(dynamic)=2.974, SE(simple)=1.352, SE(dynamic)=1.651.
- CS-NYT (not-yet-treated): run=true. ATT(simple)=2.509, ATT(dynamic)=2.949, SE(simple)=1.033, SE(dynamic)=1.280.
- No controls (`cs_controls=[]`), consistent with paper's main specification.
- `allow_unbalanced=false`: balanced panel enforced.

### 2. Paper comparison (CS-DID)
- Paper reports CS-DID ATT = +1.79 (notyet control group, dynamic aggregation, Stata `csdid ... notyet agg(event) long2`).
- Our CS-NYT dynamic ATT = 2.949 (SE=1.280) — 64.7% above the paper's 1.79.
- Our CS-NYT simple ATT = 2.509 — 40% above paper.
- **Gap is documented in metadata notes**: pair-balanced NYT ATT=1.78 matches paper exactly. The divergence arises from R's `allow_unbalanced_panel=TRUE` behaviour in `att_gt` for late cohorts (2014-2015) producing extreme values (-8.6, -6.4 for those cohorts) that inflate the dynamic aggregation.

### 3. CS-NT vs CS-NYT consistency
- CS-NT dynamic (2.974) and CS-NYT dynamic (2.949) are internally consistent, differing by only 0.8%.
- This near-convergence is expected when the not-yet-treated pool is large (78% of districts have at least some pre-treatment period). The consistency across comparison groups is reassuring.

### 4. CS-DID pre-trends (event study)
- CS-NT pre-period coefficients:
  - t=-6: -0.802 (SE=2.22) — insignificant
  - t=-5: -1.432 (SE=1.80) — insignificant
  - t=-4: -0.565 (SE=1.20) — insignificant
  - t=-3: +1.661 (SE=1.03) — **borderline (t=1.62, 90% CI includes zero but marginally)**
  - t=-2: -0.212 (SE=0.68) — insignificant
- The t=-3 coefficient is elevated (+1.661) and represents a potential anomaly. It does not reach conventional significance (p>0.10) but is the largest pre-period deviation.
- CS-NYT pre-period shows similar pattern: t=-3=+1.075 (SE=0.865, t=1.24).

### 5. Cohort-level issues
- Cohort 2005 (78 units) is dropped in R's `att_gt` with `base_period="universal"` because there is no pre-treatment period. This is structurally unavoidable.
- Late cohorts 2014 and 2015 are small (estimated from metadata: few units), making their ATT(g,t) estimates noisy and potentially extreme when using unbalanced-panel estimation.
- Metadata notes confirm that using pair-balanced estimation recovers the paper's 1.79 exactly — the divergence is a software/aggregation artefact, not a substantive finding.

### 6. Verdict reasoning
The CS-DID implementation is correctly specified. The 65% gap from the paper's reported 1.79 is explained by R vs Stata aggregation differences for late-cohort ATT(g,t) values, documented in the metadata. However, the discrepancy is large enough to warrant a WARN: users comparing our stored dynamic ATT to the paper will see a substantial difference. The t=-3 pre-trend elevation (though insignificant) also merits attention. The simple ATT (2.509/2.569) and the direction of the effect are robust.

**Verdict: WARN** — Gap from paper's CS-NYT value (+65% dynamic; +40% simple) is software-aggregation driven but large; t=-3 CS-NT pre-period slightly elevated.

_Full data path: `results/by_article/253/results.csv`, `results/by_article/253/event_study_data.csv`_
