# SKILL: LESSON ANNOTATOR
## Goal
After analyzing an article (profiler → analyst → reporter pipeline), review the findings
and annotate `lessons_discovered.md` with any new or reinforced insights.

---

## When to Invoke
- After completing the ANALYST stage for any article (new or revisited)
- After resolving a failure pattern that yielded a methodological insight
- After producing an event study that shows unexpected behavior (convergence, divergence, CI explosion, etc.)
- When the user explicitly asks to consolidate lessons from recent work

---

## Inputs Required
1. **Article ID** and author label
2. **results.csv** — point estimates (TWFE, CS-NT, CS-NYT)
3. **event_study.pdf** — visual patterns (if applicable)
4. **metadata.json** — design choices (controls, panel structure, treatment timing)
5. **Console output** from the analyst run (warnings, VCOV issues, filter messages)
6. **failure_patterns.md** — check if new pattern was added

---

## Lesson Structure (5 sections)

The lessons file is at:
`C:/Users/victo/.claude/projects/c--Users-victo-OneDrive-Pesquisas-disserta--o-replication-files/memory/lessons_discovered.md`

Sections:
- **0. CONTROLS** — How controls affect magnitude, pre-trends, and estimator viability
- **1. STATIC EFFECTS** — Sign, magnitude, significance; estimator convergence/divergence
- **2. DYNAMIC EFFECTS** — Timing, persistence, event-study patterns, window choices
- **3. R vs STATA** — Implementation-driven vs substantive variation
- **4. RCS vs PANEL** — Data structure effects on estimator viability and results

---

## Decision Protocol

For each finding from the article analysis:

### Step 1: Classify the finding
Ask: Does this finding relate to...
- Controls? → Section 0
- Point estimate (sign/magnitude/significance)? → Section 1
- Event study pattern (timing/persistence/window)? → Section 2
- R-Stata divergence or software artifact? → Section 3
- Panel vs RCS structure? → Section 4

### Step 2: Check if it's NEW or REINFORCING
- **Read the existing lessons** in the target section
- If finding matches an existing lesson: ADD the article ID to that lesson's article list
- If finding is genuinely new: CREATE a new subsection with the next sequential number

### Step 3: Write the annotation
Format for each lesson entry:
```
## X.N [Title — concise, descriptive]
**Artigos**: ID [id] ([Author]), [other IDs if reinforcing]
**Patterns [N]** (if linked to a failure pattern)
[2-5 sentences describing the finding, what happened, and why it matters]
**Lição**: [1-sentence takeaway in Portuguese]
```

### Step 4: Update the reverse index (if exists)
If a reverse index table exists at the bottom of the file, add the new article ID
with pointers to all lessons it contributed to.

---

## Rules

1. **NEVER delete existing lessons** — only add or extend
2. **NEVER change the section structure** (0-4) without user approval
3. **Language**: All lesson content in Portuguese (matching existing file)
4. **Pending items**: Mark with `[PENDENTE]` if the lesson requires future implementation
5. **Article IDs**: Always use the result_id (not stata_id). Reference by `ID [result_id] ([Author surname])`
6. **Deduplication**: Before adding, grep for the article ID in the lessons file. If already referenced, only add if the NEW finding is genuinely different from what's documented
7. **Exclude triple-DiD**: Do not annotate findings from triple-DiD designs (user decision)
8. **Conservative**: When in doubt whether a finding is a "lesson" vs an implementation detail, err on the side of NOT adding. Lessons should be generalizable insights, not article-specific debugging notes

---

## Quality Checks

Before finalizing annotations:
- [ ] Each new lesson has at least one concrete article example
- [ ] Lesson is phrased as a generalizable insight, not a debugging note
- [ ] No duplication with existing lessons (check by theme, not just article ID)
- [ ] Connected to a failure pattern number when applicable
- [ ] Section numbering is sequential (no gaps)

---

## Communication Protocol

Success: `[Lesson Annotator][id] Added N new lessons, reinforced M existing lessons`
Nothing new: `[Lesson Annotator][id] No new lessons — findings already documented`

---

## Cross-References

- Failure patterns: `knowledge/failure_patterns.md`
- Estimator protocol: `knowledge/estimator_standardization.md`
- Outcome selection: `outcome_selection_protocol.md`
- Memory index: `C:/Users/victo/.claude/projects/c--Users-victo-OneDrive-Pesquisas-disserta--o-replication-files/memory/MEMORY.md`
