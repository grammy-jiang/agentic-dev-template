# Story Browser Verification: Converting User Stories to Executable Test Playbooks (Practical + Repeatable)

If you want to **verify that implemented features actually satisfy user
stories**, you need a verification loop that goes beyond code tests. This stage
uses **browser automation via MCP tools** to execute user stories as real
browser interactions, with **screenshot evidence** to prove story satisfaction.

______________________________________________________________________

## A. Why Browser-Based Story Verification?

Traditional testing validates code behavior. Story verification validates **user
experience**:

| Level                  | What It Tests           | Tools             | Proves                 |
| ---------------------- | ----------------------- | ----------------- | ---------------------- |
| Unit tests             | Functions work          | Jest, pytest      | Code correctness       |
| Integration tests      | APIs work               | Supertest, pytest | System correctness     |
| E2E tests              | Flows work              | Playwright        | Technical flow works   |
| **Story verification** | **User goals achieved** | **MCP + Browser** | **Story is satisfied** |

Story verification answers: "Can a user actually do what the story describes?"

______________________________________________________________________

## B. Baseline Setup

### 1) MCP Browser Tools

This workflow requires MCP (Model Context Protocol) browser tools:

- **Playwright MCP** (`microsoft/playwright-mcp`): Cross-browser automation
- **Chrome DevTools MCP** (`io.github.anthropics/chrome-devtools-mcp`):
  Chrome-specific testing

These allow Copilot agents to control headless browsers, navigate pages,
interact with elements, and capture screenshots.

### 2) Test Evidence Storage

Configure directories for test artifacts:

```
tests/
├── e2e/
│   ├── playbooks/           # Story playbook definitions
│   │   └── user-login.playbook.md
│   └── evidence/            # Execution screenshots
│       ├── user-login/
│       │   ├── SS-001-initial.png
│       │   └── SS-002-success.png
│       └── reports/
│           └── execution-2024-01-15.md
```

### 3) Custom Agents for This Stage

| Agent                   | Type    | Stage                  | Purpose                                      |
| ----------------------- | ------- | ---------------------- | -------------------------------------------- |
| `story-to-playbook`     | Builder | 1a. Playbook Drafting  | Convert user stories to executable playbooks |
| `browser-test-executor` | Builder | 4a. Story Verification | Execute playbooks in headless browser        |
| `browser-test-gate`     | Gate    | 4a. Story Verification | Validate execution results and evidence      |

### 4) Timing: When to Create vs Execute

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    PLAYBOOK LIFECYCLE TIMING                                │
└─────────────────────────────────────────────────────────────────────────────┘

  Stage 1. Requirements
      │
      ▼
  Stage 1a. Playbook Drafting (CREATE PLAYBOOKS NOW)
      │    └─ story-to-playbook converts stories to playbooks
      │    └─ Playbooks saved to tests/e2e/playbooks/
      │
      ▼
  Stage 2. Architecture
      │
      ▼
  Stage 3. UI/UX Design
      │
      ▼
  Stage 4. Implementation (TDD)
      │
      ▼
  Stage 4a. Story Verification (EXECUTE PLAYBOOKS NOW)
      │    └─ browser-test-executor runs playbooks against implemented feature
      │    └─ Screenshots captured to tests/e2e/evidence/
      │    └─ browser-test-gate validates results
      │
      ▼
  Stage 5-7. Testing → Review → Release
```

**Key Insight:** Playbooks are created early (after stories) but executed late
(after implementation). This ensures:

- Playbooks are reviewed alongside stories
- Implementation has clear testable targets
- Evidence proves stories are satisfied

______________________________________________________________________

## C. Story Verification Workflow

### 1) Story → Playbook Conversion (Stage 1a)

**Goal:** Transform acceptance criteria into executable browser steps.

**Input:** User story with Given/When/Then acceptance criteria

**Output:** Playbook with step-by-step browser actions

**Agent:** `story-to-playbook`

**Timing:** Immediately after stories pass `story-quality-gate`

**Process:**

```text
Acceptance Criterion:
  Given I am on the login page
  When I enter valid credentials and click submit
  Then I should see the dashboard with my name

        ↓ Conversion

Playbook Steps:
  1. navigate → /login
  2. wait_for → [data-testid="login-form"]
  3. fill → [data-testid="email"] → "test@example.com"
  4. fill → [data-testid="password"] → "password123"
  5. click → [data-testid="submit"]
  6. wait_for → [data-testid="dashboard"]
  7. assert → [data-testid="user-name"] → contains: "Test User"
  8. screenshot → evidence/SS-001-dashboard.png
```

**Playbook Structure:**

```markdown
## Playbook: User Login

### Metadata
- Story: #123 - User can log in
- URL: /login
- Prerequisites: Test user exists

### Scenario 1: Successful Login
| Step | Action | Target | Value | Evidence |
|------|--------|--------|-------|----------|
| 1 | navigate | /login | - | 📸 |
| 2 | fill | [data-testid="email"] | test@example.com | - |
| 3 | fill | [data-testid="password"] | ******** | - |
| 4 | click | [data-testid="submit"] | - | - |
| 5 | assert | [data-testid="dashboard"] | visible | 📸 |
```

______________________________________________________________________

### 2) Playbook Execution (Stage 4a - After Implementation)

**Goal:** Run the playbook in a real (headless) browser.

**Input:** Executable playbook + implemented feature

**Output:** Execution report with screenshots

**Agent:** `browser-test-executor`

**Timing:** After `implementation-driver` completes the feature (Stage 4)

**Prerequisites:**

- Feature implementation is complete
- Application is running (local dev server or staging)
- Playbooks exist from Stage 1a

**MCP Tools Used:**

- `microsoft/playwright-mcp` for browser control
- `io.github.anthropics/chrome-devtools-mcp` for Chrome-specific needs

**Execution Flow:**

```text
┌─────────────────────────────────────────────────────────────┐
│                 BROWSER TEST EXECUTION                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. SETUP                                                    │
│     ├─ Launch headless browser                              │
│     ├─ Set viewport (1280x720)                              │
│     └─ Prepare test data                                    │
│                                                              │
│  2. EXECUTE (per scenario)                                   │
│     ├─ For each step:                                       │
│     │   ├─ Execute action (navigate, click, fill, etc.)    │
│     │   ├─ Wait for condition if specified                  │
│     │   ├─ Run assertion if specified                       │
│     │   └─ Capture screenshot if marked (📸)                │
│     └─ Record pass/fail status                              │
│                                                              │
│  3. REPORT                                                   │
│     ├─ Generate execution summary                           │
│     ├─ Attach all screenshots                               │
│     └─ Log any errors or console messages                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Screenshot Evidence:**

Screenshots are captured at:

- Initial page state
- After key interactions
- On success (final state)
- On failure (diagnostic)

______________________________________________________________________

### 3) Result Validation

**Goal:** Verify that execution proves story satisfaction.

**Input:** Execution report with screenshots

**Output:** Validation verdict (approved/rejected)

**Agent:** `browser-test-gate`

**Validation Checks:**

1. **Reliability Check**

   - [ ] No flaky failures (timeouts, race conditions)
   - [ ] All scenarios executed
   - [ ] Assertions used stable selectors

1. **Coverage Check**

   - [ ] All acceptance criteria have corresponding scenarios
   - [ ] Edge cases tested (empty, error, permission)

1. **Evidence Check**

   - [ ] Screenshots capture expected UI states
   - [ ] Screenshots are legible and diagnostic
   - [ ] Success screenshots match story expectations

1. **Result Classification**

   - ✅ **Pass**: Story is verified
   - ❌ **Fail (Bug)**: Implementation doesn't match story
   - ⚠️ **Fail (Test)**: Playbook needs revision

______________________________________________________________________

## D. Selector Strategy

Use stable selectors that won't break with UI changes:

### Priority Order

1. **data-testid** (preferred)

   ```html
   <button data-testid="submit-login">Log In</button>
   ```

   ```
   click → [data-testid="submit-login"]
   ```

1. **Role + Name**

   ```
   click → role=button[name="Log In"]
   ```

1. **Label association**

   ```
   fill → label=Email → test@example.com
   ```

1. **Placeholder**

   ```
   fill → placeholder=Enter your email → test@example.com
   ```

### Avoid

- ❌ Dynamic IDs: `#user-12345`
- ❌ CSS classes: `.btn-primary`
- ❌ Position-based: `div > button:first-child`
- ❌ Style-based: `[style="color: red"]`

______________________________________________________________________

## E. Edge Case Coverage

Every playbook should include scenarios for:

| Edge Case         | Scenario            | Evidence             |
| ----------------- | ------------------- | -------------------- |
| Empty state       | No data exists      | 📸 Empty state UI    |
| Validation error  | Invalid input       | 📸 Error messages    |
| Permission denied | Unauthorized access | 📸 403 page          |
| Network error     | API failure         | 📸 Error state       |
| Loading state     | Slow response       | 📸 Loading indicator |

______________________________________________________________________

## F. Integration with TDD

Story verification complements TDD:

```text
┌─────────────────────────────────────────────────────────────┐
│               VERIFICATION LEVELS                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  TDD (Code Level)                                            │
│  ├─ Unit tests → Functions work                             │
│  ├─ Integration tests → APIs work                           │
│  └─ Runs in CI on every commit                              │
│                                                              │
│  Story Verification (User Level)                             │
│  ├─ Playbook execution → User can do X                      │
│  ├─ Screenshot evidence → UI looks correct                  │
│  └─ Runs after implementation, before story closure         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

______________________________________________________________________

## G. Workflow Position

Story verification happens after implementation, before story closure:

```text
story-builder → story-quality-gate → arch-spec-author
                                           ↓
                              implementation-driver (TDD)
                                           ↓
                              test-drafter → test-truth-gate
                                           ↓
                            ┌──────────────────────────────┐
                            │   STORY VERIFICATION (NEW)    │
                            │                               │
                            │  story-to-playbook            │
                            │         ↓                     │
                            │  browser-test-executor        │
                            │         ↓                     │
                            │  browser-test-gate            │
                            └──────────────────────────────┘
                                           ↓
                                    code-reviewer
                                           ↓
                                   Story Verified ✅
```

______________________________________________________________________

## H. Example: Full Verification Flow

### User Story

```markdown
## User Story: User Login

As a registered user,
I want to log in with my email and password,
So that I can access my personalized dashboard.

### Acceptance Criteria

**Happy Path:**
- Given I am on the login page
- When I enter valid email and password
- And I click the login button
- Then I should see my dashboard
- And my name should be displayed in the header

**Edge Case: Invalid Credentials:**
- Given I am on the login page
- When I enter invalid credentials
- And I click the login button
- Then I should see an error message
- And I should remain on the login page
```

### Generated Playbook

```markdown
## Playbook: User Login (#123)

### Scenario 1: Successful Login
| Step | Action | Target | Value | Evidence |
|------|--------|--------|-------|----------|
| 1 | navigate | /login | - | 📸 Initial |
| 2 | fill | [data-testid="email"] | user@test.com | - |
| 3 | fill | [data-testid="password"] | Test123! | - |
| 4 | click | [data-testid="submit"] | - | - |
| 5 | wait_for | [data-testid="dashboard"] | - | - |
| 6 | assert | [data-testid="user-name"] | contains: Test User | 📸 Success |

### Scenario 2: Invalid Credentials
| Step | Action | Target | Value | Evidence |
|------|--------|--------|-------|----------|
| 1 | navigate | /login | - | - |
| 2 | fill | [data-testid="email"] | wrong@test.com | - |
| 3 | fill | [data-testid="password"] | wrongpass | - |
| 4 | click | [data-testid="submit"] | - | - |
| 5 | assert | [data-testid="error-message"] | visible | 📸 Error |
| 6 | assert | url | contains: /login | - |
```

### Execution Report

```markdown
## Execution Report: User Login

**Status**: ✅ ALL PASSED
**Duration**: 4.2s
**Screenshots**: 3

| Scenario | Status | Duration |
|----------|--------|----------|
| Successful Login | ✅ | 2.8s |
| Invalid Credentials | ✅ | 1.4s |

### Evidence
- [SS-001-initial.png] - Login page loaded
- [SS-002-success.png] - Dashboard with user name
- [SS-003-error.png] - Error message displayed
```

______________________________________________________________________

## I. Guardrails

- **Playbooks are derived from stories**: No playbook without a source story
- **Deterministic execution**: Fixed test data, no randomness
- **Evidence is mandatory**: Every scenario needs screenshot proof
- **Stable selectors only**: Use data-testid, not CSS classes
- **Edge cases required**: Happy path alone is insufficient
- **Gate before closure**: Stories aren't done until browser-verified

______________________________________________________________________

## J. References

- Agent definitions: `.github/agents/story-to-playbook.agent.md`,
  `browser-test-executor.agent.md`, `browser-test-gate.agent.md`
- MCP tools: Playwright MCP, Chrome DevTools MCP
- Evidence storage: `tests/e2e/evidence/`
- Playbook storage: `tests/e2e/playbooks/`
