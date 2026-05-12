# Forge

**An AI development team for Claude Code. Raw intent goes in, production-ready code comes out.**

Forge is a Claude Code operating system — a set of structured instructions that turns Claude into a full development team with five specialized personas, a gated build pipeline, and a quality system that won't let broken code ship.

---

## What it is

Forge gives Claude a persistent identity across every session: a team of five personas that work in sequence, hand off to each other cleanly, and enforce quality gates before anything ships.

| Persona | Role |
|---|---|
| **PM** | Turns vague requests into scoped tickets with testable acceptance criteria |
| **Designer** | Specs every component, state, and interaction before a line of code is written |
| **Frontend Engineer** | Implements the spec using your codebase's established patterns |
| **Backend Engineer** | Builds secure APIs and data models against the ticket |
| **QA Engineer** | Independent gate — reviews everything, runs tests, blocks ships that don't pass |

An **Orchestrator** routes work between them, manages handoffs, and runs the fix loop when QA blocks.

---

## How it works

Every `/ship` runs the full pipeline:

```
Intake → Plan → Design → Build → Review → Test → Fix* → Output
```

Each stage has a gate. Nothing moves forward until the gate passes. QA is always last and can't be skipped or overridden. If QA blocks, a targeted fix loop runs — up to 3 iterations — before escalating to you.

The pipeline produces a ship summary with every file, every test result, and any follow-up tickets. It never deploys. That step is always yours.

---

## Commands

| Command | Does |
|---|---|
| `/ship [feature]` | Full pipeline: PM → Design → Build → Review → Test → Fix → Output |
| `/pm [request]` | Write or refine a ticket |
| `/design [component]` | Produce a design spec |
| `/fe [task]` | Build frontend code |
| `/be [task]` | Build backend code |
| `/qa [target]` | Review and test code |
| `/run [request]` | Free-form — Orchestrator routes it |
| `/review [file]` | Review existing code without building anything new |
| `/fix [issue]` | Fix a specific issue, then QA re-checks |
| `/context` | Print a summary of loaded context files |
| `/status` | Print the state of any in-progress task |
| `/log [decision]` | Add an entry to the decision log |

---

## What Forge won't do

- Ship with an unresolved QA blocker
- Skip tests to move faster
- Generate code that violates the security rules
- Write placeholder logic disguised as real implementation
- Silently "clean up" an intentional decision from the decision log
- Proceed when requirements are ambiguous — it asks one question, then builds
- Deploy — it produces the artifact, you deploy

---

## Setup

### 1. Copy the files into your project

```
your-project/
├── CLAUDE.md                        ← copy to project root
└── .claude/
    └── rules/
        ├── personas.md
        ├── orchestrator.md
        ├── pm-commands.md
        ├── designer-commands.md
        ├── fe-commands.md
        ├── be-commands.md
        ├── qa-commands.md
        ├── pipeline-logic.md
        ├── ship-command.md
        ├── quality-gates.md
        ├── project-context.md      ← fill this in
        ├── decision-log.md          ← append as you go
        ├── security-rules.md
        └── pattern-library.md
```

### 2. Fill in `project-context.md`

This is the one required step before your first session. Every persona reads this file first. Fill in your actual stack, conventions, and non-negotiables. The more specific you are, the better the output.

### 3. Run Claude Code

```bash
claude
```

Claude Code automatically discovers `CLAUDE.md` at your project root and all files in `.claude/rules/`. No configuration needed.

Verify everything loaded with `/context` at the start of your first session.

### 4. Tune after your first run

The defaults work for most Next.js/TypeScript projects. For other stacks, see `tuning-guide.md` — the main things to update are `project-context.md` (your stack details), `pattern-library.md` (replace the stubs with real patterns from your codebase), and `security-rules.md` (add any project-specific rules).

---

## File reference

| File | Purpose | Update frequency |
|---|---|---|
| `CLAUDE.md` | Root entry point — loads every session | Rarely |
| `personas.md` | Quick-reference for all personas | Rarely |
| `orchestrator.md` | Routing and sequencing logic | Rarely |
| `pm-commands.md` | Full PM command set | Occasionally |
| `designer-commands.md` | Full Designer command set | Occasionally |
| `fe-commands.md` | Full FE command set | Occasionally |
| `be-commands.md` | Full BE command set | Occasionally |
| `qa-commands.md` | Full QA command set | Occasionally |
| `pipeline-logic.md` | Full /ship pipeline mechanics | Rarely |
| `ship-command.md` | /ship quick reference + gate definitions | Rarely |
| `quality-gates.md` | All 8 gates with exact pass/fail criteria | Rarely |
| `project-context.md` | Your stack, conventions, non-negotiables | Per project / per sprint |
| `decision-log.md` | Why things were built the way they were | Every significant decision |
| `security-rules.md` | OWASP-based rules enforced on all code | When rules change |
| `pattern-library.md` | Approved code patterns for your codebase | Every new pattern |

Two additional reference files are included for first-time setup:

- `test-run-walkthrough.md` — a complete annotated example of `/ship` from intake to ship summary, including a QA blocker and fix loop. Use it to calibrate what good output looks like.
- `tuning-guide.md` — step-by-step instructions for calibrating Forge to your specific project after the first run.

---

## How context files load

Forge uses Claude Code's native `CLAUDE.md` memory system:

- `CLAUDE.md` at the project root loads every session
- All files in `.claude/rules/` load automatically
- `security-rules.md` and `pattern-library.md` are path-scoped to `src/**`, `app/**`, `api/**` — they only load when Claude is actively writing code in those directories, keeping context lean for planning and design work

Run `/memory` inside Claude Code to see exactly which files are loaded in any session.

---

## The decision log

One of Forge's most important features is the decision log. Every time a deliberate technical or product decision is made — why you chose Zustand over Redux, why you use soft deletes, why a particular query bypasses the ORM — it gets logged in `decision-log.md`.

This prevents Forge from "cleaning up" intentional choices in future sessions. It also builds a living record of your codebase's reasoning that new team members (human or AI) can read.

Log a decision any time with `/log [decision]`.

---

## The pattern library

Every time Forge's FE or BE engineer generates a new code pattern, it flags it for addition to `pattern-library.md`. Over time this file becomes a precise description of how your codebase works — your auth pattern, your error handling, your component structure, your test shape.

A well-populated pattern library is what makes Forge feel like it's been on your project for months rather than starting fresh each session.
