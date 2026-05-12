# Contributing to Foundry

Foundry is a suite of opinionated AI tools built for Claude Code. Contributions that make either tool more reliable, more precise, or more useful across a wider range of projects and use cases are very welcome.

---

## Structure

Contributions can target three levels:

- **Foundry-level** — the root `CLAUDE.md`, `README.md`, and the container logic that routes between tools
- **Forge** — the development pipeline, personas, quality gates, and rules files
- **Anvil** — the advisor personas, commands, templates, and session logic

Each tool has its own internal contribution norms. Read the relevant section below before opening a PR.

---

## Contributing to Forge

**High value:**
- Improvements to gate definitions that catch real issues more reliably
- Better persona hard limits based on failure patterns you've observed
- Stack-specific pattern library variants (e.g. Python/FastAPI, Ruby on Rails, T3)
- Edge case catalog additions for specific domains (e-commerce, SaaS, real-time, etc.)
- Security rule additions for specific threat models or compliance requirements
- Fixes to anything ambiguous, contradictory, or that causes unexpected AI behavior

**Also welcome:**
- Clarifications to confusing wording in any rules file
- Better worked examples in the persona command files
- README improvements

**Not a good fit:**
- Project-specific patterns that only apply to one codebase
- Changes that weaken quality gates or make it easier to skip QA
- Additions that increase file length without meaningful behavior change

---

## Contributing to Anvil

**High value:**
- New advisor personas with a genuinely distinct critical lens not covered by existing advisors
- New commands that address a real challenge mode not currently supported
- New templates for common high-stakes decision types
- Improvements to advisor behavior rules that produce sharper, more useful critique
- The Forge integration mode — better prompts, edge cases, worked examples

**Also welcome:**
- Clarifications to advisor descriptions or behavior rules
- Better worked examples in the session guide
- README improvements

**Not a good fit:**
- Advisors that duplicate an existing lens under a different name
- Changes that soften advisor feedback or make critique more diplomatic by default
- Templates so specific they only apply to one industry or role

---

## How to contribute

1. Fork the repo
2. Make your changes — keep edits focused, one concern per PR
3. Test your changes by running the relevant tool with Claude Code and verifying the output behaves as expected
4. Open a pull request with a clear description of what changed and why

For significant changes to core behavior (persona definitions, pipeline logic, gate criteria, advisor character), open an issue first. These files are load-bearing — changes have downstream effects that aren't always obvious.

---

## Principles that apply to both tools

**Shorter is better.** Every line competes for context window budget. If you can say it in fewer words without losing precision, do that.

**Specific beats general.** "Validate all input with Zod before use" is better than "validate input." The more specific the instruction, the more reliably the AI follows it.

**Gates and limits should be hard.** In Forge, resist softening blockers into warnings. In Anvil, resist making advisors more agreeable. The value of both tools comes from their unwillingness to let things slide.

**Examples are worth more than explanations.** A worked example of a QA blocker, or a full advisor critique response, teaches faster than a descriptive paragraph about what one looks like.

---

## Questions

Open an issue. Happy to discuss before you spend time writing a PR.
