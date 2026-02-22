# leafhill.io Development Skill

**Alias:** `leafhill_dev`
**Version:** 1.1.0
**Author:** leafhill.io
**Description:** Universal AI coding skill for system development — coding standards, project scaffolding, and development workflows. Works with any AI coding tool; guaranteed to work with Claude Code.

---

## 0. Prioritization

When this skill is active, follow this priority order:

| Priority | Layer                          | Default | Description                                              |
|----------|--------------------------------|---------|----------------------------------------------------------|
| 1        | **Leafhill Dev Specifications** | on      | Explicit rules unique to this skill. Always win on conflicts. |
| 2        | **roam-code**                  | on      | Codebase navigation and context gathering.               |
| 3        | **superpowers skill**          | on      | Workflow orchestration (brainstorming, debugging, TDD, code review, etc.). |
| 4        | **Common Specifications**      | on      | General coding standards and best practices defined in this file. |

When instructions conflict between layers, the higher-priority layer wins.

**roam-code and superpowers are enabled by default.** They are expected to be installed and used. If either is not installed, always remind the user:

- _"roam-code is required by leafhill_dev but is not currently installed. Please install it for codebase navigation."_
- _"superpowers skill is required by leafhill_dev but is not currently installed. Please install it for workflow orchestration."_

Both can be disabled per-project via `leafhill.config.md` by setting `roam_code: off` or `superpowers: off`. When disabled, skip the layer entirely and do not remind the user.

---

# Part I — Leafhill Dev Specifications

These are explicit rules unique to this skill. They take the highest priority.

---

## 1. Configuration Detection

Before starting any work, check the project root for a file named `leafhill.config.md`.

- **If found:** Read it and apply its settings. The config overrides the defaults in Common Specifications.
- **If not found:** Use the defaults defined in this skill file.

The config file uses simple `key: value` pairs inside markdown sections. See the template for the full schema.

## 2. Version Tracking

- When the system version is updated, always update `application_version.txt` with the new version number.
- This file must exist at the project root and contain only the version string.

## 3. File and Directory Creation

- **Never use glob patterns or brace expansion** (e.g., `{a,b,c}`, `**/*.ts`) when creating files or directories.
- **Use direct, explicit names** for every file and folder creation operation. Create each file and directory individually by its full name.

## 4. Project Boundaries

- **Stay in the project folder.** Do not access files outside the project root without explicit permission from the user.
- **Do not commit automatically.** Only create commits when the user asks.
- **Do not push automatically.** Only push to remote when the user explicitly requests it.
- **Do not install packages without asking.** Confirm before adding new dependencies.

## 5. Leafhill Config System

Projects using this skill can place a `leafhill.config.md` in the project root to override Common Specification defaults. The config supports these keys:

| Key              | Options                                              | Default        |
|------------------|------------------------------------------------------|----------------|
| `type`           | `personal`, `open-source`, `company`                 | `personal`     |
| `vcs`            | `git`, `none`                                        | `git`          |
| `branching`      | `simple`, `trunk-based`, `gitflow`                   | `simple`       |
| `commit_style`   | `conventional`, `free-form`                          | `conventional` |
| `primary`        | `python`, `javascript`, `typescript`, `go`, `rust`, `other` | auto-detect |
| `test_framework` | any string (e.g., `pytest`, `jest`, `vitest`)        | auto-detect    |
| `roam_code`      | `on`, `off`                                          | `on`           |
| `superpowers`    | `on`, `off`                                          | `on`           |

Config values override the corresponding Common Specification defaults. Any key left blank or removed falls back to the default.

## 6. Session Exit Protocol

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
