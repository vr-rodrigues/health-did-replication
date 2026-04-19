# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 359

**Article:** Anderson, Charles, Olivares, Rees (2019) — "Was the First Public Health Campaign Successful?"
**Reviewer:** dechaisemartin-reviewer
**Date:** 2026-04-18
**Verdict:** NOT_NEEDED

---

## Applicability assessment

The treatment in this study (`city_reporting_required`) is a binary indicator for whether a city is required to report TB cases. Based on the metadata:
- Treatment is binary (0/1).
- Treatment timing is staggered (16 cohorts, 1900–1917).
- Treatment appears to be absorbing: once a city is required to report, that requirement persists.
- No indication of de-adoption, continuous dosage, or heterogeneous intensity.

For standard absorbing binary staggered designs, the de Chaisemartin & D'Haultfoeuille (2020) heterogeneity-robust estimator addresses the same concern as Callaway-Sant'Anna. Given that CS-DID has already been applied and reveals a sign reversal, the additional information from a DH2020 estimator would be confirmatory.

The `gvar_CS` construction confirms absorbing treatment: `first_yr = min(year)` where `city_reporting_required == 1`, with `gvar_CS = first year of treatment`. No reversal or dose variation is coded.

## Assessment of continuous/non-absorbing treatment risk
- Treatment variable: `city_reporting_required` — binary regulatory status.
- No evidence of partial compliance or dose heterogeneity in the metadata.
- The paper uses only this single treatment indicator (not all 13 other campaign measures). This is a deliberate restriction to the cleanest absorbing binary instrument.

## Verdict
This is a standard absorbing binary staggered design. The DH2020 estimator is NOT_NEEDED as the CS-DID framework already covers this case. The sign reversal identified by CS-DID is the primary concern — DH2020 would yield qualitatively similar results.

**Verdict: NOT_NEEDED** — Standard absorbing binary staggered design; CS-DID already covers this case.

