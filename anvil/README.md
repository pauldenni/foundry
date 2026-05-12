# Anvil

**A personal challenge network for Claude. Ideas and decisions go in, blind spots and vulnerabilities come out.**

Anvil is a structured framework inspired by organizational psychologist Adam Grant's concept of the challenge network — surrounding yourself with trusted critics rather than yes-men. It gives you a curated board of six AI advisors, each with a distinct critical lens, that you can activate to rigorously stress-test your thinking before you commit to it.

Anvil lives inside [Foundry](../README.md) alongside Forge. Use it standalone, before a Forge build, after one, or anywhere in between.

---

## The Six Advisors

Each advisor is a "disagreeable giver" — critical by design, not by character. Their job is to improve the quality of your thinking, not to make you feel good about it.

| Advisor | Role | What They Do |
|---|---|---|
| 🎯 **The Strategist** | Senior Strategy Advisor | Interrogates alignment between tactics and long-term goals. Asks: *"What does winning actually look like in 3 years?"* |
| ⚡ **The Devil's Advocate** | Contrarian Counsel | Argues the strongest possible case against your position. Forces you to defend every assumption. |
| 📊 **The Evidence Broker** | Research & Data Lead | Demands empirical grounding. Challenges anecdotal reasoning. Asks: *"What does the actual data say?"* |
| ⚙️ **The Operator** | Execution Specialist | Probes the gap between theory and practice. Asks what breaks when your plan hits the real world. |
| 🤝 **The Humanist** | People & Culture Lens | Surfaces blind spots around stakeholders, culture, and unintended consequences on the humans involved. |
| 🔬 **First Principles** | Foundational Thinker | Strips everything back to bedrock. Challenges inherited wisdom. Asks: *"Why do we believe this is true at all?"* |

**Choosing advisors:** Pick 2–3 with non-overlapping lenses. A strong default is The Strategist + The Operator + The Evidence Broker — long-term alignment, execution reality, and empirical rigor. Add The Devil's Advocate when you know you're emotionally attached to a decision.

---

## Commands

| Command | What It Does |
|---|---|
| `/challenge` | Full critique from all active advisors |
| `/poke-holes` | Find and rank the weakest points in your plan by severity |
| `/steelman` | Build the strongest possible version of your idea first, then critique |
| `/pre-mortem` | It's 12 months from now and this failed. What happened? |
| `/assumption-map` | Surface and rank every hidden assumption by how load-bearing and uncertain it is |
| `/blind-spot` | What are you almost certainly not seeing? |
| `/forge-review` | Challenge the technical and product decisions made in a Forge session |
| `/iterate` | Resubmit a revised position for a second round with the same advisors |
| `/debrief` | Summarize the session: key objections, exposed assumptions, recommended next steps |

---

## Templates

### Decision Audit
Use when facing a choice between options and needing your reasoning pressure-tested.

```
/challenge DECISION AUDIT

Context: [Describe the decision and its background]

Options on the table:
1. [Option A]
2. [Option B]
3. [Option C — if applicable]

My current lean: [Which option and why]

Constraints: [Time, budget, resources, non-negotiables]

What I've already ruled out: [And why]

Advisors active: [Names]
Intensity: [moderate / rigorous / brutal]

Audit this decision. Identify: (1) the weakest assumptions in my reasoning,
(2) risks I'm likely underweighting, (3) the strongest case for the option I'm NOT choosing.
```

### Idea Stress-Test
Use when you believe in an idea and want to find where it breaks.

```
/challenge IDEA STRESS-TEST

Idea: [Describe in 2–4 sentences]

Why I think this works:
- [Reason 1]
- [Reason 2]
- [Reason 3]

Who benefits and how: [Be specific]

What success looks like in 6 months: [Concrete metrics or outcomes]

What could kill this: [Your own best guess at failure modes]

Advisors active: [Names]
Intensity: [moderate / rigorous / brutal]

Stress-test this idea: (1) steelman it first, (2) find the 3 most likely failure modes,
(3) rank assumptions by how dangerous they are if wrong.
```

### Pre-Mortem
Use before committing to a major decision or launching a plan.

```
/pre-mortem PRE-MORTEM ANALYSIS

Decision/plan: [What you're about to do]

Timeline: [Kickoff and key milestones]

Resources committed: [People, budget, time, attention]

It is now [date 12 months from now]. This effort has failed badly.

Advisors active: [Names]
Intensity: [moderate / rigorous / brutal]

Run a pre-mortem. Each advisor answers independently: (1) What most likely caused this
to fail? (2) What early warning sign did we ignore? (3) What's the one thing we should
do differently before we start?
```

### Assumption Map
Use when you want to expose the hidden beliefs holding up your plan.

```
/assumption-map ASSUMPTION MAPPING

Decision/plan: [Describe it]

What I believe to be true about:
— The market/environment: [Your beliefs]
— Our capabilities: [Your beliefs]
— The people involved: [Your beliefs]
— The timeline: [Your beliefs]
— The competition/alternatives: [Your beliefs]

Advisors active: [Names]
Intensity: [moderate / rigorous / brutal]

Map my assumptions. For each: (1) Is it load-bearing? (2) How confident should I
actually be? (3) How would I test or falsify it before committing further?
```

### Forge Review
Use after a Forge session to challenge the technical and product decisions made during the build.

```
/forge-review FORGE SESSION REVIEW

What was built: [Brief description of the feature or system]

Key decisions made during the session:
- Architecture: [e.g. chose REST over GraphQL, used Zustand for state]
- Data model: [e.g. soft deletes, denormalized for read performance]
- Scope cuts: [e.g. deferred auth to next sprint, skipped mobile breakpoints]
- Trade-offs accepted: [e.g. consistency over availability, speed over test coverage]

What QA flagged (if anything): [Any blockers or warnings from the Forge QA pass]

Advisors active: [Names — The Operator and First Principles work well here]
Intensity: [moderate / rigorous / brutal]

Review these decisions. For each: (1) Is this the right call given the constraints?
(2) What's the most likely future cost of this decision? (3) What would you do differently?
```

---

## A Complete Example Session

**The situation:** A product lead is considering shifting go-to-market focus from SMB to enterprise. She believes it's the right call but wants to run it through Anvil before presenting to leadership.

**Step 1 — Choose advisors**

She picks three with complementary lenses:
- 🎯 The Strategist — long-term alignment
- ⚙️ The Operator — execution reality
- 📊 The Evidence Broker — data grounding

**Step 2 — Fill in the Idea Stress-Test template**

```
/challenge IDEA STRESS-TEST

Idea: Shift primary go-to-market focus from SMB to enterprise over 18 months.
SMB churn is high and revenue per account is low. Enterprise LTV is 10–15x higher
with minimal churn.

Why I think this works:
- Product already has enterprise features (SSO, audit logs, RBAC)
- Our two largest accounts (both enterprise) have never churned in 3 years
- SMB market is increasingly price-sensitive; we can't compete with lower-cost tools

Who benefits and how: Company gets stable, predictable revenue. Enterprise customers
get a vendor investing in their segment. Sales gets larger commissions on fewer deals.

What success looks like in 6 months: 3 new enterprise logos, enterprise ARR at 30%
of total (up from 12%), sales cycle playbook documented.

What could kill this: Sales team lacks enterprise experience. Missing compliance
certifications. SMB deteriorates faster than enterprise ramps.

Advisors active: The Strategist, The Operator, The Evidence Broker
Intensity: rigorous
```

**Step 3 — The network responds (abbreviated)**

> **🎯 The Strategist — Steelman:** This is the right instinct at the right time. SMB-first companies that fail to move upmarket typically plateau at a revenue ceiling that makes the business uninvestable. Zero churn on your existing enterprise accounts is a strong signal the product already has what enterprise buyers need.
>
> **🎯 The Strategist — Critique:** The plan treats enterprise and SMB as separable strategies. They often aren't. Enterprise sales cycles average 6–9 months. If SMB softens during the transition, you may not have runway to wait for enterprise deals to close. What's your bridge? This is a cashflow sequencing question, not a product question.
>
> **⚙️ The Operator — Critique:** Sales motion is the entire bet, and you've glossed over it. SMB and enterprise require fundamentally different skills. Have you assessed your team honestly? Retraining is slow. Hiring is expensive. Which is the plan, and what's the realistic timeline?
>
> **📊 The Evidence Broker — Critique:** Your "10–15x LTV" figure is load-bearing and you stated it without a source. Is that based on your two existing enterprise accounts? If so, that's an N of 2. You're proposing a strategic shift on anecdote. Get real LTV projections — including implementation cost, support cost, and realistic expansion rate — before you build a business case on this number.

**Step 4 — Iterate**

She validates the LTV figure with real data, models the cashflow bridge, and runs `/iterate` with a revised position. The second round is where the real sharpening happens.

**Step 5 — Debrief**

```
/debrief
```

The summary becomes the foundation of her proposal — every objection addressed proactively, every assumption tested. The pitch is measurably stronger.

---

## Setup

### Option A — Claude.ai (web or desktop)

1. Open [claude.ai](https://claude.ai) or the desktop app
2. Create a **Project** named `Anvil` (or `Foundry`)
3. Open **Project Instructions** and paste the contents of `CLAUDE.md`
4. Start a new conversation in the project, paste a template, and go

### Option B — Claude Code (CLI), standalone

```bash
cd foundry/anvil
claude
```

Claude Code automatically reads `CLAUDE.md` and all files in `.claude/rules/` from the current directory. No configuration needed.

### Option C — Claude Code (CLI), via Foundry root

```bash
cd foundry
claude
```

Foundry presents both tools. Select Anvil to activate it.

---

## Tips

**Be specific about your context.** The more the advisors know about your actual constraints, what you've ruled out, and what success looks like — the more targeted and useful their feedback will be.

**Don't pre-hedge.** Present the idea as if you believe in it fully. Let the network find the holes. That's its job.

**Run the pre-mortem before irreversible decisions.** Imagining failure is uncomfortable, which is exactly why it works — it activates different reasoning than forward-looking planning.

**Iterate at least once.** One-and-done sessions are useful. Two-round sessions are transformative. Present → get challenged → revise → re-challenge.

**Use `/debrief` every time.** The output becomes a decision memo, a proposal foundation, or a revision brief. Don't skip it.

**Adjust intensity to the stakes.** `moderate` for exploratory thinking. `rigorous` for decisions that matter. `brutal` for irreversible commitments.

---

## The Philosophy

Adam Grant's research on challenge networks is grounded in one insight: we are surrounded by people who want us to feel good, but what we need are people who want us to be right.

Support networks help us persist and recover. Challenge networks improve the quality of our decisions. The discomfort of rigorous feedback is not a bug — it's the mechanism. Feel it in a conversation with Anvil, not in a failed launch six months later.

---

*Anvil is part of Foundry — a suite of Claude-powered tools for building and stress-testing ideas. See the [Foundry README](../README.md) for the full picture.*
