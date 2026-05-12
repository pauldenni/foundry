# Forge — the /ship command

> Quick reference for running the full pipeline. Full stage definitions are in pipeline-logic.md.

---

## Usage

```
/ship [feature description or ticket title]
```

**Examples:**
```
/ship add notifications panel
/ship ticket: "User can export data as CSV"
/ship fix the broken pagination on the activity feed
```

---

## What /ship does

Runs the full pipeline in sequence:

```
Intake → Plan → Design* → Build → Review → Test → Fix* → Output
```

`*` = conditional (Design skipped for non-UI work, Fix only runs if QA blocks)

Produces a ship summary with all files, test results, and follow-up tickets. Does not deploy — that step is always yours.

---

## Hard gates

These block `/ship` unconditionally. No override, no exceptions.

### Gate 1 — Ticket completeness
The PM stage must produce a ticket with:
- At least 2 testable acceptance criteria (Given/When/Then)
- An explicit out-of-scope list
- A definition of done

A `/ship` with no ticket and no describable requirements stops at intake.

### Gate 2 — No scope conflicts
The request must not conflict with `project-context.md` non-negotiables or out-of-scope list. If it does, `/ship` halts at intake with a clear explanation.

### Gate 3 — Build plan before code
FE and BE must each produce a build plan (files listed) before writing any code. No plan → code does not start.

### Gate 4 — Self-review must pass
Both FE and BE must complete and pass their self-review checklists. Items cannot be left blank. Failing items must be resolved before QA.

### Gate 5 — Tests must exist and pass
Every new component ships with a test file. Every new API endpoint ships with an integration test. No exceptions. If tests can't be written, the reason must be explicitly documented — the gap is not silently skipped.

### Gate 6 — QA must approve
QA produces a full report and issues a verdict. BLOCKED means the fix loop runs. APPROVED (or APPROVED WITH NOTES) means output is produced. QA cannot be skipped or overridden.

### Gate 7 — No active BLOCKERs
No code ships with an unresolved BLOCKER from QA. WARNINGs can ship if a follow-up ticket is created. NOTEs can ship with no action required.

### Gate 8 — No security violations
The security scan from `security-rules.md` must pass. Any of the following are automatic BLOCKERs regardless of other QA findings:
- Hardcoded secret, token, or credential in any file
- Unauthenticated endpoint without annotation + justification
- User input used without validation
- Authorization missing on data access
- Sensitive data in logs or error responses
- `.env` not in `.gitignore`

---

## Pipeline variations

### Full pipeline (feature with UI + API)
```
Intake → PM → Designer → FE → BE → QA → Output
```
BE runs after FE by default. If FE depends on the API, BE runs first with the contract defined upfront.

### API-only pipeline
```
Intake → PM → BE → QA → Output
```
Designer skipped. QA focuses on contract correctness, auth, validation, and tests.

### UI-only pipeline
```
Intake → PM → Designer → FE → QA → Output
```
BE skipped. QA focuses on spec compliance, states, accessibility, and component tests.

### Bug fix pipeline (known cause)
```
Intake → PM (quick ticket) → FE or BE → QA → Output
```
PM produces a minimal ticket — summary + acceptance criteria only. Design skipped unless the fix requires UI changes.

### Bug fix pipeline (unknown cause)
```
Intake → QA (diagnose) → PM (ticket) → FE or BE → QA (verify) → Output
```
QA diagnoses first, produces a diagnosis report, PM writes the ticket from that, then the responsible engineer fixes.

### Refactor pipeline
```
Intake → PM (scope) → FE or BE → QA → Output
```
QA specifically verifies: behavior unchanged, existing tests still pass, no regression.

---

## Fix loop quick reference

When QA blocks:

1. QA outputs fix brief(s) — one per blocker
2. Engineer receives fix brief, fixes only that issue
3. Engineer reports: "Fixed [issue]. Changed [file/function]. Reason: [brief]."
4. QA re-reviews affected items only
5. If resolved → continue to output
6. If not resolved → repeat, max 3 iterations
7. After 3 failures → escalation report to human

**Fix loop rules:**
- Engineer changes **only** what the fix brief specifies
- No other "while I'm in here" changes
- Each fix is described explicitly before QA re-reviews
- If a fix requires a scope change → escalate immediately, don't improvise

---

## What /ship will not do

- Deploy code — it produces a shippable artifact, you deploy
- Skip QA — ever, under any circumstances
- Ship with a BLOCKER — the fix loop runs first
- Generate code that violates security rules
- Write a ticket for work that's out of scope
- Proceed past intake if requirements are ambiguous
- Silently expand scope during Build
- Leave placeholder logic (`// TODO`, fake returns, `if (isDev)` bypasses) in output

---

## /ship vs individual commands

Use `/ship` when you want the full pipeline run end-to-end.

Use individual commands when you want to run one stage:

| You want to... | Command |
|---|---|
| Just write a ticket | `/pm new [description]` |
| Just spec a component | `/design spec [component]` |
| Just build a component | `/fe build [task]` |
| Just build an endpoint | `/be api [description]` |
| Just review existing code | `/qa review [file]` |
| Just fix a known issue | `/fix [description]` |
| Fix then verify | `/fix [description]` → QA auto-runs after |

Individual commands still produce their stage's output and checklist — they just don't run the full pipeline.

---

## Annotated /ship example

**Input:** `/ship add ability for users to mark a notification as read`

**Stage 1 — Intake:**
> Pipeline intake: Mark notification as read
> Input parsed as: feature description
> Ticket exists: NO — PM will create one
> Stages active: Plan ✓, Design ✓ (UI change), Build FE ✓ BE ✓, Test ✓
> Scope check: CLEAR
> Starting stage 2: Plan.

**Stage 2 — Plan (PM):**
> PM — Writing ticket for "Mark notification as read"
> [produces ticket with 4 acceptance criteria, edge cases, definition of done]
> Handing to Designer.

**Stage 3 — Design:**
> Designer — Speccing the read/unread state change on NotificationItem
> [produces spec: unread dot, read styling, optimistic update behavior, accessibility]
> Handing to Frontend Engineer.

**Stage 4 — Build (FE first, then BE):**
> FE — Build plan: 2 files (NotificationItem update + test update)
> [builds updated component with read/unread states]
> [self-review: all pass]
> Handing to Backend Engineer.

> BE — API contract: PATCH /api/notifications/:id/read
> [builds endpoint with auth, authorization, validation, test]
> [self-review: all pass]
> Handing to QA.

**Stage 6 — Test (QA):**
> QA — Reviewing mark notification as read
> [runs full report]
> Verdict: BLOCKED
> Blocker: FE component makes optimistic update but doesn't handle the
> rollback if the PATCH request fails. User sees notification as read
> even when the API call fails silently.

**Stage 7 — Fix loop (iteration 1):**
> Fix brief → FE
> FE: "Fixed. Added error handler that rolls back the optimistic update
> and shows an inline error toast if the PATCH fails. Changed
> NotificationItem.tsx lines 44–67."
> QA re-reviews: PASS

**Stage 8 — Output:**
> Ship summary: Mark notification as read
> Status: READY TO SHIP
> [lists files, tests, no follow-up tickets, no new decisions to log]
> Next step: review files and deploy when ready.
