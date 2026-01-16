# Agile Feature Requirements Gathering: How to Integrate GitHub Copilot (Practical + Repeatable)

If you want Copilot to *raise* requirement quality (not just generate text), you need an **operating model** with **artifacts, gates, and reusable prompts**. Treat Copilot outputs as **drafts + hypotheses**; you own scope, priority, and risk.

---

## A. Baseline setup (so Copilot stays on-rails)

### 1) Repo-wide instructions = “policy”
- Create `.github/copilot-instructions.md` to encode your consistent rules: story format, required fields, definition of ready, security/privacy baselines, tech constraints (Python backend + TS frontend), etc.
- Add **path-specific instructions** under `.github/instructions/*.instructions.md` for product docs vs engineering docs (avoid conflicting rules; instruction resolution can be unpredictable when rules collide).

### 2) Prompt files = “playbooks”
- Put reusable prompts in `.github/prompts/*.prompt.md`.
- Use YAML frontmatter (e.g., `name`, `description`, `agent`, `tools`) so each prompt behaves like a standard operating procedure you can invoke repeatedly.

### 3) Grounding = “don’t hallucinate the system”
- In VS Code chat, use workspace grounding (e.g., `@workspace`) so Copilot aligns with your actual repository conventions and existing patterns.

---

## B. Agile requirements workflow, with Copilot embedded (end-to-end)

### 1) Intake → “Feature one-pager”
**Goal:** convert raw ideas into a crisp, testable problem statement.

**You provide (inputs):**
- Problem + users + “why now”
- Success metric (what changes if we win)
- Constraints (time, compliance, platform, dependencies)

**Copilot does (drafts):**
- A **one-pager** with: Problem, Goals, Non-goals, Assumptions, Open questions, Risks, Metrics, Milestones
- A **clarifying questions list** (often the highest ROI output)

**Gate/guardrail:** if there’s no measurable success metric and no explicit non-goals, the “requirement” is not ready.

**Reusable prompt idea (VS Code chat):**
> Convert these notes into a feature one-pager. Be skeptical: list assumptions, open questions, and risks. Output in a strict template.

---

### 2) Discovery → “Risks + edge cases + constraints”
**Goal:** expose landmines early (permissions, data, privacy, scalability, migrations).

**Copilot does:**
- Generates a **risk register**: security, privacy, abuse cases, operational risks
- Drafts **NFRs** (non-functional requirements): latency, availability, audit, rate limits, observability hooks
- Lists **dependencies**: APIs, tables, services, third parties

**Your job:** decide tradeoffs; reject fantasy constraints.

---

### 3) Story mapping & slicing → “Epics → Stories (INVEST)”
**Goal:** break the feature into deliverable slices that can ship incrementally.

**Copilot does:**
- Proposes **user journey steps** and a story map
- Generates **small stories** aligned to slices (happy path first, then hardening)
- Proposes explicit **out-of-scope** items (scope control)

**Gate/guardrail:** any story that can’t be acceptance-tested is not a story; it’s a vague wish.

---

### 4) Acceptance criteria (BDD) → “Given/When/Then + negative cases”
**Goal:** turn “we think” into **verifiable behavior**.

**Copilot does:**
- Writes Given/When/Then acceptance criteria
- Enumerates negative cases: auth failures, empty state, concurrency, timeouts, idempotency, partial failures

**Your job:** confirm business meaning; remove contradictions.

---

### 5) Definition of Ready (DoR) gate → “Backlog hygiene”
**Goal:** stop half-baked work entering implementation.

**Copilot can run a DoR checklist:**
- User value stated?
- Success metric defined (ideally quantified)?
- Acceptance criteria complete?
- Dependencies known?
- Data model touched (yes/no)?
- Migration/rollback considered?
- Security/privacy considered?
- Telemetry/observability defined?

If “no” on key items → story returns to refinement.

---

### 6) Sprint planning support → “Tasks + estimates (bounded)”
**Goal:** reduce planning overhead without letting AI invent schedules.

**Copilot does:**
- Breaks a story into engineering tasks (backend, frontend, migration, tests, telemetry)
- Highlights risky tasks and unknowns

**Gate/guardrail:** Copilot can suggest relative sizing, but estimation commitments remain your call.

---

## C. Where Copilot Coding Agent / CLI fits (even in requirements stage)

This stage is mostly text + structure, but Copilot Coding Agent can still be useful for **repo artifacts** (templates, docs, scaffolding):

- **Create/update requirement templates** (issue forms, docs structure) via PR.
- Use Copilot CLI to delegate structured work (e.g., generate templates, reorganize docs, add checklists) and get a draft PR back.
- Keep governance tight: require human review for merges, and treat agent outputs like any other contributor.

---

## D. Recommended “custom agents” for this step (keep it lean)

For Feature Requirements Gathering, don’t over-fragment. A pragmatic approach:

### One custom agent (“requirements”) + multiple prompt files
- **Agent**: `requirements` = consistent voice, skepticism, templates, DoR/AC standards.
- **Prompt files** (commands):
  - `/intake-onepager`
  - `/discover-risks-nfr`
  - `/slice-stories`
  - `/write-acceptance-criteria`
  - `/dor-check`

Prompt files live in `.github/prompts/*.prompt.md` and can set `agent:` plus tools.

---

## Example prompt file skeleton

```markdown
---
name: intake-onepager
description: Turn raw notes into a feature one-pager with open questions and risks
agent: agent
---
You are the Requirements Analyst.
Input: ${input:notes:Paste raw notes}

Output a one-pager with:
- Problem / Users / Goals / Non-goals
- Success metrics (quantified)
- Assumptions
- Open questions (ranked by risk)
- Dependencies
- Risks + mitigations

Be skeptical and avoid inventing facts.
```

---

## Next step suggestion

If you want to proceed one-by-one, the next concrete deliverable is to produce:

- `requirements.agent.md` (the agent’s stable “constitution”)
- Five `.github/prompts/*.prompt.md` files corresponding to the workflow steps above
- A minimal `.github/copilot-instructions.md` that enforces DoR, story format, and acceptance criteria rules
