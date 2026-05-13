<p align="center">
  <img src=".github/foundry.png" alt="Foundry" />
</p>

# Foundry

**A suite of AI-powered tools for building and stress-testing ideas, products, and decisions.**

Foundry is the container for two complementary tools built for Claude Code:

| Tool | What it does |
|---|---|
| **Forge** | An AI development team. Raw intent goes in, production-ready code comes out. |
| **Anvil** | A challenge network. Ideas and decisions go in, blind spots and vulnerabilities come out. |

A real foundry houses both the forge and the anvil — one shapes the material, the other tests it under impact. That relationship is intentional. Forge and Anvil are designed to be used together, independently, or in any order the work demands.

---

## How they fit together

There's no single right sequence. Use the tools where they add value:

```
Idea → [Anvil] → stress-test before building → [Forge] → build it → [Anvil] → pressure-test the outcome → iterate
```

Or just:

```
Idea → [Forge] → build it
Decision → [Anvil] → stress-test it
```

Anvil works standalone for any decision or idea — product, career, strategy, technical architecture — whether or not it originated in a Forge session. Forge works standalone as a full AI development team for any codebase. They reinforce each other when used in sequence, but neither requires the other.

---

## Tools

### Forge
An AI development team with five specialized personas — PM, Designer, Frontend Engineer, Backend Engineer, and QA — that work in sequence through a gated build pipeline. Nothing ships without passing QA.

→ See [`forge/README.md`](forge/README.md) for full documentation.

### Anvil
A personal challenge network of six AI advisors — The Strategist, The Devil's Advocate, The Evidence Broker, The Operator, The Humanist, and First Principles — that stress-test your ideas and decisions through structured, candid critique.

→ See [`anvil/README.md`](anvil/README.md) for full documentation.

---

## Setup

Foundry is designed to be **dropped into any project** (a code repo, an Obsidian vault, anywhere you use Claude Code) and activated with slash commands. The foundry folder is the toolkit — your project is where the work happens.

### Drop-in install (recommended)

1. **Drop the `foundry/` folder at the root of your project.**

   Your project should now look like:
   ```
   your-project/
   ├── .claude/          (existing or new)
   ├── foundry/          (just dropped in)
   └── ...
   ```

2. **From your project root, run the install script once:**

   ```bash
   ./foundry/install.sh
   ```

   This symlinks four slash commands into `.claude/commands/`. Existing commands in that folder are left alone. Re-running is safe — it reports what's already installed.

3. **Launch Claude Code from your project root and use:**

   ```
   /foundry   show the welcome and choose a tool
   /anvil     jump straight to Anvil
   /forge     jump straight to Forge
   /switch    swap tools mid-session
   ```

Forge writes code into your project's actual structure — the foundry folder only holds the personas, rules, and pipeline logic. Anvil leaves no files behind; it's pure conversation.

### Standalone install

If you just want to try Foundry on its own without dropping it into another project, clone the repo and start Claude Code from inside it:

```bash
git clone https://github.com/[your-username]/foundry.git
cd foundry
claude
```

The root `CLAUDE.md` auto-loads and presents the welcome screen. You can also cd directly into a tool:

```bash
cd foundry/forge && claude    # Forge directly
cd foundry/anvil && claude    # Anvil directly
```

### Forge project setup

Before your first Forge session, fill in `foundry/forge/.claude/rules/project-context.md` (or `forge/.claude/rules/project-context.md` in standalone mode). Every persona reads it first.

Anvil requires no project-specific setup — start a session and go.

---

## Repository structure

```
foundry/
├── README.md                          ← you are here
├── CLAUDE.md                          ← standalone entry point (auto-loads when cwd is foundry/)
├── CONTRIBUTING.md
├── LICENSE
├── install.sh                         ← run from a parent project to register slash commands
├── commands/                          ← slash command bodies (symlinked into parent's .claude/commands/)
│   ├── foundry.md                     ← /foundry  — welcome + route
│   ├── anvil.md                       ← /anvil    — jump to Anvil
│   ├── forge.md                       ← /forge    — jump to Forge
│   └── switch.md                      ← /switch   — swap tools mid-session
│
├── forge/
│   ├── README.md
│   ├── CLAUDE.md
│   └── .claude/
│       └── rules/
│           ├── personas.md
│           ├── orchestrator.md
│           ├── pm-commands.md
│           ├── designer-commands.md
│           ├── fe-commands.md
│           ├── be-commands.md
│           ├── qa-commands.md
│           ├── pipeline-logic.md
│           ├── ship-command.md
│           ├── quality-gates.md
│           ├── project-context.md    ← fill this in
│           ├── decision-log.md
│           ├── security-rules.md
│           ├── pattern-library.md
│           ├── test-run-walkthrough.md
│           └── tuning-guide.md
│
└── anvil/
    ├── README.md
    ├── CLAUDE.md
    └── .claude/
        └── rules/
            ├── advisors.md
            ├── commands.md
            ├── templates.md
            └── session-guide.md
```

---

## Philosophy

Foundry is built around a simple idea: **the tools that shape your work and the tools that test it should live together.**

Forge makes things. Anvil hardens them. A foundry without an anvil produces untested output. An anvil without a forge has nothing to work with. The suite is most powerful when you treat them as two phases of the same process — build, test, iterate — rather than two separate tools.

Both tools are opinionated by design. Forge won't ship broken code. Anvil won't soften uncomfortable feedback. That's the point.

---

*Foundry is part of a growing suite of Claude-powered professional frameworks. Each tool is designed to be used standalone or as part of the suite.*
