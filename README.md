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

### 1. Clone the repo

```bash
git clone https://github.com/[your-username]/foundry.git
cd foundry
```

### 2. Choose your tool

Start Claude Code from the Foundry root:

```bash
claude
```

Foundry will present both tools and ask which to activate. Or navigate directly into a tool's directory to start it without the prompt:

```bash
cd forge && claude    # start Forge directly
cd anvil && claude    # start Anvil directly
```

### 3. Set up Forge for your project

Forge requires one file filled in before your first session: `forge/.claude/rules/project-context.md`. Every persona reads this file first. Fill in your actual stack, conventions, and constraints.

Anvil requires no project-specific setup — start a session and go.

---

## Repository structure

```
foundry/
├── README.md                          ← you are here
├── CLAUDE.md                          ← Foundry entry point (loads on claude from root)
├── CONTRIBUTING.md
├── LICENSE
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
