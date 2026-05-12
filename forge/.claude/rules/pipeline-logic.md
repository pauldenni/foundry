# Forge — pipeline logic

> This file defines the mechanics of the full build pipeline — what happens at each
> stage, in what order, what each stage must produce, and what causes it to halt.
> Every `/ship` command runs this pipeline. Individual persona commands (/fe, /be, etc.)
> run their respective stage only. QA always runs last.

---

## Pipeline overview

```
/ship [feature or ticket]
        │
        ▼
┌─────────────────┐
│   1. INTAKE     │  Parse request, load context, validate scope
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   2. PLAN       │  PM writes or validates the ticket
└────────┬────────┘
         │ ticket + acceptance criteria
         ▼
┌─────────────────┐
│   3. DESIGN     │  Designer specs UI (skipped if no UI)
└────────┬────────┘
         │ design spec (or skip)
         ▼
┌─────────────────┐
│   4. BUILD      │  FE and/or BE build against spec + ticket
└────────┬────────┘
         │ code files + self-review checklists
         ▼
┌─────────────────┐
│   5. REVIEW     │  Each engineer self-reviews their output
└────────┬────────┘
         │ reviewed code
         ▼
┌─────────────────┐
│   6. TEST       │  QA audits, runs/writes tests, produces report
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
  PASS      FAIL
    │         │
    │         ▼
    │  ┌─────────────┐
    │  │  7. FIX     │  Engineer fixes blocker (max 3 iterations)
    │  └──────┬──────┘
    │         │ loops back to TEST
    │         │
    ▼         ▼ (after 3 failures → ESCALATE)
┌─────────────────┐
│   8. OUTPUT     │  Produce final artifact, ship summary, decision log update
└─────────────────┘
```

---

## Stage definitions

---

### Stage 1 — Intake

**Purpose:** Understand what's being shipped and confirm it's buildable before any work starts.

**Steps:**
1. Read `project-context.md` — confirm stack, conventions, non-negotiables
2. Read `decision-log.md` — note any decisions relevant to this feature
3. Parse the `/ship` input — is this a ticket reference, a feature description, or a free-form request?
4. Check scope against `project-context.md` non-negotiables and out-of-scope list
5. Identify which pipeline stages are needed (does this have UI? does it need a migration?)

**Intake output:**
```
## Pipeline intake: [feature name]

**Input parsed as:** [ticket / feature description / free-form]
**Ticket exists:** YES — [title] | NO — PM will create one

**Stages active:**
- [x] Plan (PM)
- [x] Design (Designer) — [reason: has UI / skipped: API only]
- [x] Build — FE: [yes/no], BE: [yes/no]
- [x] Review
- [x] Test (QA)

**Scope check:** CLEAR | CONFLICT — [describe conflict if any]
**Decision log flags:** [none / list relevant decisions to watch]

Starting stage 2: Plan.
```

**Hard stops at intake:**
- Scope conflicts with a non-negotiable → halt, explain, propose compliant alternative
- Request is too vague to produce acceptance criteria → ask one clarifying question, wait

---

### Stage 2 — Plan (PM)

**Purpose:** Produce a ticket with testable acceptance criteria. Nothing gets built without one.

**Input:** Feature description or existing ticket reference
**Output:** Completed ticket in PM format (see pm-commands.md)

**Stage gate — Plan must produce:**
- [ ] Summary (1–2 sentences)
- [ ] At least 2 acceptance criteria in Given/When/Then format
- [ ] Explicit out-of-scope list (even if just "nothing else")
- [ ] Edge cases section
- [ ] Definition of done

**If the ticket already exists and is complete:** PM reviews it, confirms it passes the gate, and passes it through unchanged or with minor additions flagged.

**Handoff to Design (or Build if no UI):**
```
--- Handoff to Designer ---
From: PM
Task: [feature name]
Input artifacts: Ticket — [title]
Instructions: Produce a design spec covering all components and states
  required by the acceptance criteria.
Constraints: [any design system constraints from project-context.md]
```

---

### Stage 3 — Design (Designer)

**Purpose:** Define exactly what gets built before any code is written. Every state, every component, every accessibility requirement.

**Input:** PM ticket
**Output:** Design spec in Designer format (see designer-commands.md)

**Skipped when:** The feature has no user-facing UI (API-only, background job, data migration, etc.). Orchestrator announces the skip: "No UI — skipping Design stage."

**Stage gate — Design must produce:**
- [ ] Layout description or ASCII sketch
- [ ] All components listed with descriptions
- [ ] All states defined: default, loading, empty, error (minimum)
- [ ] All user-facing copy specified (no "TBD")
- [ ] Accessibility requirements listed
- [ ] Design system notes (what's used, what's new)

**Handoff to Build:**
```
--- Handoff to Frontend Engineer ---
From: Designer
Task: Implement [feature name]
Input artifacts: Design spec — [name], Ticket — [title]
Instructions: Implement all components and states from the spec.
  Build plan required before any code.
Constraints: [stack constraints, existing components to use]
```

---

### Stage 4 — Build (FE and/or BE)

**Purpose:** Write complete, working code against the spec and ticket.

**Input:** Design spec (FE) + PM ticket (both)
**Output:** Complete code files + self-review checklists

**FE and BE run sequentially, not in parallel.** Default order: FE first, then BE. Exception: if BE needs to ship an API that FE depends on, BE runs first with the API contract defined upfront so FE can build against it.

**Each engineer must:**
1. Output a build plan (files to create/modify) before writing any code
2. Write complete files — no snippets, no stubs
3. Write tests alongside the code — not after
4. Run and pass their self-review checklist before handing off

**Stage gate — Build must produce:**
- [ ] Build plan (files listed before code)
- [ ] Complete code files with file path comments
- [ ] Test files co-located or alongside each code file
- [ ] Self-review checklist — all items checked or flagged
- [ ] No items on the self-review checklist left blank

**If BE needs to run first (FE depends on the API):**
```
--- Handoff to Backend Engineer ---
From: Orchestrator
Task: Define API contract and build [endpoint] before FE starts
Input artifacts: Ticket — [title]
Instructions: Output API contract first. FE will build against it.
  BE must complete before FE starts.
Constraints: [auth requirements, existing patterns]
```

---

### Stage 5 — Review (Self-review by engineers)

**Purpose:** Each engineer catches their own issues before QA. This is not a separate stage in time — it's the self-review checklist run at the end of Build. It's listed as a stage because it's a gate: code that fails self-review does not hand off to QA.

**FE self-review gate (all must pass):**
- [ ] All spec states implemented
- [ ] No console.log or debug code
- [ ] No `any` types without documented reason
- [ ] All props typed
- [ ] Tests written and passing
- [ ] ARIA labels present where spec requires
- [ ] No new unreviewed dependencies

**BE self-review gate (all must pass):**
- [ ] Auth check on every endpoint
- [ ] Authorization checks present
- [ ] All input validated
- [ ] No raw SQL concatenation
- [ ] No secrets in code
- [ ] Error handling on all async operations
- [ ] Tests written and passing
- [ ] Security rules checklist passed

**If self-review fails:** The engineer fixes the flagged items inline before handing to QA. QA is not involved in self-review — it's the engineer's own gate.

---

### Stage 6 — Test (QA)

**Purpose:** Independent verification that the code does what the ticket says, is secure, and is complete. QA is adversarial — it looks for what's wrong, not what's right.

**Input:** All code from Build + self-review checklists + PM ticket + design spec
**Output:** QA report with APPROVED or BLOCKED verdict

**QA runs in this order:**
1. Acceptance criteria check — does the code satisfy each criterion?
2. States coverage check — are all spec states implemented?
3. Edge cases check — are ticket edge cases handled?
4. Security scan — full checklist from `security-rules.md`
5. Test coverage check — are tests present and meaningful?
6. Final verdict

**Stage gate — QA must produce:**
- [ ] QA report in full format
- [ ] Every acceptance criterion explicitly reviewed (PASS or FAIL)
- [ ] Security scan completed and results listed
- [ ] Ship verdict: APPROVED or BLOCKED
- [ ] If BLOCKED: at least one fix brief for each blocker

**QA does not:**
- Suggest code improvements that aren't related to the ticket
- Rewrite code — it identifies issues and hands fix briefs to engineers
- Skip the security scan because it "looks fine"
- Approve a ship to make the pipeline move faster

---

### Stage 7 — Fix loop

**Purpose:** Resolve blockers raised by QA. Targeted, minimal, no scope creep.

**Trigger:** QA report contains one or more BLOCKERs.

**Mechanics:**

```
Iteration 1:
  QA → fix brief(s) → responsible engineer
  Engineer fixes only the identified issue(s)
  Engineer outputs: "Fixed [issue]. Changed [file], [function]. Reason: [brief]."
  Back to QA → re-reviews affected items only

Iteration 2 (if still blocked):
  Same process — new fix brief for remaining blockers
  QA re-reviews

Iteration 3 (if still blocked):
  Same process — final attempt

After 3 iterations with unresolved blockers:
  ESCALATE TO HUMAN
```

**Escalation format:**
```
## Pipeline escalation: [feature name]

**Blocker:** [description]
**Iterations attempted:** 3

**Attempt 1:**
- Fix applied: [description]
- QA result: still blocked because [reason]

**Attempt 2:**
- Fix applied: [description]
- QA result: still blocked because [reason]

**Attempt 3:**
- Fix applied: [description]
- QA result: still blocked because [reason]

**Current state of the code:** [brief description]
**Why it's stuck:** [honest assessment of what's making this hard to fix]
**Options:** [1–3 paths forward for the human to choose from]
```

**Fix loop rules:**
- Engineers fix **only** what the fix brief specifies — no other changes
- QA re-reviews **only** the affected items — not the full report again
- Each iteration's changes are clearly described — no silent modifications
- If a fix requires changing scope (e.g. the ticket itself was wrong), escalate immediately — don't fix it silently

---

### Stage 8 — Output

**Purpose:** Produce the final, clean artifact the human can act on.

**Input:** QA-approved code + QA report
**Output:** Ship summary

**Ship summary format:**
```
## Ship summary: [feature name]

**Status:** READY TO SHIP
**Ticket:** [title]
**QA verdict:** APPROVED [| APPROVED WITH NOTES — see follow-up tickets]

---

### What was built

[2–4 sentences describing what was built, not how]

### Files produced

**New files:**
- [path/file.ts] — [one-line description]
- [path/file.test.ts] — [what it tests]

**Modified files:**
- [path/file.ts] — [what changed]

### Tests

- [N] new tests added
- [N] existing tests modified
- All tests passing

### Follow-up tickets

[List any WARNINGs from QA that need follow-up tickets — include ticket title and brief description]
- [ ] [Ticket title] — [one line]

### Decision log

[Before producing this summary, any qualifying decision from this run was appended to `decision-log.md` automatically. The entries written are listed here for visibility — edit or remove them in the file if you disagree with the framing.]
- [decision title]: [one-line summary — full entry written to decision-log.md]
- [or "No qualifying decisions this run" if nothing met the logging bar]

---

**Next step:** Review the files above and deploy when ready.
**The pipeline does not deploy.** That step is yours.
```

---

## Pipeline state tracker

For multi-stage pipelines, the orchestrator maintains and can report state at any point via `/status`.

```
## Pipeline status: [feature name]

**Overall:** IN PROGRESS | BLOCKED | COMPLETE

| Stage | Status | Notes |
|---|---|---|
| 1. Intake | COMPLETE | |
| 2. Plan | COMPLETE | Ticket: [title] |
| 3. Design | COMPLETE / SKIPPED | |
| 4. Build — FE | COMPLETE / IN PROGRESS / PENDING | |
| 4. Build — BE | COMPLETE / IN PROGRESS / PENDING | |
| 5. Review | COMPLETE / PENDING | |
| 6. Test | COMPLETE / IN PROGRESS / PENDING | |
| 7. Fix loop | ITERATION [N] / NOT NEEDED | |
| 8. Output | COMPLETE / PENDING | |

**Current blocker:** [description or none]
**Artifacts so far:** [list of files produced]
```

---

## Pipeline rules

**One ticket per pipeline run.** `/ship` builds one thing. If a request spans multiple tickets, run the pipeline once per ticket in dependency order.

**No skipping stages.** Stages can be pruned (Design skipped for API-only work) but not bypassed. QA is never skipped.

**No retroactive changes.** Once a stage is complete and handed off, the previous stage does not revise its output unless QA raises a blocker that traces back to it. A PM ticket does not get quietly updated because the engineer found it inconvenient.

**Scope freeze at Build.** Once Build starts, the ticket is frozen. New requirements go in a new ticket. If something discovered during Build genuinely changes what should be built, stop, escalate, and get the ticket updated before continuing.

**Every pipeline run updates the decision log automatically.** Before the ship summary is produced, any decision made during the run that meets the logging bar in `decision-log.md` is appended directly to that file. The ship summary lists what was written so the human can review and adjust. No "please paste this into the log" prompts — the file is the source of truth and the AI writes to it.
