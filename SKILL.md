---
name: leafhill-dev
description: Universal AI coding skill for system development — coding standards, project scaffolding, and development workflows. Works with any AI coding tool.
license: Apache-2.0
metadata:
  author: leafhill.io
  version: "1.2.0"
---

# leafhill.io Development Skill

## 0. Prioritization

When this skill is active, follow this priority order:

| Priority | Layer                          | Default | Description                                              |
|----------|--------------------------------|---------|----------------------------------------------------------|
| 1        | **Leafhill Dev Specifications** | on      | Explicit rules unique to this skill. Always win on conflicts. |
| 2.1      | **roam-code**                  | on      | Codebase navigation and context gathering.               |
| 2.2      | **persistent-memory**          | on      | Cross-session task tracking and project memory.          |
| 2.3      | **superpowers skill**          | on      | Workflow orchestration (brainstorming, debugging, TDD, code review, etc.). |
| 3        | **Common Specifications**      | on      | General coding standards and best practices defined in this file. |

When instructions conflict between layers, the higher-priority layer wins.

**roam-code, persistent-memory, and superpowers are enabled by default.** They are expected to be installed and used. If any is not installed, always remind the user:

- _"roam-code is required by leafhill-dev but is not currently installed. Please install it for codebase navigation."_
- _"persistent-memory (leafhill-persistent-memory MCP server) is required by leafhill-dev but is not currently available. Please install it for cross-session task tracking and project memory."_
- _"superpowers skill is required by leafhill-dev but is not currently installed. Please install it for workflow orchestration."_

All three can be disabled per-project via `leafhill.config.md` by setting `roam_code: off`, `persistent_memory: off`, or `superpowers: off`. When disabled, skip the layer entirely and do not remind the user.

---

# Part I — Leafhill Dev Specifications

These are explicit rules unique to this skill. They take the highest priority.

---

## 1. Configuration Detection

Before starting any work, check the project root for a file named `leafhill.config.md`.

- **If found:** Read it and apply its settings. The config overrides the defaults in Common Specifications.
- **If not found:** Use the defaults defined in this skill file.

The config file uses simple `key: value` pairs inside markdown sections. See the template for the full schema.

## 2. roam-code Initialization

When `roam_code` is enabled (default: `on`), perform this check at the start of every session:

1. **Verify roam-code is installed.** Run `roam --version`.
   - If the command is not found, remind the user:
     _"roam-code is required by leafhill-dev but is not currently installed. Please install it for codebase navigation."_
   - Stop here. Do not proceed with steps 2–4.

2. **Check if CLAUDE.md exists.** Look for `CLAUDE.md` in the project root.
   - If it exists, run `roam describe` and check whether the first non-empty line of its output already appears in CLAUDE.md.
     - If found, the description is already present. Stop here.
   - If it does not exist, proceed to step 3.

3. **Prompt the user.**
   _"roam-code is installed. Would you like me to run `roam describe` and add the codebase description to your CLAUDE.md?"_
   - If the user declines, stop here.

4. **Run and inject.**
   - Run `roam describe` and capture the output.
   - If CLAUDE.md exists, prepend the output to the beginning of the file, followed by a blank line, then the existing content.
   - If CLAUDE.md does not exist, create it with the roam describe output as the full content.

## 3. Version Tracking

- When the system version is updated, always update `application_version.txt` with the new version number.
- This file must exist at the project root and contain only the version string.

## 3.1 Release Audit Protocol

**On every minor or major version bump, perform a mandatory release audit before distribution.**

Act as both a Senior Quality Officer and a Chief Information Security Officer (CISO). Review the entire skill (all distribution copies) against the following checklists. Output numbered findings with severity: Critical, High, Medium, Low, or Info. **Critical and High findings must be resolved before release.**

### OWASP Top 10+ (Adapted for AI Skill Instructions)

1. **Injection risks** — Do any instructions allow unsanitized input to flow into shell commands, file paths, or tool parameters?
2. **Access control** — Do project boundary rules prevent unauthorized file access, commits, pushes, and package installs?
3. **Data exposure** — Could any instruction cause secrets, credentials, or sensitive data to be logged, committed, or displayed?
4. **Security misconfiguration** — Are defaults secure? Are there insecure fallbacks?
5. **Dependencies** — Do companion tool integrations (roam-code, persistent-memory, superpowers) introduce supply chain risk?
6. **Logging** — Do session export or error handling instructions risk leaking sensitive information?
7. **Prompt injection resistance** — Could a malicious `leafhill.config.md` or project file override safety-critical instructions?
8. **Supply chain risks** — Is the distribution pipeline (build script, tar archive) tamper-resistant?
9. **Excessive permissions** — Do any instructions grant broader access than necessary?
10. **Insecure defaults** — Are all default settings the most restrictive reasonable option?

### ISO 27001 Checks

1. **Information classification** — Are instructions for handling different data types (code, config, secrets) clearly defined?
2. **Access control policy** — Do project boundary and permission rules align with least-privilege principles?
3. **Change management** — Is the version tracking and build process controlled and auditable?
4. **Incident response** — Do error handling and session export instructions support incident investigation?
5. **Asset management** — Are all distribution files tracked and accounted for in the build process?

### Quality Review

1. **Consistency** — Are all distribution copies (Claude, Cursor, generic) aligned in content and version?
2. **Completeness** — Are all documented features actually implemented in every distribution format?
3. **Clarity** — Are instructions unambiguous and actionable for AI agents?
4. **Version alignment** — Do all 8 version-bearing files show the same version string?

## 4. File and Directory Creation

- **Never use glob patterns or brace expansion** (e.g., `{a,b,c}`, `**/*.ts`) when creating files or directories.
- **Use direct, explicit names** for every file and folder creation operation. Create each file and directory individually by its full name.

## 5. Project Boundaries

- **Stay in the project folder.** Do not access files outside the project root without explicit permission from the user.
- **Do not commit automatically.** Only create commits when the user asks.
- **Do not push automatically.** Only push to remote when the user explicitly requests it.
- **Do not install packages without asking.** Confirm before adding new dependencies.

## 6. Leafhill Config System

Projects using this skill can place a `leafhill.config.md` in the project root to override Common Specification defaults. The config supports these keys:

| Key                 | Options                                              | Default        |
|---------------------|------------------------------------------------------|----------------|
| `type`              | `personal`, `open-source`, `company`                 | `personal`     |
| `vcs`               | `git`, `none`                                        | `git`          |
| `branching`         | `simple`, `trunk-based`, `gitflow`                   | `simple`       |
| `commit_style`      | `conventional`, `free-form`                          | `conventional` |
| `primary`           | `python`, `javascript`, `typescript`, `go`, `rust`, `other` | auto-detect |
| `test_framework`    | any string (e.g., `pytest`, `jest`, `vitest`)        | auto-detect    |
| `roam_code`         | `on`, `off`                                          | `on`           |
| `superpowers`       | `on`, `off`                                          | `on`           |
| `persistent_memory` | `on`, `off`                                          | `on`           |

Config values override the corresponding Common Specification defaults. Any key left blank or removed falls back to the default.

## 7. Session Exit Protocol

**Before ending a Claude Code session, always export and save work to file.**

This is mandatory. Before the session ends:

1. **Export a session summary** to a timestamped file in the project root: `YYYY-MM-DD-HHMMSS-session-description.txt`
2. The export must include:
   - What was worked on (tasks completed, files changed)
   - Current state (what's done, what's in progress, what's pending)
   - Any decisions made or context the next session needs
   - Next steps or open items
3. **Never exit without saving.** If the user signals they are done or the session is ending, proactively create the export file before wrapping up.
4. **Remind the user** if they attempt to end the session without an export: _"Before we wrap up, let me save a session summary file."_
5. **Persistent memory logging.** When `persistent_memory` is enabled, also log the summary to persistent memory and update task statuses. See Section 8.4 for details.

## 8. Persistent Memory

When `persistent_memory` is enabled (default: `on`), use the leafhill-persistent-memory MCP server for task tracking and cross-session continuity.

### 8.1 Availability Check

At the start of every session when `persistent_memory` is `on`:

1. **Test MCP availability.** Attempt to call `list_tasks` with `project` set to the project name from `leafhill.config.md` (or the project root directory name if no config exists).
   - If the call fails or the tool is not available, inform the user:
     _"persistent-memory (leafhill-persistent-memory MCP server) is required by leafhill-dev but is not currently available. Please install it for cross-session task tracking and project memory."_
   - Continue the session normally without persistent memory features.

2. **Load project context.** If the MCP is available:
   - Call `list_tasks` filtered by the project name. Display a brief summary of open tasks (pending, in_progress, blocked) if any exist.
   - Call `search_memories` with the project name to surface any relevant stored context.
   - Do not display completed or deleted tasks unless the user asks.

### 8.2 Task Lifecycle

Use persistent tasks to track work across sessions. Follow these rules:

- **Create a task** when the user starts a unit of work that may span multiple interactions or sessions (e.g., "implement authentication," "fix the deployment pipeline," "refactor the data layer"). Do not create tasks for trivial one-off requests (e.g., "rename this variable," "what does this function do?").
- **Set the `project` field** to the project name from `leafhill.config.md`, or the project root directory name if no config exists. This is mandatory on every task.
- **Update status** as work progresses:
  - `pending` — task is created but work has not started
  - `in_progress` — actively working on it
  - `completed` — work is finished and verified
  - `blocked` — cannot proceed; add a description of what is blocking it
- **Use `task_type`** to indicate responsibility:
  - `claude` — the AI will complete this task
  - `human` — requires user action (e.g., "review PR," "provision database")
  - `hybrid` — requires both AI and user effort
- **Use subtasks** (`parent_id`) to break large tasks into steps when the scope is clear. Do not over-decompose; 2–5 subtasks per parent is typical.
- **Use dependencies** (`add_task_dep`) when one task genuinely blocks another. Do not add dependencies speculatively.

### 8.3 Memory and Context

- **Store a memory** (`store_memory`) when a significant decision, pattern, or project fact emerges that future sessions should know. Use the project name as a tag. Use descriptive categories: `decisions`, `patterns`, `facts`, `insights`.
- **Do not store secrets, credentials, or sensitive data** in memories. This includes API keys, tokens, passwords, and connection strings.
- **Link related entities** (`create_link`) when a task is discussed in a conversation or relates to a stored memory. Use meaningful relation labels: `discusses`, `resolves`, `caused_by`, `relates_to`, `requires_input`.

### 8.4 Session Integration

When persistent memory is enabled, the Session Exit Protocol (Section 7) gains additional steps:

1. **Log the session summary** to persistent memory using `log_conversation` with:
   - `session_id`: a stable identifier (use the format `project-name/YYYY-MM-DD-HHMMSS`)
   - `role`: `assistant`
   - `entry_type`: `summary`
   - `project`: the project name
   - `content`: the same summary content written to the timestamped file
2. **Update task statuses.** Before exiting, update any tasks that changed during the session (mark completed work as `completed`, note newly blocked items as `blocked`).
3. **The timestamped file export (Section 7) remains mandatory.** Persistent memory logging is an addition, not a replacement. Both happen on session exit.

---

# Part II — Common Specifications

General coding standards and best practices. These apply unless overridden by Leafhill Dev Specifications, roam-code, or superpowers.

---

## 6. Coding Standards

### 6.1 Naming Conventions

| Element       | Style            | Examples                          |
|---------------|------------------|-----------------------------------|
| Files         | kebab-case       | `user-profile.ts`, `api-client.py`|
| Variables     | camelCase (JS/TS), snake_case (Python/Go/Rust) | `userName`, `user_name` |
| Functions     | camelCase (JS/TS), snake_case (Python/Go/Rust) | `getUser()`, `get_user()` |
| Classes       | PascalCase       | `UserProfile`, `HttpClient`       |
| Constants     | UPPER_SNAKE_CASE | `MAX_RETRIES`, `API_BASE_URL`     |
| CSS classes   | kebab-case       | `nav-header`, `btn-primary`       |
| Env variables | UPPER_SNAKE_CASE | `DATABASE_URL`, `NODE_ENV`        |

When the config specifies a primary language, follow that language's conventions throughout the project.

### 6.2 Code Organization

- **One concern per file.** A file should have a single, clear responsibility.
- **Group by feature, not by type.** Prefer `features/auth/` over `controllers/`, `models/`, `views/` when the project grows beyond a handful of files.
- **Keep files short.** If a file exceeds ~300 lines, consider splitting it.
- **Imports at the top.** Standard library first, then third-party, then local — separated by blank lines.

### 6.3 Documentation

- **Do not over-comment.** Code should be self-explanatory. Only add comments when the _why_ isn't obvious from the code.
- **Public APIs need docstrings.** Functions, classes, and modules that are part of the public interface should have brief documentation.
- **No commented-out code.** Use version control instead.
- **README is mandatory.** Every project must have a `README.md` explaining what it does and how to run it.

### 6.4 Error Handling

- **Handle errors at the boundary.** Validate input at system edges (user input, API calls, file I/O). Trust internal code.
- **Fail early and clearly.** Throw/raise on invalid state rather than silently continuing.
- **Use typed errors** when the language supports them (custom error classes, typed Result types).
- **Log actionable information.** Error logs should include what happened, what was expected, and enough context to debug.

---

## 7. Project Structure

### 7.1 Standard Folder Conventions

```
project-root/
├── src/                  # Source code (or language-specific equivalent)
├── tests/                # Test files
├── docs/                 # Documentation (if needed beyond README)
├── scripts/              # Build, deploy, or utility scripts
├── config/               # Configuration files
├── .gitignore            # Git ignore rules
├── README.md             # Project documentation
├── LICENSE               # License file (if applicable)
└── leafhill.config.md    # Leafhill config (optional)
```

Adapt folder names to language conventions when appropriate (e.g., `lib/` for Ruby, `pkg/` for Go, `app/` for Rails/Laravel).

### 7.2 Required Files

Every project should have at minimum:
- `README.md` — what the project does and how to run it
- `.gitignore` — appropriate for the project's language/framework (when using git)

### 7.3 Config File Patterns

- Use environment variables for secrets. Never commit secrets to version control.
- Use `.env.example` to document required environment variables (without actual values).
- Keep configuration separate from code.

---

## 8. Development Workflow

### 8.1 Version Control

**Default:** git

When git is configured:
- Initialize a repository if one doesn't exist and the user asks to set up the project.
- Use `.gitignore` appropriate for the project's stack.
- Commit early, commit often. Each commit should represent one logical change.

**When VCS is set to `none`:** Skip all git-related actions.

### 8.2 Branching Strategy

**Default:** simple (main + feature branches)

| Strategy      | Description                                                   |
|---------------|---------------------------------------------------------------|
| `simple`      | `main` branch + short-lived feature branches                  |
| `trunk-based` | All work on `main`, use feature flags for incomplete work     |
| `gitflow`     | `main`, `develop`, `feature/*`, `release/*`, `hotfix/*`       |

### 8.3 Commit Conventions

**Default:** conventional commits

Format: `type(scope): description`

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, `ci`, `perf`

Examples:
- `feat(auth): add login with email`
- `fix(api): handle null response from user endpoint`
- `docs: update installation instructions`

**When commit style is `free-form`:** No enforced format, but commits should still be descriptive.

### 8.4 Code Review Expectations

- Keep pull requests small and focused (under 400 lines changed when possible).
- PR titles should describe the change, not the ticket number.
- Review your own diff before requesting review.

### 8.5 Testing Approach

- **Write tests for business logic.** Not every line needs a test, but core logic does.
- **Test behavior, not implementation.** Tests should verify what the code does, not how it does it.
- **Name tests descriptively.** `test_user_cannot_login_with_expired_token` over `test_login_3`.
- **Keep tests fast.** Slow tests don't get run.
- Test file location mirrors source structure (e.g., `src/auth/login.ts` → `tests/auth/login.test.ts`).

---

## 9. AI Behavior (Common)

### 9.1 General Behavior

- **Read before writing.** Always read existing code before modifying it.
- **Stay in scope.** Only modify files relevant to the current task. Do not refactor unrelated code.
- **Minimal changes.** Make the smallest change that solves the problem. Do not add features, abstractions, or "improvements" that weren't requested.
- **Respect existing patterns.** Follow the conventions already established in the codebase, even if they differ from these defaults.
- **Ask before destructive actions.** Deleting files, dropping tables, force-pushing — always confirm first.

### 9.2 Communication Style

- **Be concise.** Short, direct responses. No filler.
- **Show, don't tell.** Prefer code examples over lengthy explanations.
- **Surface trade-offs.** When there are multiple valid approaches, briefly state the options and your recommendation.
- **Admit uncertainty.** If you're not sure about something, say so rather than guessing.

---

## 10. Language-Specific Notes

### JavaScript / TypeScript
- Prefer `const` over `let`. Never use `var`.
- Use strict equality (`===`).
- Prefer async/await over raw promises.
- Use TypeScript when the project uses it — don't mix JS and TS without reason.

### Python
- Follow PEP 8.
- Use type hints for function signatures.
- Prefer f-strings over `.format()` or `%`.
- Use virtual environments.

### Go
- Follow standard Go project layout conventions.
- Use `gofmt` / `goimports`.
- Handle errors explicitly — no blank `_` for error returns.

### Rust
- Use `clippy` lints.
- Prefer `Result` over `unwrap()` in library code.
- Use `cargo fmt`.
