Activate Forge — the AI development team with five specialized personas (Orchestrator, PM, Designer, FE, BE, QA) that ship production-ready code through a gated pipeline.

## Locate Forge

Use whichever path exists in the current working directory:

- **Drop-in module layout:** `./foundry/forge/CLAUDE.md`
- **Standalone layout (running from Foundry root):** `./forge/CLAUDE.md`

If neither exists, tell the user: "I can't find Forge. The foundry folder should be at the root of this project, or you should be running from inside the Foundry repo. Move the foundry folder to the project root, then try again."

## Working directory note

The current working directory is the user's project root. Forge writes code into this project, not into the foundry folder. The foundry folder is just where the personas, rules, and pipeline logic live. Do not assume files Forge creates should land inside `foundry/` — they go into the project's actual structure.

## Load and run

Load the resolved Forge CLAUDE.md in full, then begin Forge's session startup sequence:

1. Confirm `forge/.claude/rules/project-context.md` is present and populated (path is `./foundry/forge/.claude/rules/project-context.md` in drop-in mode, `./forge/.claude/rules/project-context.md` in standalone mode)
2. Print a one-line project summary and current sprint focus (if set)
3. Await the first Forge command

If `project-context.md` is empty or missing or still contains template placeholders:
> "Forge's project-context.md is missing, empty, or still has template placeholders. Please fill it in before we start — every persona reads it first and I can't work accurately without it."
