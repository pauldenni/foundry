# Forge — project context

> This file is read by every persona before any task begins.
> Keep it accurate, concise, and current. It is the single source of truth for what this project is and how it works.

---

## Project identity

**Name:** [Project name]
**Type:** [Web app / API / Mobile app / CLI tool / Library / Other]
**Status:** [Early development / Active development / Maintenance / Production]
**Owner:** [Team or individual name]
**Last updated:** [YYYY-MM-DD]

---

## What this product does

[2–4 sentences. What problem does it solve? Who uses it? What's the core value?]

---

## Users

| User type | Description | Key needs |
|---|---|---|
| [e.g. Admin] | [Who they are] | [What they need from the product] |
| [e.g. End user] | | |

---

## Tech stack

### Frontend
- **Framework:** [e.g. Next.js 14, React 18, Vue 3]
- **Styling:** [e.g. Tailwind CSS, CSS Modules, Styled Components]
- **State management:** [e.g. Zustand, Redux, React Context]
- **Key libraries:** [e.g. React Query, Zod, date-fns]

### Backend
- **Runtime:** [e.g. Node.js 20, Python 3.12, Go 1.22]
- **Framework:** [e.g. Express, FastAPI, Gin]
- **Database:** [e.g. PostgreSQL 15, MongoDB, SQLite]
- **ORM / query layer:** [e.g. Prisma, SQLAlchemy, GORM]
- **Auth:** [e.g. JWT + refresh tokens, NextAuth, Clerk, Auth0]
- **Cache:** [e.g. Redis, in-memory, none]

### Infrastructure
- **Hosting:** [e.g. Vercel, AWS, Railway, Fly.io]
- **CI/CD:** [e.g. GitHub Actions, CircleCI]
- **Monitoring:** [e.g. Sentry, Datadog, none]
- **Environment variables managed via:** [e.g. .env files, Doppler, AWS Secrets Manager]

---

## Repository structure

```
[project-root]/
├── [src or app]/           # [brief description]
│   ├── [components]/       # [brief description]
│   ├── [pages or routes]/  # [brief description]
│   ├── [lib or utils]/     # [brief description]
│   └── [api]/              # [brief description]
├── [tests]/                # [brief description]
├── [public or static]/     # [brief description]
└── [config files]          # [brief description]
```

---

## Coding conventions

### General
- **Language:** [e.g. TypeScript strict mode, Python with type hints]
- **Linter:** [e.g. ESLint with airbnb config, Ruff]
- **Formatter:** [e.g. Prettier, Black]
- **Naming:** [e.g. camelCase for variables/functions, PascalCase for components/classes, kebab-case for files]

### File naming
- Components: `[e.g. PascalCase.tsx]`
- Utilities: `[e.g. camelCase.ts]`
- Tests: `[e.g. *.test.ts, *.spec.ts]`
- API routes: `[e.g. kebab-case]`

### Code style rules
- [e.g. No default exports except for pages/routes]
- [e.g. All async functions must have explicit error handling]
- [e.g. Prefer named exports]
- [e.g. No magic numbers — extract to named constants]
- [e.g. No commented-out code in commits]
- [Add your own project-specific rules here]

---

## Testing approach

- **Unit tests:** [e.g. Vitest, Jest, Pytest]
- **Integration tests:** [e.g. Supertest, httpx]
- **E2E tests:** [e.g. Playwright, Cypress, none]
- **Coverage target:** [e.g. 80% on new code]
- **Test file location:** [e.g. co-located alongside source, or /tests directory]
- **Run tests with:** `[e.g. npm test, pytest, make test]`

---

## Environment

- **Local dev:** `[e.g. npm run dev]` → runs on `[e.g. localhost:3000]`
- **Build:** `[e.g. npm run build]`
- **Required env vars:** [List names only, never values — e.g. DATABASE_URL, JWT_SECRET, STRIPE_KEY]
- **Database migrations:** `[e.g. npx prisma migrate dev]`

---

## Non-negotiables

These rules cannot be overridden by any persona or command. They reflect deliberate product decisions.

- [e.g. All API endpoints must be authenticated — no unauthenticated data access]
- [e.g. No third-party analytics without explicit user consent]
- [e.g. Passwords must never be stored — use [auth provider]]
- [e.g. All user-facing text must support i18n via the existing i18n system]
- [e.g. Do not introduce new dependencies without flagging for review]
- [Add your own here]

---

## Out of scope

These things are explicitly NOT part of this project and should not be built:

- [e.g. Mobile native apps — web only]
- [e.g. Real-time features — no websockets]
- [e.g. Multi-tenancy — single org only]
- [Add your own here]

---

## Current focus / active sprint

[Optional: 2–3 sentences on what the team is working on right now. Helps the AI avoid suggesting work that conflicts with active development.]

---

## Contacts / ownership

| Area | Owner |
|---|---|
| [e.g. Frontend] | [Name or handle] |
| [e.g. Backend / API] | |
| [e.g. Design system] | |
| [e.g. DevOps / infra] | |
