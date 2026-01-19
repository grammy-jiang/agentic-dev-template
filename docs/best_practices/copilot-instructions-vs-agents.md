# GitHub Copilot: `copilot-instructions.md` vs `AGENTS.md`

> This document explains the practical differences between GitHub’s repository
> instructions file and the community “agents” instruction file, and how to use
> both for best outcomes across Copilot in VS Code, Copilot CLI, and the Copilot
> coding agent.

______________________________________________________________________

## English

### 1) What `copilot-instructions.md` is

**`copilot-instructions.md`** is GitHub’s native format for **repository-wide
Copilot guidance**. It is typically placed at:

- `.github/copilot-instructions.md` (repo root)

It’s intended to capture **high-level project context and conventions**
(architecture, tech stack, style rules, testing expectations, etc.) so Copilot
can produce more aligned suggestions across the repository.

### 2) What `AGENTS.md` is

**`AGENTS.md`** is a cross-tool, agent-oriented instruction file (the “agents”
convention). It can be placed:

- At the repo root (e.g., `AGENTS.md`)
- Or in subfolders (e.g., `frontend/AGENTS.md`, `backend/AGENTS.md`)

Its primary value is **agent execution guidance**: setup steps, exact commands,
how to run tests, how to validate changes, and folder-specific rules.

### 3) Key differences

- **Ownership / Standard**

  - `copilot-instructions.md`: GitHub-defined Copilot format.
  - `AGENTS.md`: Open “agents” convention; intended for compatibility across
    agent tools.

- **Scope & placement**

  - `copilot-instructions.md`: Generally one repo-wide file under `.github/`.
  - `AGENTS.md`: Can be nested; nearest (most specific) `AGENTS.md` can apply
    for a given folder.

- **Content style**

  - `copilot-instructions.md`: Best for durable, high-level engineering rules
    and project identity.
  - `AGENTS.md`: Best for operational instructions and agent-ready “how to
    run/verify” checklists.

- **Tool support**

  - VS Code Copilot features strongly align with `copilot-instructions.md`.
  - Copilot CLI and agent modes can consume `AGENTS.md` (and in newer flows may
    read both).
  - If multiple instruction sources apply, avoid contradictions—agents may
    behave unpredictably.

### 4) How to use both in a Python + JS/TS web repository

#### Recommended baseline layout

```
repo/
  .github/
    copilot-instructions.md
  AGENTS.md
  backend/
    AGENTS.md        # optional, if backend needs different commands/rules
  frontend/
    AGENTS.md        # optional, if frontend needs different commands/rules
```

#### What goes where (practical split)

**Put in `.github/copilot-instructions.md`** (global, stable context)

- Repo purpose and architecture (monorepo? separate frontend/backend? APIs?)
- Languages & frameworks (Python backend; JS/TS frontend)
- Code conventions (formatters, lint rules, naming, module boundaries)
- Security expectations (no secrets; env vars; safe defaults)
- Quality bar (tests required; coverage expectations; CI checks)

**Put in `AGENTS.md`** (agent execution guidance)

- Setup commands
- Dev run commands
- Test commands
- Lint/format commands
- Repo-specific guardrails (don’t change lockfiles unless required; don’t
  rewrite migrations; etc.)

#### Example templates

##### `.github/copilot-instructions.md` (template)

```md
# Copilot Repository Instructions

## Project overview
- Full-stack web app: Python backend + JS/TS frontend.
- Backend exposes REST/GraphQL APIs consumed by frontend.

## Stack
- Backend: Python (e.g., Django/FastAPI), type hints required.
- Frontend: TypeScript, modern build tool (e.g., Vite/Next).

## Coding conventions
- Python: ruff/black, type hints, avoid complex metaprogramming.
- TS/JS: eslint + prettier, prefer explicit types at boundaries.
- Keep functions small; prefer composition over inheritance.

## Testing & quality bar
- Backend: pytest (unit + integration) must pass.
- Frontend: unit tests + lint must pass.
- Changes must include tests for new behavior.
```

##### `AGENTS.md` (repo root) (template)

```md
# Agent Instructions (Repo Root)

## Repo map
- backend/: Python service
- frontend/: TypeScript web app

## Setup commands
- Backend:
  - `python -m venv .venv && . .venv/bin/activate`
  - `pip install -r backend/requirements.txt`
- Frontend:
  - `cd frontend && npm ci`

## Dev commands
- Backend: `cd backend && uvicorn app.main:app --reload` (or equivalent)
- Frontend: `cd frontend && npm run dev`

## Test commands (must pass)
- Backend: `cd backend && pytest -q`
- Frontend: `cd frontend && npm test`
- Lint/format:
  - Backend: `cd backend && ruff check . && black --check .`
  - Frontend: `cd frontend && npm run lint && npm run format:check`

## Guardrails
- Do not commit secrets. Use `.env.example` and env vars.
- Prefer minimal diffs; don’t reformat unrelated files.
- Update tests when changing behavior.
```

### 5) Operational guidance (to avoid conflicts)

- **Single source of truth:** Put “principles” in `copilot-instructions.md`; put
  “commands/how-to-run” in `AGENTS.md`.
- **Avoid contradictions:** If both files mention formatting, ensure they agree.
- **Use nested `AGENTS.md` only when necessary:** Add `frontend/AGENTS.md` and
  `backend/AGENTS.md` only if their workflows differ materially.
- **Version control:** Keep these files reviewed and updated alongside tooling
  changes (linters, test runners, CI).

______________________________________________________________________

## 中文

### 1) `copilot-instructions.md` 是什么

**`copilot-instructions.md`** 是 GitHub 官方定义的 **仓库级 Copilot 指令文件**，通常放在：

- `.github/copilot-instructions.md`（仓库根目录下的 `.github/`）

它适合写 **高层、稳定的项目上下文与工程规范**（架构、技术栈、代码风格、测试要求、安全基线等），让 Copilot 在整个仓库里更一致地输出。

### 2) `AGENTS.md` 是什么

**`AGENTS.md`** 是一个更偏“智能体/Agent”的通用指令文件（agents 约定），可以放在：

- 仓库根目录（例如 `AGENTS.md`）
- 或子目录（例如 `frontend/AGENTS.md`、`backend/AGENTS.md`）

它最适合写 **可执行的操作指令**：如何安装依赖、如何启动、如何跑测试、如何验证变更、目录级别的差异化约束等。

### 3) 核心差异

- **归属与标准**

  - `copilot-instructions.md`：GitHub/Copilot 官方方案
  - `AGENTS.md`：开放约定，强调跨工具/跨 Agent 兼容

- **作用范围与放置方式**

  - `copilot-instructions.md`：通常是“全仓库一份”，放在 `.github/`
  - `AGENTS.md`：可嵌套；离文件越近（目录越具体）越可能生效

- **内容风格**

  - `copilot-instructions.md`：适合“原则、架构、规范”
  - `AGENTS.md`：适合“命令、流程、验证、注意事项清单”

- **工具支持**

  - VS Code Copilot 更侧重 `copilot-instructions.md`
  - Copilot CLI / Coding Agent 等 agent 模式通常会读取 `AGENTS.md`（新流程可能两者都读）
  - 多份指令并存时，务必避免冲突，否则行为不可控

### 4) 在 Python + JS/TS 全栈仓库中的最佳实践

#### 推荐目录结构

```
repo/
  .github/
    copilot-instructions.md
  AGENTS.md
  backend/
    AGENTS.md        # 可选：后端有不同规则/命令时再加
  frontend/
    AGENTS.md        # 可选：前端有不同规则/命令时再加
```

#### 内容分工（可落地的拆分方式）

**放在 `.github/copilot-instructions.md`**（全局、稳定）

- 项目定位与架构（单体/微服务/前后端分离）
- 技术栈（Python 后端、JS/TS 前端）
- 代码规范（格式化、lint、命名、模块边界）
- 安全基线（不写死密钥，使用 env）
- 质量门槛（必须通过测试/CI）

**放在 `AGENTS.md`**（可执行、面向 agent）

- 安装依赖命令
- 启动开发环境命令
- 测试命令
- Lint/format 命令
- 仓库级“护栏规则”（不要无意义改锁文件、不要改无关格式、迁移文件策略等）

#### 模板（同英文部分，直接复制即可使用）

- `.github/copilot-instructions.md`：写“原则与共识”
- `AGENTS.md`：写“命令与验收”

### 5) 避免冲突的操作建议

- **原则 vs 命令分离**：`copilot-instructions.md` 写原则，`AGENTS.md` 写命令。
- **保持一致**：两个文件都提到格式化/测试时，务必一致。
- **谨慎嵌套**：只有当前后端差异大时才加 `frontend/AGENTS.md` / `backend/AGENTS.md`。
- **随工具迭代更新**：lint/test/CI 改了，这两个文件要同步改。

______________________________________________________________________

## References

- GitHub Docs: Add repository instructions for GitHub Copilot
  https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions

- agents.md: The AGENTS.md format https://agents.md/
