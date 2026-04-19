# HonestDiD Reviewer Report — Article 419

**Verdict:** NOT_APPLICABLE

**Article:** Kahn, Li, Zhao (2015) — "Water Pollution Progress at Borders"
**Date:** 2026-04-18

---

## Applicability check

HonestDiD applies iff `has_event_study == true` AND at least 3 pre-periods.

Article 419 has `has_event_study == true` but only `event_pre == 2` pre-periods (t=-2 is the only free pre-period; t=-1 is the reference period). With only 1 free pre-period (after excluding the reference), the Mbar sensitivity test cannot be meaningfully computed — the linear extrapolation from a single pre-period is degenerate.

HonestDiD is NOT APPLICABLE for this paper. The limitation on pre-periods is a design feature of the original study.

Note: The positive pre-period coefficient at t=-2 (+1.609 TWFE, +1.682 CS-NT) is flagged here as a qualitative concern, but formal HonestDiD sensitivity cannot be computed.
