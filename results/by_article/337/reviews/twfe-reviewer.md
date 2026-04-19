# TWFE Reviewer Report: Article 337 — Cameron, Seager, Shah (2021)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. Specification fidelity
- Treatment variable: `dd_cl` (pre-constructed DiD composite = closing * el). This is algebraically correct for a 2x2 DiD with worksites as units and waves as periods.
- Fixed effects: wsid (worksite) + wave. Matches paper's `areg sept_any dd_cl el, abs(wsid) cluster(wsid)`.
- Controls: none (no_controls group). Paper's Table II Col 1 Panel A also has no controls.
- Sample filter: `dataset == 1 & !is.na(sept_any)` — correctly restricts to the STI-test subsample (N=459 person-wave observations, 12 worksites).

### 2. Coefficient replication
- Stored TWFE: **0.2726**
- Paper (Table II Col 1 Panel A): **0.273**
- Difference: 0.0004 (0.15%) — within floating-point rounding; EXACT match.

### 3. Standard error note (DOCUMENTED NON-ISSUE)
- Stored conventional clustered SE: **0.0316**
- Paper-reported SE: **0.101** (wild cluster bootstrap percentile-t, Cameron, Gelbach, Miller 2008)
- The 3.2x gap is expected and documented. With only 6 treated clusters, conventional cluster-robust SEs severely understate inference uncertainty. The paper appropriately uses wild bootstrap. The conventional SE stored in results.csv is the correct output of feols(); the paper's inferential standard is different. This is NOT a replication failure — it is a known limitation documented in the metadata notes.

### 4. Negative-weight concern
- With 2 periods and single treatment timing, the TWFE estimand is a clean 2x2 DiD.
- There are no negative weights (by construction in a 2x2 design).
- No staggered timing, so no Callaway-Sant'Anna heterogeneity concerns from TWFE weighting.

### 5. Design context
- N = 12 worksites (6 treated, 6 control). Extremely small sample.
- 2 periods only (baseline Feb-Mar 2014, endline May-Jun 2015).
- Single sharp treatment (Nov 2014 closings).
- The design is clean but severely underpowered for any conventional inference. Wild bootstrap corrects for few-cluster inference.

## Material findings
- None that constitute methodological failure.
- Conventional SE stored in results.csv (0.0316) is dramatically smaller than the bootstrap SE reported by the paper (0.101). Any downstream user should use the paper's bootstrap p-values for inference, not the stored SE.

## Verdict rationale
The TWFE coefficient is reproduced exactly. The SE divergence is expected, documented, and not a methodological error — the paper explicitly accounts for it via wild bootstrap. The 2x2 design is free of negative-weight concerns. PASS.
