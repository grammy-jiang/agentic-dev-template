# Cross-Layer Consistency: Ensuring Database, Backend, and Frontend Alignment (Practical + Repeatable)

If you want to **eliminate name/type mismatches** between your database,
backend, and frontend, you need an **automated consistency audit** as part of
your development workflow. This document describes how to ensure the same
entities use identical names and types across all layers.

______________________________________________________________________

## A. The Consistency Problem

Without enforcement, the same data gets different names in different places:

```
┌─────────────────────────────────────────────────────────────────┐
│                    THE CONSISTENCY PROBLEM                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Database (SQL)      Backend (Python)    Frontend (TypeScript)  │
│  ─────────────       ────────────────    ─────────────────────  │
│  user_id             userId              user_id                │
│  INTEGER             int                 string  ← WRONG TYPE   │
│                                                                  │
│  created_at          createdAt           creationDate ← WRONG  │
│  TIMESTAMP           datetime            Date                   │
│                                                                  │
│  user_email          email_address       email  ← ALL DIFFER   │
│  VARCHAR(255)        str                 string                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Consequences of inconsistency:**

- Serialization/deserialization bugs
- Type coercion errors (string vs number)
- Confusion during code reviews
- Difficult debugging across layers
- Onboarding friction for new developers

______________________________________________________________________

## B. The Solution: Contract-First + Consistency Auditing

### Single Source of Truth

The **OpenAPI contract** is the canonical reference:

```text
┌─────────────────────────────────────────────────────────────────┐
│                    SINGLE SOURCE OF TRUTH                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                    OpenAPI Contract                              │
│                    (api-contract.yaml)                           │
│                           │                                      │
│         ┌─────────────────┼─────────────────┐                    │
│         │                 │                 │                    │
│         ▼                 ▼                 ▼                    │
│    ┌─────────┐      ┌──────────┐     ┌───────────┐              │
│    │Database │      │ Backend  │     │ Frontend  │              │
│    │ Schema  │      │  Models  │     │   Types   │              │
│    └─────────┘      └──────────┘     └───────────┘              │
│         │                 │                 │                    │
│         └─────────────────┼─────────────────┘                    │
│                           │                                      │
│                    Cross-Layer                                   │
│                  Consistency Audit                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Workflow

1. **Define in contract**: All entities/fields defined in OpenAPI first
1. **Generate types**: Frontend types generated from contract (not manual)
1. **Implement to contract**: Backend/DB follow contract naming exactly
1. **Audit consistency**: Gate agent verifies all layers match

______________________________________________________________________

## C. Baseline Setup

### 1) Contract Location

Store API contracts in a consistent location:

```
docs/
└── architecture/
    └── [feature-name]/
        ├── api-contract.yaml    # OpenAPI specification
        ├── data-model.md        # Entity documentation
        └── adr-001-*.md         # Architecture decisions
```

### 2) Type Generation

Frontend types should be **generated**, not manually defined:

```bash
# Generate TypeScript types from OpenAPI
npx openapi-typescript docs/architecture/api-contract.yaml \
  -o src/frontend/src/api/types.ts
```

### 3) Custom Agent

| Agent                             | Type | Stage                  | Purpose                                |
| --------------------------------- | ---- | ---------------------- | -------------------------------------- |
| `cross-layer-consistency-auditor` | Gate | 3a. Design Consistency | Verify contracts before implementation |
| `cross-layer-consistency-auditor` | Gate | 4b. Code Consistency   | Verify code after implementation       |

### 4) Two-Stage Consistency Auditing

The consistency auditor runs at **two points** in the lifecycle:

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TWO-STAGE CONSISTENCY AUDIT                              │
└─────────────────────────────────────────────────────────────────────────────┘

  Stage 3. Architecture
      │
      ▼
  Stage 3a. DESIGN CONSISTENCY CHECK (BEFORE IMPLEMENTATION)
      │    └─ Input: API contracts, proposed DB schemas, type definitions
      │    └─ Checks: Contract-to-contract consistency
      │    └─ Output: Approval to implement OR revisions needed
      │    └─ If fail → arch-spec-author revises contracts
      │
      ▼
  Stage 4. Implementation (TDD)
      │
      ▼
  Stage 4b. CODE CONSISTENCY CHECK (AFTER IMPLEMENTATION)
      │    └─ Input: Actual DB schema, backend models, frontend types
      │    └─ Checks: Code-to-contract consistency
      │    └─ Output: Approval for review OR fixes needed
      │    └─ If fail → implementation-driver fixes code
      │
      ▼
  Stage 5-6. Testing → Review
```

**Stage 3a (Design Consistency)** catches:

- API contract field names that don't match DB schema
- Type mismatches in proposed Pydantic models
- Missing fields in frontend type definitions
- Nullability misalignment across layers

**Stage 4b (Code Consistency)** catches:

- Implemented code that drifted from contracts
- Typos in field names during implementation
- Type changes made without updating contracts
- Generated types that are out of date

______________________________________________________________________

## D. Naming Convention Standards

### Expected Conventions by Layer

| Layer                           | Convention   | Example                 |
| ------------------------------- | ------------ | ----------------------- |
| Database (SQL)                  | `snake_case` | `user_id`, `created_at` |
| Backend Python (code)           | `snake_case` | `user_id`, `created_at` |
| Backend Python (Pydantic alias) | `camelCase`  | `userId`, `createdAt`   |
| API JSON                        | `camelCase`  | `userId`, `createdAt`   |
| Frontend TypeScript             | `camelCase`  | `userId`, `createdAt`   |

### Acceptable Transformations

These are **expected** and should not be flagged as inconsistencies:

```
Database          →  API JSON
───────────────────────────────
created_at        →  createdAt     ✅ Case conversion only
user_id           →  userId        ✅ Case conversion only
email_address     →  emailAddress  ✅ Case conversion only
```

### Unacceptable Mismatches

These are **errors** that must be fixed:

```
Database          →  API JSON
───────────────────────────────
created_at        →  creationDate  ❌ Different name
user_id           →  usrId         ❌ Different abbreviation
email_address     →  email         ❌ Different word
```

______________________________________________________________________

## E. Type Mapping Standards

### Database → Backend (Python)

| SQL Type                | Python Type              | Notes                         |
| ----------------------- | ------------------------ | ----------------------------- |
| `VARCHAR`, `TEXT`       | `str`                    |                               |
| `INTEGER`, `BIGINT`     | `int`                    |                               |
| `DECIMAL(p,s)`          | `Decimal`                | **Never use float for money** |
| `BOOLEAN`               | `bool`                   |                               |
| `TIMESTAMP`, `DATETIME` | `datetime`               | With timezone                 |
| `DATE`                  | `date`                   |                               |
| `UUID`                  | `UUID`                   | From `uuid` module            |
| `JSON`, `JSONB`         | `dict` or Pydantic model | Prefer typed models           |
| `ARRAY`                 | `list[T]`                | Typed lists                   |

### Backend (Python) → API (JSON)

| Python Type   | JSON Schema Type             | Notes                      |
| ------------- | ---------------------------- | -------------------------- |
| `str`         | `string`                     |                            |
| `int`         | `integer`                    |                            |
| `float`       | `number`                     | Avoid for currency         |
| `Decimal`     | `string` or `number`         | String preserves precision |
| `bool`        | `boolean`                    |                            |
| `datetime`    | `string` (format: date-time) | ISO 8601                   |
| `date`        | `string` (format: date)      | ISO 8601                   |
| `UUID`        | `string` (format: uuid)      |                            |
| `list[T]`     | `array` (items: T)           |                            |
| `Optional[T]` | nullable or omitted          |                            |

### API (JSON) → Frontend (TypeScript)

| JSON Schema Type     | TypeScript Type    | Notes                  |
| -------------------- | ------------------ | ---------------------- |
| `string`             | `string`           |                        |
| `integer`            | `number`           |                        |
| `number`             | `number`           |                        |
| `boolean`            | `boolean`          |                        |
| `string` (date-time) | `string` or `Date` | Parse as needed        |
| `string` (uuid)      | `string`           | Consider branded types |
| `array`              | `T[]`              |                        |
| nullable             | `T \| null`        |                        |

______________________________________________________________________

## F. Consistency Audit Process

### 1) Collect Definitions

For each entity, gather definitions from all layers:

````markdown
## Entity: User

### Database (schema.sql:42)
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  display_name VARCHAR(100),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP
);
````

### Backend (models/user.py:15)

```python
class User(BaseModel):
    id: UUID
    email: str
    display_name: Optional[str] = None
    created_at: datetime
    updated_at: Optional[datetime] = None
```

### API Contract (api-contract.yaml:89)

```yaml
User:
  type: object
  required: [id, email, createdAt]
  properties:
    id:
      type: string
      format: uuid
    email:
      type: string
    displayName:
      type: string
      nullable: true
    createdAt:
      type: string
      format: date-time
    updatedAt:
      type: string
      format: date-time
      nullable: true
```

### Frontend (types/user.ts:8)

```typescript
interface User {
  id: string;
  email: string;
  displayName?: string;
  createdAt: string;
  updatedAt?: string;
}
```

````

### 2) Compare Fields

Create a comparison matrix:

| Field | Database | Backend | API | Frontend | Status |
|-------|----------|---------|-----|----------|--------|
| id | `id` (UUID) | `id` (UUID) | `id` (string/uuid) | `id` (string) | ✅ |
| email | `email` (VARCHAR) | `email` (str) | `email` (string) | `email` (string) | ✅ |
| displayName | `display_name` | `display_name` | `displayName` | `displayName` | ✅ |
| createdAt | `created_at` | `created_at` | `createdAt` | `createdAt` | ✅ |
| updatedAt | `updated_at` | `updated_at` | `updatedAt` | `updatedAt` | ✅ |

### 3) Flag Issues

When mismatches are found:

```markdown
### Issue: Field Name Mismatch

**Entity**: User
**Field**: email
**Severity**: 🔴 Error

| Layer | Name | Type |
|-------|------|------|
| Database | `user_email` | VARCHAR(255) |
| Backend | `email_address` | str |
| API | `email` | string |
| Frontend | `email` | string |

**Problem**: Three different names for the same field
**Contract says**: `email`
**Fix**:
1. Rename database column: `user_email` → `email`
2. Rename backend field: `email_address` → `email`
````

______________________________________________________________________

## G. Workflow Position

Cross-layer consistency auditing happens during architecture and implementation:

```text
                    arch-spec-author
                           │
                    ┌──────┴──────┐
                    │             │
              API Contract    Data Model
                    │             │
                    └──────┬──────┘
                           │
                    risk-and-nfr-gate
                           │
         ┌─────────────────┴─────────────────┐
         │                                   │
    implementation-driver              ui-scaffolder
         │                                   │
         └─────────────────┬─────────────────┘
                           │
            ┌──────────────────────────────┐
            │   CONSISTENCY AUDIT (NEW)     │
            │                               │
            │  cross-layer-consistency-     │
            │  auditor                      │
            │                               │
            │  Checks:                      │
            │  • Database schema            │
            │  • Backend models             │
            │  • API contract               │
            │  • Frontend types             │
            └──────────────────────────────┘
                           │
                    code-reviewer
```

______________________________________________________________________

## H. Common Pitfalls and Solutions

### 1) Currency/Money Fields

**Problem**: Using `float` causes precision loss

```
Database: DECIMAL(10,2)  →  Backend: float  →  Frontend: number
                                    ↑
                            PRECISION LOSS!
```

**Solution**: Use integer cents or string representation

```
Database: INTEGER (cents)  →  Backend: int  →  API: integer  →  Frontend: number
   1999 cents = $19.99
```

Or use string:

```
Database: DECIMAL(10,2)  →  Backend: Decimal  →  API: string  →  Frontend: string
                                                    "19.99"
```

### 2) Dates and Timezones

**Problem**: Timezone handling inconsistencies

**Solution**: Always use ISO 8601 with timezone

```python
# Backend: Always store and send with timezone
from datetime import datetime, timezone

created_at = datetime.now(timezone.utc)
# Serializes as: "2024-01-15T10:30:00Z"
```

```typescript
// Frontend: Parse ISO strings
const createdAt = new Date(user.createdAt);
```

### 3) Optional vs Nullable

**Problem**: Confusion between omitted fields and null values

```yaml
# API Contract: Be explicit
properties:
  middleName:
    type: string
    nullable: true  # Can be null
    # vs
  nickname:
    type: string    # Optional means can be omitted entirely
```

### 4) ID Types

**Problem**: IDs as strings in frontend but integers in database

**Solution**: Be consistent — prefer UUIDs as strings everywhere

```yaml
# API Contract
id:
  type: string
  format: uuid
  example: "123e4567-e89b-12d3-a456-426614174000"
```

______________________________________________________________________

## I. Enforcement Mechanisms

### 1) Generated Types (Preferred)

Don't write frontend types manually:

```bash
# Add to package.json scripts
"scripts": {
  "generate:types": "openapi-typescript ../docs/architecture/api-contract.yaml -o src/api/types.ts"
}
```

### 2) Contract Testing

Validate backend responses against contract:

```python
# Backend test
from openapi_core import validate_response

def test_user_endpoint_matches_contract():
    response = client.get("/api/users/1")
    validate_response(openapi_spec, response)  # Fails if mismatch
```

### 3) CI Gate

Add consistency check to CI:

```yaml
# .github/workflows/ci.yml
- name: Check API contract consistency
  run: |
    npm run generate:types
    git diff --exit-code src/api/types.ts  # Fail if types changed
```

______________________________________________________________________

## J. Audit Report Format

The `cross-layer-consistency-auditor` produces reports like:

```markdown
## Cross-Layer Consistency Audit

### Verdict: ❌ INCONSISTENCIES FOUND

### Summary
- Entities checked: 5
- Fields checked: 23
- Inconsistencies: 3
- Warnings: 1

### Issues

#### 🔴 Error: Naming Mismatch
- **Entity**: Order
- **Field**: total price
- **Database**: `total_price`
- **Backend**: `totalAmount`
- **API**: `totalPrice`
- **Frontend**: `totalPrice`
- **Fix**: Rename backend field `totalAmount` → `total_price`

#### 🔴 Error: Type Mismatch
- **Entity**: Order
- **Field**: total
- **Database**: `DECIMAL(10,2)`
- **Backend**: `float`
- **Fix**: Change backend to use `Decimal`

#### 🟡 Warning: Nullability Mismatch
- **Entity**: User
- **Field**: bio
- **Database**: allows NULL
- **Backend**: required field
- **Fix**: Either add NOT NULL to DB or make Optional in backend
```

______________________________________________________________________

## K. Guardrails

- **Contract first**: Define in OpenAPI before implementing
- **Generate, don't write**: Frontend types from contract
- **Audit regularly**: Check consistency in CI
- **Case conversion is OK**: `snake_case` → `camelCase` is expected
- **Name changes are not OK**: `email` → `emailAddress` is an error
- **Type precision matters**: Decimal ≠ float

______________________________________________________________________

## L. References

- Agent: `.github/agents/cross-layer-consistency-auditor.agent.md`
- Contract template: `docs/architecture/api-contract-template.yaml`
- Type generation: `openapi-typescript` or `openapi-generator`
- Contract testing: `openapi-core` (Python), `openapi-validator` (Node)
