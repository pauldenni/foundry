# Forge — quality gates

> This file defines every gate in the pipeline in precise, checkable terms.
> Gates are enforced by the persona responsible for that stage.
> QA re-checks all gates before issuing a ship verdict.
> No gate can be waived. Partial passes do not exist.

---

## Gate 1 — Ticket completeness (PM → Build)

**Enforced by:** PM before handoff to Designer or Build
**Re-checked by:** QA at the start of the Test stage

A ticket is complete when it has all of the following:

| Item | Requirement |
|---|---|
| Summary | 1–2 sentences, describes what is being built and why |
| Acceptance criteria | Minimum 2, all in Given/When/Then format, all independently testable |
| Out of scope | At least one explicit exclusion — even "nothing else" counts |
| Edge cases | At least one edge case addressed per category (data, user, error) |
| Definition of done | Checklist format, includes QA sign-off |

**Failure looks like:**
- "The page should work correctly" — not testable, not Given/When/Then
- No out-of-scope list — engineer doesn't know where to stop
- Missing edge cases — engineer builds happy path only
- No definition of done — ship criteria undefined

**Gate failure action:** PM rewrites the failing section before any other stage starts.

---

## Gate 2 — Design spec completeness (Designer → Build)

**Enforced by:** Designer before handoff to FE
**Re-checked by:** QA during Test (states coverage check)

A design spec is complete when it has all of the following:

| Item | Requirement |
|---|---|
| Layout | ASCII sketch or structured description — not "a list with some buttons" |
| Components | Every component named, described, and its contents listed |
| Default state | Fully described — what the user sees when everything is working |
| Loading state | Specific — skeleton vs spinner vs disabled, not just "loading indicator" |
| Empty state | Fully described — illustration/icon, headline, body, CTA (or explicit "no CTA") |
| Error state | Fully described — inline vs toast vs redirect, exact error copy |
| Interactions | Every clickable, hoverable, focusable element has a described behavior |
| Copy | All user-facing text specified — no TBD, no Lorem Ipsum |
| Accessibility | ARIA roles, keyboard navigation, focus management — all listed |
| Design system | Existing components referenced, new ones flagged |

**Failure looks like:**
- Loading state described as "show a spinner" with no detail on placement or duration
- Empty state with "TBD copy"
- No error state defined
- Accessibility section blank or "standard"

**Gate failure action:** Designer adds the missing sections before FE starts building.

---

## Gate 3 — Build plan (Build start)

**Enforced by:** FE and BE before writing any code
**Re-checked by:** QA (confirms files match what was planned)

A build plan is complete when it lists:

| Item | Requirement |
|---|---|
| All files to be created | Path + one-line description for each |
| All files to be modified | Path + description of what changes and why |
| New dependencies | Listed with justification, or "none" |
| New patterns | Listed with description, or "none" |
| Database changes | Migration required yes/no, described if yes |

**Failure looks like:**
- Code appears without a build plan
- Build plan lists 2 files but 4 files are produced
- New dependency introduced without listing it

**Gate failure action:** Stop, produce the build plan, then continue.

---

## Gate 4 — Code completeness (Build → Review)

**Enforced by:** FE and BE at end of Build
**Re-checked by:** QA during Test

Code is complete when:

| Item | Requirement |
|---|---|
| File path comment | Top of every file: `// src/path/to/file.ts` |
| No snippets | Every file is complete and runnable — no `// rest of implementation here` |
| No stubs | No fake returns, no `if (isDev)` bypasses, no hardcoded data masquerading as real |
| No TODOs in production paths | TODOs in comments are fine; TODOs as the implementation are not |
| No debug artifacts | No `console.log`, no commented-out code blocks, no test data left in |
| Typed | No untyped props, no implicit `any`, no untyped function returns (TS projects) |

**Failure looks like:**
```typescript
// FAIL — stub disguised as implementation
export async function getNotifications(userId: string) {
  // TODO: implement
  return []
}

// FAIL — debug artifact
console.log('user data:', user)

// FAIL — fake bypass
if (process.env.NODE_ENV === 'development') {
  return { success: true } // skip real logic in dev
}
```

**Gate failure action:** FE/BE fixes before self-review checklist is submitted.

---

## Gate 5 — Self-review checklist (Build → QA)

**Enforced by:** FE and BE — must be output explicitly, not just mentally checked
**Re-checked by:** QA — verifies the checklist items independently

**FE — all items must be checked or have a documented exception:**

```
Spec compliance:
- [ ] All states implemented: loading, empty, error, default
- [ ] Layout matches spec
- [ ] Copy matches spec exactly
- [ ] All interactions implemented

Code quality:
- [ ] No hardcoded strings that should be config
- [ ] No console.log or debug code
- [ ] No `any` types without documented inline reason
- [ ] All props typed
- [ ] No unused imports

Tests:
- [ ] Test file exists and is co-located
- [ ] All spec states have a test
- [ ] User interactions tested
- [ ] Edge cases from ticket tested
- [ ] All tests passing

Accessibility:
- [ ] Semantic HTML (buttons are <button>, not <div>)
- [ ] ARIA labels where spec requires
- [ ] Keyboard navigation works
- [ ] Focus management correct

Patterns:
- [ ] Follows pattern-library.md
- [ ] No new unreviewed dependencies
```

**BE — all items must be checked or have a documented exception:**

```
Security:
- [ ] Auth check on every new endpoint
- [ ] Authorization — user accesses only their own data
- [ ] All input validated with schema before use
- [ ] No raw SQL concatenation
- [ ] No secrets or credentials in code
- [ ] No sensitive data in console.log
- [ ] Generic error messages to client

Correctness:
- [ ] API contract matches plan
- [ ] All acceptance criteria addressed
- [ ] All async ops have error handling
- [ ] Edge cases handled

Tests:
- [ ] Integration test exists for every new endpoint
- [ ] 401 test (unauthenticated)
- [ ] 404/403 test (wrong user's data)
- [ ] 200 test (happy path, correct response shape)
- [ ] 400 test (invalid input)
- [ ] Error path test
- [ ] All tests passing

Code quality:
- [ ] File path comment at top
- [ ] API contract comment block at top of route file
- [ ] No unused imports
- [ ] Follows pattern-library.md
```

**Documented exception format:**
If an item cannot be checked, it must be explicitly flagged inline:
```
- [~] No `any` types — EXCEPTION: third-party library returns untyped response
  at src/lib/stripe.ts line 44. Typed wrapper added, any contained to that file.
```

Blank items or silent skips are gate failures.

**Gate failure action:** FE/BE completes all items or documents exceptions before QA starts.

---

## Gate 6 — Test coverage (QA)

**Enforced by:** QA
**Standard:** Every acceptance criterion has at least one test. Every spec state has at least one test. Every security surface (auth, authz, validation) has at least one test.

**Minimum test requirements by feature type:**

**UI feature:**
| Test | Required |
|---|---|
| Default state renders correctly | Yes |
| Loading state renders correctly | Yes |
| Empty state renders correctly | Yes |
| Error state renders + retry action works | Yes |
| Primary user interaction (click, submit, etc.) | Yes |
| Keyboard navigation | Yes if spec requires |
| Each acceptance criterion | Yes — one test per criterion |
| Each ticket edge case | Yes |

**API endpoint:**
| Test | Required |
|---|---|
| 401 — unauthenticated | Yes |
| 404 — another user's resource | Yes |
| 200 — happy path, correct response shape | Yes |
| 400 — invalid input (each validation rule) | Yes |
| 500 — service/db failure handled | Yes |
| Each acceptance criterion | Yes |
| Each ticket edge case | Yes |

**Gap handling:**
If a required test is missing and QA cannot write it (e.g. requires infrastructure not available in tests), QA must:
1. Document the gap explicitly in the QA report
2. Classify it as WARNING (not BLOCKER) if covered by another means
3. Classify it as BLOCKER if there is no coverage at all

---

## Gate 7 — Security scan (QA)

**Enforced by:** QA — runs on every `/ship` regardless of feature type
**Standard:** Every item must be PASS or N/A with documented reason

| Check | Pass condition | Auto-BLOCKER if fail |
|---|---|---|
| No hardcoded secrets | No tokens, keys, passwords, connection strings in any file | Yes |
| Auth on all endpoints | Every new endpoint has auth check or PUBLIC annotation | Yes |
| Input validation | All user-supplied data validated before use | Yes |
| Authorization | All data access checks ownership | Yes |
| No sensitive data in logs | No user objects, tokens, or PII in console.log | Yes |
| No sensitive data in responses | Error messages are generic, no stack traces | Yes |
| No raw SQL concat | All queries use parameterized or ORM | Yes |
| .env in .gitignore | Confirmed present | Yes |
| No wildcard CORS on auth'd routes | Checked in middleware/config | Yes |
| Dependency audit | npm audit / equivalent passes, no high/critical CVEs | No — WARNING |
| Rate limiting on auth endpoints | Present on login, register, reset | No — WARNING |
| Security headers | CSP and related headers present | No — WARNING |

Items marked "Auto-BLOCKER" fail the ship unconditionally.
Items not marked auto-BLOCKER are WARNINGs — can ship with follow-up ticket.

**N/A documentation:**
If a check is not applicable, QA must document why:
```
- Auth on all endpoints: N/A — this feature contains no new API endpoints
- No raw SQL concat: N/A — feature is UI-only, no database access
```

---

## Gate 8 — QA verdict (QA → Output)

**Enforced by:** QA
**Three possible verdicts:**

**APPROVED**
- All acceptance criteria: PASS
- All spec states: PRESENT
- All required tests: PRESENT and PASSING
- Security scan: all auto-BLOCKERs PASS
- No BLOCKER issues in QA report

**APPROVED WITH NOTES**
- All acceptance criteria: PASS
- All auto-BLOCKERs: PASS
- No BLOCKER issues
- One or more WARNING issues present
- Condition: a follow-up ticket must be created for each WARNING before approval is confirmed

**BLOCKED**
- One or more BLOCKER issues present
- Fix loop runs
- Ship does not proceed until BLOCKERs are resolved

**Verdict cannot be:**
- "Mostly approved"
- "Approved pending [thing]" — it's approved or it's not
- Issued without a complete QA report
- Changed after issuance without re-running the relevant checks

---

## Gate reference card

| Gate | Stage | Enforced by | Re-checked by |
|---|---|---|---|
| 1 — Ticket completeness | Plan | PM | QA |
| 2 — Spec completeness | Design | Designer | QA |
| 3 — Build plan | Build start | FE + BE | QA |
| 4 — Code completeness | Build end | FE + BE | QA |
| 5 — Self-review checklist | Build → QA | FE + BE | QA |
| 6 — Test coverage | Test | QA | — |
| 7 — Security scan | Test | QA | — |
| 8 — QA verdict | Test → Output | QA | — |
