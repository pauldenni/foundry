---
paths:
  - "src/**"
  - "app/**"
  - "pages/**"
  - "api/**"
---

# Forge — pattern library

> All code output must follow these patterns.
> If no pattern exists for what you're building, generate the code, flag it as NEW PATTERN, and suggest adding it here.
> Patterns marked [DEPRECATED] must not be used in new code.

---

## API patterns

### Standard route handler
```typescript
// Pattern: API route with auth, validation, error handling
import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'
import { requireAuth } from '@/lib/auth'
import { db } from '@/lib/db'

const RequestSchema = z.object({
  // define shape here
})

export async function POST(req: NextRequest) {
  const user = await requireAuth(req)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json()
  const parsed = RequestSchema.safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 })

  try {
    const result = await db.[table].[operation](parsed.data)
    return NextResponse.json(result)
  } catch (error) {
    console.error('[route-name]', error)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}
```

### Paginated list
```typescript
// Pattern: cursor-based pagination
const PaginationSchema = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().min(1).max(100).default(20),
})

const { cursor, limit } = PaginationSchema.parse(Object.fromEntries(req.nextUrl.searchParams))

const items = await db.[table].findMany({
  take: limit + 1,
  cursor: cursor ? { id: cursor } : undefined,
  orderBy: { createdAt: 'desc' },
})

const hasMore = items.length > limit
return NextResponse.json({ items: items.slice(0, limit), nextCursor: hasMore ? items[limit - 1].id : null })
```

---

## Component patterns

### Data-fetching component
```typescript
// Pattern: server component + suspense + error boundary
import { Suspense } from 'react'
import { ErrorBoundary } from '@/components/ErrorBoundary'
import { Skeleton } from '@/components/ui/Skeleton'

async function [Name]Data({ id }: { id: string }) {
  const data = await fetch[Data](id)
  return <[Name]View data={data} />
}

function [Name]View({ data }: { data: [Type] }) {
  return ( /* render */ )
}

export function [Name]({ id }: { id: string }) {
  return (
    <ErrorBoundary fallback={<[Name]Error />}>
      <Suspense fallback={<Skeleton />}>
        <[Name]Data id={id} />
      </Suspense>
    </ErrorBoundary>
  )
}
```

### Form with validation
```typescript
// Pattern: controlled form, Zod validation, loading state
'use client'
import { useState } from 'react'
import { z } from 'zod'

const Schema = z.object({ /* fields */ })
type FormData = z.infer<typeof Schema>
type FormErrors = Partial<Record<keyof FormData, string>>

export function [FormName]() {
  const [data, setData] = useState<Partial<FormData>>({})
  const [errors, setErrors] = useState<FormErrors>({})
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    const parsed = Schema.safeParse(data)
    if (!parsed.success) {
      const fieldErrors: FormErrors = {}
      for (const issue of parsed.error.issues) {
        fieldErrors[issue.path[0] as keyof FormData] = issue.message
      }
      setErrors(fieldErrors)
      return
    }
    setLoading(true)
    try { await submit[FormName](parsed.data) }
    catch (err) { /* handle */ }
    finally { setLoading(false) }
  }

  return (
    <form onSubmit={handleSubmit}>
      {/* fields */}
      <button type="submit" disabled={loading}>{loading ? 'Saving...' : 'Save'}</button>
    </form>
  )
}
```

---

## Database patterns

### Query with error handling
```typescript
// Pattern: typed database access with error handling
import { Prisma } from '@prisma/client'

async function get[Entity]ById(id: string) {
  try {
    return await db.[table].findUniqueOrThrow({ where: { id } })
  } catch (error) {
    if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2025') return null
    throw error
  }
}
```

### Transaction
```typescript
// Pattern: multi-table operation in a transaction
await db.$transaction(async (tx) => {
  const a = await tx.[table1].create({ data: { ... } })
  const b = await tx.[table2].update({ where: { id: a.id }, data: { ... } })
  return { a, b }
})
```

---

## Auth patterns

### Protect a server component
```typescript
import { redirect } from 'next/navigation'
import { getSession } from '@/lib/auth'

export default async function ProtectedPage() {
  const session = await getSession()
  if (!session) redirect('/login')
}
```

---

## Error patterns

### Typed application errors
```typescript
export class AppError extends Error {
  constructor(message: string, public statusCode = 400, public code?: string) {
    super(message)
    this.name = 'AppError'
  }
}

// In handlers:
try { /* ... */ }
catch (error) {
  if (error instanceof AppError) return NextResponse.json({ error: error.message }, { status: error.statusCode })
  console.error(error)
  return NextResponse.json({ error: 'Something went wrong' }, { status: 500 })
}
```

---

## Test patterns

### Unit test
```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest'

describe('[unit]', () => {
  beforeEach(() => vi.clearAllMocks())

  it('should [behavior] when [condition]', () => {
    // Arrange / Act / Assert
  })
})
```

### API integration test
```typescript
import { describe, it, expect, vi } from 'vitest'
import { POST } from '@/app/api/[route]/route'

vi.mock('@/lib/db')
vi.mock('@/lib/auth', () => ({ requireAuth: vi.fn(() => ({ id: 'user-1' })) }))

describe('POST /api/[route]', () => {
  it('returns 200 with valid input', async () => { /* ... */ })
  it('returns 401 when unauthenticated', async () => { /* ... */ })
  it('returns 400 with invalid input', async () => { /* ... */ })
})
```

---

<!-- Add new patterns below this line -->
