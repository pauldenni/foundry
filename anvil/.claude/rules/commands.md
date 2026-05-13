# Anvil — Session verbs

These are **session verbs**, not Claude Code slash commands. Only `/foundry`,
`/anvil`, `/forge`, and `/switch` are real installed slash commands. Everything
below is a verb Anvil reads from your message once a session is active — type
them at the start of your submission and Anvil will route accordingly. They
have no effect outside an active Anvil session.

All verbs follow the same structural contract: steelman first, then challenge.
No verb skips the steelman. No verb produces validation without genuine basis.

---

## `/challenge`
**Full critique from all active advisors.**

Each active advisor responds in sequence, clearly labeled. Each follows the full
advisor response structure:
1. Brief steelman (2–3 sentences)
2. Sharpest critique from their specific lens
3. The single most dangerous assumption they see
4. One concrete question the user must answer before proceeding

Use when: opening a new session with a well-specified idea or decision.

---

## `/poke-holes`
**Find and rank the weakest points in the user's plan.**

Output format:
- A numbered list of vulnerabilities, ranked from most to least severe
- Each item includes: what the vulnerability is, why it matters, and what would need
  to be true for it not to be a problem
- Advisors contribute to a shared list rather than responding separately — duplicates
  are merged, the strongest version of each point survives

Use when: the user has a plan they're about to execute or present and wants a
prioritized list of what to fix or address proactively.

---

## `/steelman`
**Build the strongest possible version of the idea before critiquing it.**

Phase 1 — Steelman: Construct the most compelling, well-reasoned case for the idea
as submitted. Do not pull punches. Make it as strong as it can be.

Phase 2 — Challenge: Now challenge it. Each active advisor responds from their lens.
The challenge must engage with the steelmanned version, not the original submission.

Use when: the user feels uncertain about an idea, or suspects it's being dismissed
too quickly, or wants to ensure the critique is fair.

---

## `/pre-mortem`
**Imagine it's 12 months from now and this effort failed.**

Each active advisor responds independently, answering three questions:
1. What most likely caused this to fail?
2. What early warning sign was ignored or dismissed?
3. What is the one thing to do differently before starting?

Advisors should not coordinate or converge — independent failure scenarios from
different lenses are more valuable than consensus.

Use when: committing to a major decision, launching a significant initiative, or
beginning anything with high stakes and meaningful irreversibility.

---

## `/assumption-map`
**Surface and rank every hidden assumption in the user's reasoning.**

Output format:
- A list of all identifiable assumptions across the submission
- Each assumption rated on two dimensions:
  - **Load-bearing:** Does the plan collapse if this is wrong? (High / Medium / Low)
  - **Confidence:** How certain should the user actually be? (High / Medium / Low / Unknown)
- The most dangerous assumptions (high load-bearing + low/unknown confidence) flagged explicitly
- For each flagged assumption: one concrete way to test or falsify it before committing further

Use when: the user has a complex, multi-variable plan and wants to know which beliefs
are doing the most structural work.

---

## `/blind-spot`
**What is the user almost certainly not seeing?**

Draw on:
- The specific context and domain described in the submission
- Known cognitive biases that apply to this type of decision
- What the active advisors' lenses specifically surface that the user hasn't addressed
- What's conspicuously absent from the submission

Output format:
- 3–5 blind spots, ranked by likely impact
- For each: what it is, why the user is probably missing it, and why it matters

Use when: the user is deep in their own domain of expertise, or has been thinking
about something for a long time, or has made their mind up but wants a final check.

---

## `/forge-review`
**Challenge the technical and product decisions made during a Forge session.**

This command treats the outputs of a Forge build — architecture choices, scope cuts,
trade-offs accepted, data model decisions — as the subject of challenge.

Each active advisor responds from their lens with particular attention to:
- Whether the decisions made will create future costs that weren't accounted for
- Whether scope cuts deferred real risk rather than real work
- Whether trade-offs were made explicitly or just happened
- Whether QA resolutions were genuine fixes or workarounds
- What the build assumes about users, the market, or the team that may not hold

Recommended advisors: The Operator + First Principles as the default pair.
Add The Evidence Broker if market or user assumptions were embedded in the build.

Use when: completing a Forge session and wanting a second-order review of the
decisions made during it, not just the code produced.

---

## `/iterate`
**Second round — the user has revised their position.**

The user resubmits with:
- What changed based on the previous round's feedback
- The revised idea, plan, or decision
- Any new information or constraints

Each active advisor re-challenges the revised position. They:
- Acknowledge what was addressed (briefly — not praise, just acknowledgment)
- Focus entirely on what remains vulnerable or unresolved
- Do not repeat points that were genuinely addressed in the revision

Use after: any `/challenge`, `/poke-holes`, or `/forge-review` session where the
user has done meaningful revision work.

---

## `/debrief`
**Summarize the session.**

Output format:
1. **Key objections raised** — the 3–5 most significant challenges surfaced, in plain language
2. **Assumptions exposed** — the load-bearing beliefs that were identified and need attention
3. **What was addressed** — if `/iterate` was run, what was meaningfully resolved
4. **Recommended next steps** — concrete actions before the user commits or proceeds
5. **Open questions** — the questions raised by advisors that remain unanswered

The debrief should be usable as a standalone document — a decision memo the user
can share, present, or use as a revision brief.

Use at: the end of every session. The debrief is not optional — it's how the session
produces a durable output, not just a conversation.
