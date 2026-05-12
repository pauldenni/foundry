# Forge — decision log

> This file records significant technical and product decisions made on this project.
> The AI reads this before suggesting changes to ensure it doesn't "fix" intentional choices.
> Add an entry any time a decision was made that a future developer (or AI) might question.

---

## When entries get added

**Automatically — at the end of every `/ship` run.**
Pipeline Stage 8 (Output) writes a new entry to this file for any decision made during the run that meets the logging bar below. The entry is also surfaced in the ship summary so you can see exactly what was logged and edit or remove it if you disagree.

**Manually — anytime, in or out of a session.**
- `/log [decision]` — log a decision made outside any pipeline (offline call, meeting outcome, choice made in another tool). The PM persona formalizes the entry and appends it directly to this file.
- `/pm log [decision]` — same behavior, explicit PM routing.

**The logging bar.** Only log a decision when *all* of these are true:
1. It picks one option over a viable alternative (not "we used the obvious default")
2. It would not be obvious to a future developer or AI reading the code alone
3. It is intended to stick (not a temporary workaround or scaffolding)

If a "decision" is just following an established pattern or the only reasonable choice, skip it. The log is for things that need explanation.

**Inferring `Made by`.** For automatic entries, default to the human user as `Made by` (the AI proposes, the human owns the call). For `/log`-driven entries, use whatever the user states; if unspecified, default to the user.

---

## How to add an entry

Copy this template and fill it in (or let `/log` or `/ship` do it for you):

```
### [Short title of the decision]
**Date:** YYYY-MM-DD
**Status:** Active | Superseded by [link] | Reversed
**Made by:** [Person, team, or "unanimous"]

**Context:** What situation or problem prompted this decision?

**Options considered:**
- Option A: [description] — [why rejected]
- Option B: [description] — [why rejected]
- Chosen: [description]

**Reasoning:** Why this option was chosen over the others.

**Consequences:** What this decision means for the codebase going forward.
  Do not change this unless you've read this entry and explicitly decided to reverse it.
```

---

## Entries

---

### [Example] Use Zustand over Redux for state management
**Date:** YYYY-MM-DD
**Status:** Active
**Made by:** [Name]

**Context:** We needed a state management solution for cross-component UI state. The app is not large enough to justify Redux's boilerplate.

**Options considered:**
- Redux Toolkit: battle-tested, great devtools — too much ceremony for our scale
- React Context + useReducer: built-in, no deps — performance issues with frequent updates
- Chosen: Zustand — minimal API, no boilerplate, good TypeScript support

**Reasoning:** The codebase is mid-size and moving fast. Zustand gives us 90% of Redux's capability with 10% of the setup cost. We can migrate later if complexity warrants it.

**Consequences:** All global state lives in Zustand stores under `/src/stores/`. Do not introduce Redux or Context-based global state without reversing this decision.

---

### [Example] Soft deletes for all user content
**Date:** YYYY-MM-DD
**Status:** Active
**Made by:** [Name]

**Context:** Users complained about accidentally deleting content with no recovery path. Legal also flagged data retention requirements.

**Options considered:**
- Hard delete: simplest, lowest storage — irreversible, violates retention policy
- Chosen: Soft delete with `deleted_at` timestamp on all user-owned tables

**Reasoning:** Reversibility and auditability outweigh the storage and query complexity costs. All queries must filter `WHERE deleted_at IS NULL`.

**Consequences:** Every query against user content tables must include the soft-delete filter. An ORM default scope handles this — do not bypass it.

---

### [Example] No ORM for reporting queries
**Date:** YYYY-MM-DD
**Status:** Active
**Made by:** [Name]

**Context:** Complex reporting queries were unreadable and slow when expressed through the ORM. Raw SQL gave us better performance and clarity.

**Options considered:**
- ORM query builder for all queries: consistent but produced N+1 issues and unreadable code for joins
- Chosen: Raw SQL for anything in `/src/queries/reports/`, ORM for CRUD operations

**Reasoning:** The performance difference on aggregation queries was 10x. Readability of complex joins is significantly better in raw SQL.

**Consequences:** Reporting queries live in `/src/queries/reports/` as tagged template literals. Do not "clean up" these files by converting them to ORM syntax.

---

[Add real decisions below this line]

