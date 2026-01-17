# agentic-dev-template

> AI-first GitHub template that standardizes specs, architecture notes, guardrails, and CI quality gates so coding agents (e.g., Copilot) can ship predictable changes with tests, reviews, and reproducible workflows.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## ✨ Features

- **8-Stage Development Lifecycle** — Requirements → UI/UX → Architecture → Implementation → Testing → Review → Release & Ops
- **19 Custom Copilot Agents** — Builder agents create artifacts; Gate agents enforce quality at each stage
- **Structured Issue Templates** — Feature requests, user stories, ADRs, bug reports, incident reports, and more
- **TDD-First Workflow** — Red→Green→Refactor cycle with test-drafter and implementation-driver agents
- **Quality Gates Built-in** — INVEST story validation, accessibility audits, security reviews, coverage enforcement
- **Iterative Feedback Loops** — Agents hand off and loop back when quality gates identify issues

______________________________________________________________________

## 🚀 Quick Start

1. **Create from template** — Click "Use this template" on GitHub to create your own repository
1. **Enable Copilot** — Install [GitHub Copilot](https://docs.github.com/en/copilot) extension in VS Code
1. **Read the lifecycle guides** — See [docs/best_practices/web-dev-lifecycle/](docs/best_practices/web-dev-lifecycle/)
1. **Start with Requirements** — Use Copilot Chat to draft your first feature story
1. **Follow the workflow** — Progress through each stage with Copilot agents

______________________________________________________________________

## 📋 The AI-Assisted Development Lifecycle

| Stage                 | Copilot Support                                               | Issue Templates                                         |
| --------------------- | ------------------------------------------------------------- | ------------------------------------------------------- |
| **1. Requirements**   | Draft user stories, acceptance criteria, risk analysis        | `01-feature-request.yml`, `02-user-story.yml`           |
| **2. UI/UX Design**   | Scaffold components, generate mock data, accessibility audits | —                                                       |
| **3. Architecture**   | Generate diagrams, API specs, ADRs, threat models             | `04-architecture-decision.yml`, `05-technical-debt.yml` |
| **4. Implementation** | TDD Red→Green→Refactor cycle, code generation                 | `03-bug-report.yml`                                     |
| **5. Testing**        | Generate unit/integration/E2E tests, ensure coverage          | `06-test-case-gap.yml`                                  |
| **6. Code Review**    | Pre-review analysis, implement feedback                       | —                                                       |
| **7. Release & Ops**  | Generate pipelines, runbooks, incident analysis               | `07-release-request.yml`, `08-incident-report.yml`      |

See [Agent Workflow Diagram](docs/best_practices/web-dev-lifecycle/agent-workflow-diagram.md) for detailed agent orchestration.

______________________________________________________________________

## 🔄 Iterative Loops

Development is not strictly linear. Quality gates trigger refinement loops:

| Loop                    | Flow                                                       | Purpose                        |
| ----------------------- | ---------------------------------------------------------- | ------------------------------ |
| **Story Refinement**    | `story-quality-gate` → `story-builder`                     | Fix INVEST violations          |
| **Architecture Update** | `risk-and-nfr-gate` → `arch-spec-author`                   | Address security/NFR gaps      |
| **TDD Cycle**           | `test-drafter` → `implementation-driver` → `test-drafter`  | Red→Green→Refactor             |
| **Review Feedback**     | `code-reviewer` → `review-comment-fixer` → `code-reviewer` | Iterate until merge-ready      |
| **Incident Follow-up**  | `incident-scribe` → `story-builder`                        | Convert learnings into stories |

______________________________________________________________________

## 🤖 Custom Copilot Agents

| Type        | Agents                                                                                                                                                                                                      | Role             |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| **Builder** | `requirements`, `story-builder`, `ui-scaffolder`, `arch-spec-author`, `implementation-driver`, `test-drafter`, `review-comment-fixer`, `release-pipeline-author`, `runbook-and-ops-docs`, `incident-scribe` | Create artifacts |
| **Gate**    | `story-quality-gate`, `a11y-guardian`, `risk-and-nfr-gate`, `ci-quality-gate`, `test-truth-and-stability-gate`, `code-reviewer`, `merge-readiness-auditor`, `prod-risk-and-rollback-gate`                   | Enforce quality  |

______________________________________________________________________

## 📁 Repository Structure

```
├── .github/
│   ├── agents/              # Custom Copilot agent definitions
│   ├── ISSUE_TEMPLATE/      # Structured issue templates
│   ├── skills/              # Reusable agent skills
│   └── copilot-instructions.md
├── docs/best_practices/
│   └── web-dev-lifecycle/   # 8-stage lifecycle guides
├── src/
│   ├── backend/
│   └── frontend/
└── scripts/
```

______________________________________________________________________

## 🎯 Key Principles

| Principle               | Description                                                                     |
| ----------------------- | ------------------------------------------------------------------------------- |
| **INVEST Stories**      | Independent, Negotiable, Valuable, Estimable, Small, Testable                   |
| **Definition of Ready** | User value, success metrics, acceptance criteria, dependencies, security review |
| **TDD**                 | Red (failing test) → Green (minimal code) → Refactor (improve structure)        |
| **Quality Gates**       | Automated checks at each stage before progressing                               |

______________________________________________________________________

## 📚 Documentation

| Topic                        | Link                                                                                                   |
| ---------------------------- | ------------------------------------------------------------------------------------------------------ |
| Lifecycle Guides             | [docs/best_practices/web-dev-lifecycle/](docs/best_practices/web-dev-lifecycle/)                       |
| Agent Workflow               | [agent-workflow-diagram.md](docs/best_practices/web-dev-lifecycle/agent-workflow-diagram.md)           |
| Custom Agents Best Practices | [copilot-custom-agents-best-practices.md](docs/best_practices/copilot-custom-agents-best-practices.md) |
| TDD Best Practices           | [tdd-best-practices.md](docs/best_practices/tdd-best-practices.md)                                     |
| Git Commit Messages          | [git-commit-message-best-practices.md](docs/best_practices/git-commit-message-best-practices.md)       |

______________________________________________________________________

## 💬 Support

- **Questions & Discussions** — Use [GitHub Discussions](../../discussions)
- **Bug Reports** — Use the `03-bug-report.yml` issue template
- **Feature Requests** — Use the `01-feature-request.yml` issue template

______________________________________________________________________

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines and development setup.

______________________________________________________________________

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

______________________________________________________________________

## 🔗 Related Resources

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [INVEST User Story Principles](<https://en.wikipedia.org/wiki/INVEST_(mnemonic)>)
- [Agile Acceptance Criteria (BDD/Gherkin)](https://cucumber.io/docs/gherkin/)
- [Architecture Decision Records (ADRs)](https://adr.github.io/)
