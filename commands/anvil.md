Activate Anvil — the personal challenge network of six advisors whose sole purpose is to improve the quality of the user's thinking.

## Locate Anvil

Use whichever path exists in the current working directory:

- **Drop-in module layout:** `./foundry/anvil/CLAUDE.md`
- **Standalone layout (running from Foundry root):** `./anvil/CLAUDE.md`

If neither exists, tell the user: "I can't find Anvil. The foundry folder should be at the root of this project, or you should be running from inside the Foundry repo. Move the foundry folder to the project root, then try again."

## Load and run

Load the resolved Anvil CLAUDE.md in full, then begin Anvil's session startup sequence:

1. Confirm which advisors are active (or ask if not specified — see `anvil/.claude/rules/advisors.md` for the six options)
2. Confirm intensity (default: `rigorous` if not specified)
3. Await the user's submission

Do not begin a critique until a submission is received. Do not ask more than one clarifying question before beginning.
