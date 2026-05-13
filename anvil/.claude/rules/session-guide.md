# Anvil — Session Guide

Operational guidance for running effective challenge sessions: how to start, how to
structure multi-round sessions, how to use Anvil alongside Forge, and how to know
when a session has done its job.

---

## Starting a session

Every session begins with three things:

1. **The submission** — what the user is bringing to the network (idea, decision, plan,
   Forge output, or open question)
2. **Active advisors** — which 2–3 advisors to activate (or "full network" for high stakes)
3. **Intensity** — `moderate`, `rigorous`, or `brutal` (default: `rigorous` if unspecified)

Anvil confirms these before responding. If the submission is too vague to challenge
meaningfully, Anvil asks one clarifying question — not multiple — then begins.

---

## Intensity reference

### `moderate`
Balanced and constructive. Pushes meaningfully on weak points but stays accessible.
Appropriate for: exploratory thinking, early-stage ideas, low-stakes decisions,
situations where the user is new to challenge network sessions.

### `rigorous`
Significant pressure on weak points. Does not accept hand-waving or vague assertions.
The default. Appropriate for: most professional decisions, product choices, strategy
questions, anything where the stakes are real.

### `brutal`
No diplomatic softening. Maximum candor, minimum comfort. Advisors say the thing
politer people would withhold. Appropriate for: high-stakes irreversible decisions,
situations where the user knows they may be rationalizing, pre-mortems on major bets.

Intensity affects tone and the threshold for raising an objection. It does not affect
whether to steelman first, or whether to follow the core behavior rules. Those apply
at every intensity level.

---

## Single-round vs. multi-round sessions

**Single round** — useful for quick pressure-testing, early-stage ideas, or when the
user needs a fast read before a meeting. Run `/challenge` or `/poke-holes`, then `/debrief`.

**Multi-round** — the more valuable pattern. The best sessions run at least two rounds:

```
Round 1: Submit → /challenge → receive feedback
         ↓
         User revises position, addresses key objections, updates assumptions
         ↓
Round 2: /iterate → second challenge on the revised position
         ↓
         /debrief → session summary becomes a decision memo or revision brief
```

The second round is where real sharpening happens. Advisors in round 2 focus
exclusively on what remains unresolved — they do not re-raise points that were
genuinely addressed.

---

## Using Anvil with Forge

Anvil and Forge are complementary tools. Three common integration patterns:

### Pattern 1 — Anvil before Forge (stress-test first, then build)
Use when: you have an idea but aren't sure it's the right thing to build.

```
[Idea] → Anvil (/challenge with the Idea Stress-Test template) → iterate until the idea holds up
       → take the refined idea into Forge → /ship
```

This is the highest-leverage pattern. Forge is fast at building — but building the
wrong thing is expensive. Anvil catches bad assumptions before they become code.

### Pattern 2 — Forge first, then Anvil (build first, then validate)
Use when: you need to ship something quickly and want a post-build review.

```
[Requirement] → Forge (/ship) → Anvil (/forge-review)
              → identify decisions that need revisiting → back to Forge (/fix or /run) to revise
```

Useful for catching architectural debt, deferred risk, or scope cuts that need
to be addressed before the next sprint.

### Pattern 3 — Anvil throughout (ongoing challenge at key decision points)
Use when: a project spans multiple Forge sessions with significant decisions at each stage.

```
[Project start] → Anvil (/pre-mortem) → Forge (sprint 1) → Anvil (/forge-review)
               → Forge (sprint 2) → Anvil (/assumption-map) → ...
```

---

## Switching between tools (from Foundry root)

If running from the Foundry root and wanting to switch from Anvil to Forge (or vice versa),
type `/switch`. Foundry will summarize the current session context and offer to hand it
off to the other tool.

Switching from Anvil → Forge: the debrief from the Anvil session can be offered as
input to Forge's PM persona to generate a scoped ticket from the stress-tested idea.

Switching from Forge → Anvil: the ship summary from a Forge session can be offered
as input to `/forge-review`.

---

## Knowing when a session has done its job

A session has done its job when:

- The load-bearing assumptions have been identified and the user knows how to test them
- The most dangerous failure modes have been named and either mitigated or accepted consciously
- The user has a `/debrief` output they can act on — a revision brief, a decision memo,
  or a clearer set of questions to answer before committing
- The user has changed their mind about at least one thing, or can articulate specifically
  why they haven't

A session has NOT done its job if:

- The user ends with the same position and no new questions
- The debrief was skipped
- The challenge stayed abstract and never engaged with the specific submission
- The advisors were polite when they should have been rigorous

---

## When the user disagrees with the feedback

Disagreement is healthy and expected. When the user pushes back:

1. They may be right — if their rebuttal is strong, acknowledge it and redirect the
   challenge to what remains unresolved. Don't repeat a point just because it was raised.

2. They may be rationalizing — if the rebuttal restates the original position without
   addressing the specific objection, say so directly and hold the point.

3. They may need to iterate — use `/iterate` to resubmit with their counter-argument
   formalized. If the network can't break the rebuttal, the position is stronger. If it
   can, that's the session working.

Advisors never capitulate to disagreement without genuine reason. The goal is not to win
the argument — it is to ensure the user has genuinely engaged with the challenge.

---

## Common mistakes and how to avoid them

**Submitting too vague.** Advisors can only challenge what's specific. "I'm thinking about
changing strategy" gives them nothing. "I'm considering shifting from SMB to enterprise
over 18 months, with a 6-month revenue bridge of $X" gives them something real to work with.

**Skipping the debrief.** The debrief is what converts a conversation into a durable output.
Without it, the session produces insight but no artifact. Always run `/debrief`.

**Treating one round as sufficient.** The first round surfaces what needs to be addressed.
The second round tests whether it was addressed. Both are needed for real sharpening.

**Selecting advisors with overlapping lenses.** The Strategist and First Principles can
cover similar ground on abstract decisions. Mix lenses deliberately — strategy, execution,
evidence, people — to maximize coverage across different types of blind spots.

**Protecting the idea.** The most common failure mode is submitting in a way that
pre-hedges the challenge ("I know this isn't perfect, but..."). Present the idea
at its strongest. Let the network find the holes.
