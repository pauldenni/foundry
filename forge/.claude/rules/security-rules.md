---
paths:
  - "src/**"
  - "app/**"
  - "pages/**"
  - "api/**"
---

# Forge — security rules

> Non-negotiable. No persona may generate code that violates these rules.
> Violations block `/ship` without exception.

---

## Hard rules — automatic ship blockers

### 1. Auth required on all endpoints

Every API endpoint must verify identity before executing any logic.

```typescript
// CORRECT
export async function GET(req: NextRequest) {
  const user = await requireAuth(req)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  // ...
}
```

Exception: public endpoints must be annotated `// PUBLIC ENDPOINT — intentionally unauthenticated` with justification.

---

### 2. No secrets in code

- All secrets live in environment variables
- No hardcoded fallback secrets: `process.env.KEY ?? 'fallback'` is a violation
- `.env` must be in `.gitignore` — checked at every `/ship`
- QA scans for: hex strings >20 chars, base64 strings, `sk_`, `pk_`, `Bearer ` literals

---

### 3. All user input validated before use

```typescript
// CORRECT — validate at the API boundary
const Schema = z.object({ id: z.string().uuid(), name: z.string().min(1).max(100) })
const parsed = Schema.safeParse(body)
if (!parsed.success) return error(400)

// WRONG — never do this
const { id } = req.body
await db.query(`SELECT * FROM users WHERE id = '${id}'`)
```

---

### 4. Authorization on every data access

Authentication ≠ authorization. Every read/write on user-owned data must verify ownership.

```typescript
// CORRECT
const item = await db.item.findUnique({ where: { id } })
if (!item || item.userId !== user.id) {
  return NextResponse.json({ error: 'Not found' }, { status: 404 }) // 404, not 403
}
```

---

### 5. No sensitive data in logs or responses

- No `console.log(user)` if user object contains password hash or tokens
- Error responses to client must be generic: `"Something went wrong"`
- Real errors go to the logging service only — never in the response body

---

### 6. CORS explicitly configured

No wildcard `Access-Control-Allow-Origin: *` on authenticated endpoints. Allowed origins from env vars only.

---

### 7. Rate limiting on auth endpoints

Login, register, password reset, token refresh — all rate-limited. Exceeding limit → `429`. Do not reveal whether it's due to failed auth attempts.

---

### 8. No new unreviewed dependencies

Check: actively maintained (last commit <6 months), no high/critical CVEs via `npm audit`, prefer well-known packages for security-sensitive operations.

---

### 9. Sensitive operations idempotency-safe

Payments and sends use idempotency keys. Validate server-side that the operation hasn't already run.

---

### 10. Security headers on all HTML responses

```
Content-Security-Policy: default-src 'self'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
```

---

## QA security scan checklist

- [ ] No hardcoded secrets or credentials in any file
- [ ] All new API routes have auth checks
- [ ] All user input validated with schema before use
- [ ] All data access checks ownership/permissions
- [ ] No raw SQL string concatenation
- [ ] No wildcard CORS on authenticated routes
- [ ] No sensitive data in `console.log` or error responses
- [ ] No new unreviewed dependencies
- [ ] `.env` is in `.gitignore`
- [ ] `npm audit` passes with no high/critical issues

---

## Project-specific rules

<!-- Add any project-specific security requirements here -->
