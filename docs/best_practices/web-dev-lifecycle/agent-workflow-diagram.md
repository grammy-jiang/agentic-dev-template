# Custom Agent Workflow Diagram

This document describes the complete workflow of custom GitHub Copilot agents across the software development lifecycle.

______________________________________________________________________

## Agent Inventory

| #  | Agent                              | Type    | Lifecycle Stage           |
|----|------------------------------------|---------|--------------------------:|
| 1  | `requirements`                     | Builder | 1. Requirements           |
| 2  | `story-builder`                    | Builder | 1. Requirements           |
| 3  | `story-quality-gate`               | Gate    | 1. Requirements           |
| 4  | `story-to-playbook`                | Builder | 1a. Playbook Drafting     |
| 5  | `ui-scaffolder`                    | Builder | 2. UI/UX Design           |
| 6  | `a11y-guardian`                    | Gate    | 2. UI/UX Design           |
| 7  | `arch-spec-author`                 | Builder | 3. Architecture           |
| 8  | `risk-and-nfr-gate`                | Gate    | 3. Architecture           |
| 9  | `cross-layer-consistency-auditor`  | Gate    | 3a. Design Consistency & 4b. Code Consistency |
| 10 | `implementation-design`            | Builder | 4. Implementation         |
| 11 | `implementation-driver`            | Builder | 4. Implementation         |
| 12 | `ci-quality-gate`                  | Gate    | 4. Implementation         |
| 13 | `browser-test-executor`            | Builder | 4a. Story Verification    |
| 14 | `browser-test-gate`                | Gate    | 4a. Story Verification    |
| 15 | `test-drafter`                     | Builder | 5. Testing                |
| 16 | `test-truth-and-stability-gate`    | Gate    | 5. Testing                |
| 17 | `code-reviewer`                    | Gate    | 6. Review                 |
| 18 | `review-comment-fixer`             | Builder | 6. Review                 |
| 19 | `merge-readiness-auditor`          | Gate    | 6. Review                 |
| 20 | `release-pipeline-author`          | Builder | 7. Release & Ops          |
| 21 | `prod-risk-and-rollback-gate`      | Gate    | 7. Release & Ops          |
| 22 | `runbook-and-ops-docs`             | Builder | 7. Release & Ops          |
| 23 | `incident-scribe`                  | Builder | 7. Release & Ops          |

______________________________________________________________________

## Complete Workflow Diagram

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SDLC AGENT WORKFLOW                                  │
└─────────────────────────────────────────────────────────────────────────────┘

1. REQUIREMENTS STAGE
   requirements ──┬──> story-builder ──> story-quality-gate ──┐
                  ├──> ui-scaffolder                          │
                  └──> arch-spec-author <─────────────────────┘

   📥 INPUTS:
   • Raw ideas, stakeholder requests, or problem statements
   • Business goals and success criteria
   • Existing documentation and domain context
   • Constraints (time, budget, compliance, platform)

   📤 OUTPUTS:
   • Feature one-pagers with problem statements and success metrics
   • INVEST-compliant user stories with acceptance criteria (Given/When/Then)
   • Risk register and non-functional requirements (NFRs)
   • Definition of Ready (DoR) validated backlog items

   📋 ISSUE TEMPLATES:
   • `01-feature-request.yml` ← Feature one-pagers
   • `02-user-story.yml` ← User stories with DoR checklist

1a. PLAYBOOK DRAFTING STAGE (After Stories, Before Implementation)
   story-to-playbook
       │
   📥 INPUTS:
   • Validated user stories with acceptance criteria
   • Target URLs and routes for features
   • Test data and authentication requirements

   📤 OUTPUTS:
   • Browser test playbooks (step tables, selectors, assertions)
   • Evidence capture plan (which steps need screenshots)
   • Edge case scenarios (empty, error, permission states)

   ⏰ TIMING: Playbooks drafted NOW, executed AFTER implementation (Stage 4a)

2. ARCHITECTURE STAGE
   arch-spec-author ──> risk-and-nfr-gate ──┬──> cross-layer-consistency-auditor (design)
                                            ├──> implementation-driver
                                            └──> ui-scaffolder

   📥 INPUTS:
   • Feature one-pagers and validated user stories (from Requirements)
   • Acceptance criteria and NFRs (from Requirements)
   • Risk register (from Requirements)
   • Existing codebase patterns and conventions

   📤 OUTPUTS:
   • Architecture brief (context, goals, constraints, quality attributes)
   • API contracts (OpenAPI/JSON Schema) with error models
   • Data models and migration strategies
   • Mermaid/C4 diagrams (context, container, sequence)
   • Architecture Decision Records (ADRs)
   • Threat model and security review

   📋 ISSUE TEMPLATES:
   • `04-architecture-decision.yml` ← ADRs
   • `05-technical-debt.yml` ← Tech debt tracking

3a. DESIGN CONSISTENCY CHECK (Before Implementation)
   cross-layer-consistency-auditor ──┬──> arch-spec-author (if mismatches)
                                     └──> implementation-driver (if approved)

   📥 INPUTS:
   • API contracts (OpenAPI) from Architecture
   • Database schemas and migrations (proposed)
   • Backend model definitions (Pydantic schemas)
   • Frontend type definitions (TypeScript interfaces)

   📤 OUTPUTS:
   • Consistency audit report (all layers)
   • Field-level comparison matrix
   • Type compatibility verification
   • Recommended fixes for mismatches

   🔍 CHECKS:
   • Naming consistency (snake_case → camelCase transformations OK)
   • Type compatibility (DECIMAL vs float, UUID vs string)
   • Nullability alignment (DB NULL vs API required)
   • Generated vs manual types (frontend should generate from contract)

   ⏰ TIMING: Run BEFORE implementation starts to catch contract mismatches early

3. UI/UX DESIGN STAGE
   ui-scaffolder ──> a11y-guardian ──┬──> test-drafter
                                     └──> code-reviewer

   📥 INPUTS:
   • API contracts and data models (from Architecture)
   • User stories with UI-related acceptance criteria (from Requirements)
   • Design specs, wireframes, or mockups (external)
   • Existing design system and component library

   📤 OUTPUTS:
   • UI contract (routes, components, states, responsive requirements)
   • Component scaffolds (SvelteKit/TS) with loading/empty/error states
   • Typed mock data and fixtures
   • Storybook stories for all component states
   • Accessibility audit report (WCAG compliance)

4. IMPLEMENTATION STAGE
   implementation-driver ──┬──> test-drafter
                           ├──> ci-quality-gate (on failures)
                           ├──> browser-test-executor (4a)
                           └──> cross-layer-consistency-auditor (4b)

   📥 INPUTS:
   • API contracts and data models (from Architecture)
   • ADRs and architecture diagrams (from Architecture)
   • UI scaffolds and component contracts (from UI/UX Design)
   • User stories with acceptance criteria (from Requirements)
   • **Failing tests from TDD Red phase** (from Testing)

   📤 OUTPUTS:
   • Production code changes (small, focused commits)
   • Implementation following contracts/specs
   • Error handling and validation logic
   • Logging and observability hooks
   • PR-ready branches with clear descriptions
   • **Tests passing (TDD Green phase)**

   🔄 TDD LOOP (Red → Green → Refactor):
   • test-drafter writes failing test (Red)
   • implementation-driver implements minimal code (Green)
   • implementation-driver refactors while tests stay green
   • Repeat for each behavior

4a. STORY VERIFICATION EXECUTION (After Implementation)
   browser-test-executor ──> browser-test-gate ──┬──> implementation-driver (if bug)
                                                 └──> code-reviewer (if passed)

   📥 INPUTS:
   • Browser test playbooks (from Stage 1a)
   • Implemented feature (from Stage 4)
   • Running application (local or staging)
   • Test data and authentication tokens

   📤 OUTPUTS:
   • Execution reports with step-by-step results
   • Screenshot evidence (success and failure states)
   • Pass/fail verdict per scenario
   • Bug reports for implementation mismatches

   🖥️ MCP TOOLS:
   • `microsoft/playwright-mcp` - Cross-browser automation
   • `io.github.anthropics/chrome-devtools-mcp` - Chrome DevTools

   ⏰ TIMING: Run AFTER implementation is complete, BEFORE code review

4b. CODE CONSISTENCY CHECK (After Implementation)
   cross-layer-consistency-auditor ──┬──> implementation-driver (if mismatches)
                                     └──> code-reviewer (if approved)

   📥 INPUTS:
   • Actual database schema (implemented)
   • Backend models and serializers (implemented)
   • Frontend types and API clients (implemented)
   • API contracts for reference

   📤 OUTPUTS:
   • Code consistency audit report
   • Actual vs contract comparison
   • Mismatch list with line references
   • Required fixes before review

   ⏰ TIMING: Run AFTER implementation, BEFORE code review

5. TESTING STAGE (Supports TDD Red Phase)
   test-drafter ──> test-truth-and-stability-gate ──> code-reviewer

   📥 INPUTS:
   • Acceptance criteria and edge cases (from Requirements) — **tests written first**
   • API contracts for contract testing (from Architecture)
   • UI components and states (from UI/UX Design)
   • Production code changes (from Implementation) — **for validation in Green phase**

   📤 OUTPUTS:
   • Unit tests for business logic (≥95% coverage for core modules)
   • Smoke tests for critical path checks
   • Integration tests for API contracts and DB boundaries
   • E2E tests for critical user paths (keep small)
   • Deterministic fixtures and test data
   • Coverage reports mapped to acceptance criteria

   📋 ISSUE TEMPLATES:
   • `06-test-case-gap.yml` ← Missing test coverage

   🔄 TDD INTEGRATION (Bidirectional with Implementation):
   • Tests written BEFORE implementation (Red phase) — test-drafter initiates
   • Tests follow AAA structure (Arrange → Act → Assert)
   • Behavior over implementation testing
   • Test pyramid: many unit, some integration, few E2E
   • After Green phase, test-drafter may add edge cases and coverage

6. REVIEW STAGE
   code-reviewer ──> review-comment-fixer ──> merge-readiness-auditor
                                                      │
   📥 INPUTS:                                         │
   • PR with code changes (from Implementation)       │
   • Test suite and coverage reports (from Testing)   │
   • Architecture specs for contract verification (from Architecture)
   • User stories for acceptance validation (from Requirements)
                                                      │
   📤 OUTPUTS:                                        │
   • Pre-review report (security, performance, quality, design)
   • Review comment fixes with minimal diffs
   • Merge readiness report (CI status, approvals, conversations)
   • Approved PR ready for merge
                                                      │
7. RELEASE & OPS STAGE                                ▼
   release-pipeline-author <──────────────────────────┘
          │
          ├──> prod-risk-and-rollback-gate
          │           │
          │           └──> runbook-and-ops-docs
          │                       │
          │                       └──> incident-scribe (on incidents)
          │                                   │
          └───────────────────────────────────┴──> story-builder (follow-ups)

   📥 INPUTS:
   • Approved and merged PR (from Review)
   • Architecture specs for deployment context (from Architecture)
   • NFRs for SLO/monitoring requirements (from Requirements)
   • Risk register for rollback planning (from Requirements/Architecture)

   📤 OUTPUTS:
   • GitHub Actions workflows (build, test, deploy)
   • Environment configurations with approval gates
   • Release plan with rollback triggers
   • Risk assessment report (blast radius, irreversible actions)
   • Deployment runbooks with copy-pasteable commands
   • On-call notes and troubleshooting guides
   • Incident timelines and postmortem documents (when needed)

   📋 ISSUE TEMPLATES:
   • `07-release-request.yml` ← Release requests with rollback plan
   • `08-incident-report.yml` ← Post-incident reports
```

______________________________________________________________________

## Issue Template to Agent Mapping

Agents output content compatible with GitHub Issue Forms in `.github/ISSUE_TEMPLATE/`:

| Issue Template | Primary Agent | Gate Agent | Lifecycle Stage |
| -------------- | ------------- | ---------- | --------------- |
| `01-feature-request.yml` | `requirements` | — | Requirements |
| `02-user-story.yml` | `story-builder` | `story-quality-gate` | Requirements |
| `03-bug-report.yml` | `implementation-driver`, `browser-test-gate` | `code-reviewer` | Implementation |
| `04-architecture-decision.yml` | `arch-spec-author` | `risk-and-nfr-gate` | Architecture |
| `05-technical-debt.yml` | `arch-spec-author`, `cross-layer-consistency-auditor` | `risk-and-nfr-gate` | Architecture |
| `06-test-case-gap.yml` | `test-drafter` | `test-truth-and-stability-gate` | Testing |
| `07-release-request.yml` | `release-pipeline-author` | `prod-risk-and-rollback-gate` | Release & Ops |
| `08-incident-report.yml` | `incident-scribe` | — | Release & Ops |

### New Verification Workflows

| Workflow | Primary Agent | Gate Agent | Purpose |
| -------- | ------------- | ---------- | ------- |
| Story → Browser Test | `story-to-playbook` | `browser-test-gate` | Verify stories via browser |
| Consistency Audit | — | `cross-layer-consistency-auditor` | Verify DB/Backend/Frontend alignment |

### Workflow: Agent Output → Issue Creation

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    AGENT TO ISSUE WORKFLOW                                  │
└─────────────────────────────────────────────────────────────────────────────┘

  Agent Drafting (VS Code Chat)          Issue Persistence (GitHub)
  ─────────────────────────────          ─────────────────────────────

  @requirements                          ┌─────────────────────────┐
       │                                 │  01-feature-request.yml │
       │ handoff                         └─────────────────────────┘
       ▼                                           ▲
  @story-builder ──────────────────────────────────┼── copy/paste or
       │                                           │   MCP tool
       │ handoff                         ┌─────────────────────────┐
       ▼                                 │  02-user-story.yml      │
  @story-quality-gate                    └─────────────────────────┘
       │                                           ▲
       │ validated output ─────────────────────────┘
       ▼
  Ready for backlog entry

  Options for issue creation:
  1. Manual: Copy agent output → Paste into GitHub Issue Form
  2. Prompt: Use /story-to-issue-form to format output
  3. MCP: Agent calls GitHub API to create issue directly
```

______________________________________________________________________

## Mermaid Diagram

```mermaid
flowchart TB
    subgraph Requirements["1. Requirements Stage"]
        REQ[requirements]
        SB[story-builder]
        SQG[story-quality-gate]
        REQ --> SB
        SB --> SQG
    end

    subgraph PlaybookDraft["1a. Playbook Drafting"]
        STP[story-to-playbook]
    end

    subgraph Architecture["2. Architecture Stage"]
        ASA[arch-spec-author]
        RNG[risk-and-nfr-gate]
        ASA --> RNG
    end

    subgraph DesignConsistency["3a. Design Consistency Check"]
        CLCA_DESIGN[cross-layer-consistency-auditor<br/>Design Check]
    end

    subgraph UIUX["3. UI/UX Design Stage"]
        UIS[ui-scaffolder]
        A11Y[a11y-guardian]
        UIS --> A11Y
    end

    subgraph Implementation["4. Implementation Stage - TDD"]
        ID[implementation-design]
        IDR[implementation-driver]
        CQG[ci-quality-gate]
        ID --> IDR
        IDR --> CQG
    end

    subgraph StoryVerification["4a. Story Verification - After Implementation"]
        BTE[browser-test-executor]
        BTG[browser-test-gate]
        BTE --> BTG
    end

    subgraph CodeConsistency["4b. Code Consistency Check"]
        CLCA_CODE[cross-layer-consistency-auditor<br/>Code Check]
    end

    subgraph Testing["5. Testing Stage - TDD Support"]
        TD[test-drafter]
        TTSG[test-truth-and-stability-gate]
        TD --> TTSG
    end

    subgraph Review["6. Review Stage"]
        CR[code-reviewer]
        RCF[review-comment-fixer]
        MRA[merge-readiness-auditor]
        CR --> RCF
        RCF --> CR
        CR --> MRA
    end

    subgraph ReleaseOps["7. Release & Ops Stage"]
        RPA[release-pipeline-author]
        PRRG[prod-risk-and-rollback-gate]
        ROD[runbook-and-ops-docs]
        IS[incident-scribe]
        RPA --> PRRG
        PRRG --> ROD
        ROD --> IS
    end

    %% Cross-stage connections - Requirements to downstream
    REQ --> UIS
    REQ --> ASA
    SQG --> ASA
    SQG --> STP

    %% Architecture to downstream
    RNG --> CLCA_DESIGN
    CLCA_DESIGN --> IDR
    RNG --> UIS

    %% Implementation to post-implementation checks
    IDR --> BTE
    STP -.->|"playbooks ready"| BTE
    IDR --> CLCA_CODE
    BTG --> CR
    CLCA_CODE --> CR

    %% Other connections
    A11Y --> TD
    A11Y --> CR
    IDR --> TD
    CQG --> IDR
    TTSG --> CR
    MRA --> RPA
    IS --> SB

    %% TDD Loop (Red → Green → Refactor)
    TD -.->|"Red: failing test"| IDR
    IDR -.->|"Green: minimal code"| TD

    %% Story Verification Loop (after implementation)
    BTG -.->|"Bug found"| IDR
    BTG -.->|"Playbook issue"| STP

    %% Consistency Fix Loops
    CLCA_DESIGN -.->|"Design mismatch"| ASA
    CLCA_CODE -.->|"Code mismatch"| IDR
```

______________________________________________________________________

## Iterative Loops

The workflow supports iteration at multiple points:

| Loop                      | Trigger                     | Flow                                                             |
|---------------------------|-----------------------------|----------------------------------------------------------------- |
| Story Refinement          | Quality issues found        | `story-quality-gate` -> `story-builder`                          |
| Playbook Drafting         | Stories validated           | `story-quality-gate` -> `story-to-playbook` (playbooks wait for implementation) |
| Architecture Update       | Risk/NFR gaps               | `risk-and-nfr-gate` -> `arch-spec-author`                        |
| **Design Consistency**    | **Contract mismatches**     | `cross-layer-consistency-auditor` -> `arch-spec-author` (Stage 3a) |
| Accessibility Fix         | A11y audit fails            | `a11y-guardian` -> `ui-scaffolder`                               |
| **TDD Red→Green**         | **Each behavior change**    | `test-drafter` -> `implementation-driver` -> `test-drafter`      |
| **Story Verification**    | **Implementation complete** | `implementation-driver` -> `browser-test-executor` -> `browser-test-gate` (Stage 4a) |
| **Code Consistency**      | **Code mismatches**         | `cross-layer-consistency-auditor` -> `implementation-driver` (Stage 4b) |
| Test Revision             | Low signal tests            | `test-truth-and-stability-gate` -> `test-drafter`                |
| Review Fix                | Comments to address         | `code-reviewer` -> `review-comment-fixer` -> `code-reviewer`     |
| Incident Follow-up        | Post-incident actions       | `incident-scribe` -> `story-builder`                             |

### Timing Summary

| Stage | What Happens | When |
|-------|--------------|------|
| **1a. Playbook Drafting** | Create browser test playbooks | After stories validated, before implementation |
| **3a. Design Consistency** | Verify contracts are consistent | After architecture, before implementation |
| **4. Implementation** | Write code following TDD | After design consistency approved |
| **4a. Story Verification** | Execute playbooks in browser | After implementation complete |
| **4b. Code Consistency** | Verify code matches contracts | After implementation, before code review |
| **5. Testing** | TDD support (Red phase happens in 4) | Continuous during implementation |
| **6. Review** | Code review | After 4a and 4b gates pass |

### TDD Loop Detail (Red → Green → Refactor)

> **Note on Stage Ordering**: While the lifecycle stages are numbered sequentially (4. Implementation, 5. Testing), TDD requires **tests to drive implementation**. The `test-drafter` and `implementation-driver` agents work in a tight loop across stages 4-5, with tests written first (Red), then code (Green), then improvement (Refactor).

```text
┌─────────────────────────────────────────────────────────────┐
│                    TDD CYCLE                                │
│                                                             │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐              │
│   │   RED    │───>│  GREEN   │───>│ REFACTOR │──┐           │
│   │  (test)  │    │  (code)  │    │ (improve)│  │           │
│   └──────────┘    └──────────┘    └──────────┘  │           │
│        ^                                        │           │
│        └────────────────────────────────────────┘           │
│                                                             │
│   Agents:                                                   │
│   • RED: test-drafter writes failing test                   │
│   • GREEN: implementation-driver writes minimal code        │
│   • REFACTOR: implementation-driver improves structure      │
│   • Gate: test-truth-and-stability-gate validates tests     │
└─────────────────────────────────────────────────────────────┘
```

______________________________________________________________________

## Stage Entry Points

Different scenarios have different entry points:

| Scenario                    | Start Agent                                | Path                                                       |
| --------------------------- | ------------------------------------------ | ---------------------------------------------------------- |
| New feature from idea       | `requirements`                             | Full lifecycle                                             |
| **Draft playbooks early**   | `story-to-playbook`                        | Story → Playbook (then wait for implementation)            |
| **Run browser tests**       | `browser-test-executor`                    | Execute playbooks after implementation                     |
| Design-ready feature        | `ui-scaffolder` or `arch-spec-author`      | Skip requirements                                          |
| **TDD-driven feature**      | `test-drafter`                             | Red -> Green -> Refactor loop with `implementation-driver` |
| **Check design consistency**| `cross-layer-consistency-auditor`          | Audit contracts before implementation (Stage 3a)           |
| **Check code consistency**  | `cross-layer-consistency-auditor`          | Audit code after implementation (Stage 4b)                 |
| Bug fix                     | `test-drafter` (write failing test first)  | TDD path: Red -> Green                                     |
| Test coverage improvement   | `test-drafter`                             | Testing only                                               |
| Hotfix/emergency            | `implementation-driver` -> `code-reviewer` | Fast path (add tests after)                                |
| Incident response           | `incident-scribe`                          | Ops path                                                   |

______________________________________________________________________

## Agent Responsibilities Summary

### Builder Agents (Create artifacts)

- **requirements**: Feature one-pagers, acceptance criteria, risk analysis
- **story-builder**: INVEST-compliant user stories with **testable acceptance criteria**
- **story-to-playbook**: **Convert user stories to executable browser test playbooks**
- **browser-test-executor**: **Execute playbooks in headless browser, capture screenshots**
- **ui-scaffolder**: UI components, mock data, Storybook stories
- **arch-spec-author**: API contracts, diagrams, ADRs, data models, **contract test stubs**
- **implementation-design**: Technical specs without code
- **implementation-driver**: Production code using **TDD (Red→Green→Refactor)**
- **test-drafter**: Unit, smoke, integration, and E2E tests; **supports TDD Red phase**
- **review-comment-fixer**: Implements reviewer feedback
- **release-pipeline-author**: CI/CD workflows, deployment scripts
- **runbook-and-ops-docs**: Operational documentation
- **incident-scribe**: Incident timelines, postmortems

### Gate Agents (Quality control)

- **story-quality-gate**: INVEST validation, DoR checks, **testability verification**
- **browser-test-gate**: **Validate browser test results, verify story satisfaction with evidence**
- **a11y-guardian**: Accessibility audits
- **risk-and-nfr-gate**: Security, threat model, NFR review
- **cross-layer-consistency-auditor**: **Verify naming/type consistency across DB, backend, frontend**
- **ci-quality-gate**: CI failure analysis and fixes; **coverage enforcement**
- **test-truth-and-stability-gate**: Test quality validation, **AAA structure, determinism checks**
- **code-reviewer**: Pre-merge code review
- **merge-readiness-auditor**: Merge criteria verification, **coverage gate**
- **prod-risk-and-rollback-gate**: Release safety review

______________________________________________________________________

## Configuration Files

The agent workflow is governed by these configuration files:

| File | Purpose | Used By |
| ---- | ------- | ------- |
| `.github/copilot-instructions.md` | Universal rules (INVEST, DoR, output format) | VS Code Chat, Coding Agent |
| `.github/instructions/issue-output.instructions.md` | Issue-specific output formatting | VS Code Chat, Coding Agent |
| `.github/prompts/story-to-issue-form.prompt.md` | Interactive `/story-to-issue-form` command | VS Code Chat |
| `.github/ISSUE_TEMPLATE/*.yml` | Structured issue intake forms | GitHub Issues |
| `.github/agents/*.agent.md` | Agent definitions with handoffs | VS Code Chat |
