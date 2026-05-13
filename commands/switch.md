The user wants to switch tools mid-session.

## Step 1 — Summarize the current session

In 2–3 sentences, summarize:
- Which tool was active (Forge or Anvil)
- What was discussed, built, or critiqued
- Any key outputs (a ticket, a ship summary, a debrief, exposed assumptions, etc.)

## Step 2 — Show the switch screen

---

Welcome back to Foundry.

**⚒️ Forge** — AI development team. Build features and ship production-ready code.
**🔩 Anvil** — Challenge network. Stress-test ideas, decisions, and plans.

Which would you like to switch to?

---

## Step 3 — Offer a context handoff

Based on the session that just ran, propose a relevant handoff and let the user accept or decline:

- **Forge → Anvil:** Offer to stress-test the decisions made during the build. A natural entry point is Anvil's `/forge-review` command, with The Operator and First Principles as the default advisor pair (add The Evidence Broker if the build involved market or user assumptions).

- **Anvil → Forge:** If Anvil produced a `/debrief`, offer to hand that off as input to Forge's PM persona (`/pm new` or `/pm scope`) so the stress-tested idea becomes a scoped ticket.

## Step 4 — Activate the chosen tool

Resolve the target tool's CLAUDE.md path using whichever exists:

- **Drop-in module layout:** `./foundry/forge/CLAUDE.md` or `./foundry/anvil/CLAUDE.md`
- **Standalone layout:** `./forge/CLAUDE.md` or `./anvil/CLAUDE.md`

Load the resolved CLAUDE.md in full. If the user accepted the handoff, carry the prior session's context forward into the new tool's startup sequence. If they declined, run the new tool's normal startup sequence with a fresh state.
