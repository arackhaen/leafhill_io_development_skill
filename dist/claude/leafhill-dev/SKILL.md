---
name: leafhill-dev
description: >-
  Universal AI coding skill for establishing and enforcing language-agnostic
  development standards. Use when defining code style rules, naming conventions,
  or documentation standards; scaffolding new project directory structures and
  boilerplate files; or documenting team workflow conventions such as branching
  strategies, commit message formats, and pull request processes. Do not use
  for framework-specific architecture patterns (React, Angular, Django, Rails),
  automated CI/CD pipeline authoring, cloud infrastructure provisioning
  (Terraform, Pulumi, CDK), or security vulnerability testing.
license: Apache-2.0
metadata:
  author: leafhill.io
  version: "1.3.0"
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
   - Stop here. Do not proceed with steps 2–6.

2. **Check if CLAUDE.md exists.** Look for `CLAUDE.md` in the project root.
   - If it exists, run `roam describe` and check whether the first non-empty line of its output already appears in CLAUDE.md.
     - If found, the description is already present. Skip to step 5.
   - If it does not exist, proceed to step 3.

3. **Prompt the user.**
   _"roam-code is installed. Would you like me to run `roam describe` and add the codebase description to your CLAUDE.md?"_
   - If the user declines, skip to step 5.

4. **Run and inject.**
   - Run `roam describe` and capture the output.
   - If CLAUDE.md exists, prepend the output to the beginning of the file, followed by a blank line, then the existing content.
   - If CLAUDE.md does not exist, create it with the roam describe output as the full content.

5. **Update config — codebase description.**
   - If `leafhill.config.md` exists and has a `## Project Status` section:
     - Run `roam describe` (reuse the output from step 4 if already captured).
     - Find the `codebase_description:` key in the `## Project Status` section.
     - Replace everything between `codebase_description:` and the next key or section heading with the roam describe output, each line prefixed with `> ` (blockquote format).
     - If the description is already present and matches, skip the write.

6. **Update config — health check.**
   - If `leafhill.config.md` exists and has a `## Project Status` section:
     - Run `roam health` and capture the output. If the command fails, skip this step silently.
     - Extract the health score (e.g., `99/100`) from the output.
     - Read the current project version from `application_version.txt`.
     - Set the `health_check:` value to: `SCORE -- DATOR -- vX.Y.Z` using the date-only DATOR variant (e.g., `99/100 -- 20260225 -- v1.2.3`).

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

Write all findings to the audit output files defined in Section 3.3. After writing audit output files, also update the `## Project Status` section in `leafhill.config.md` (if the file and section exist) — see Section 3.3 for details.

## 3.2 DATOR Variable

**DATOR** is the standard datetime format for all timestamps.

- **Format:** `%Y%m%d%H%M%S` (e.g., `20260224140244`)
- **Date-only variant:** `%Y%m%d` (e.g., `20260224`) — used only for audit headers.

Use DATOR for all file names, session IDs, and timestamps. Do not use other date formats.

## 3.3 Audit Output Files

All audit findings from Section 3.1 must be persisted to audit output files in the project root.

### Output Files

| File | Contents |
|------|----------|
| `INFORMATIONSECURITY_AUDIT.md` | OWASP Top 10+ findings and ISO 27001 findings |
| `QUALITY_AUDIT.md` | Quality Review findings |

### Entry Format

Each audit run produces an entry with:

1. **Header:** `## Audit — vX.Y.Z — DATOR` (date-only variant)
2. **Findings:** Numbered findings grouped by checklist, each with severity
3. **Summary table:** Counts per severity level (Critical, High, Medium, Low, Info)
4. **Verdict:** `PASS` if no Critical or High findings remain, otherwise `FAIL`

### Append-to-Top Rule

- **New audits are prepended** above existing content. Old audits are never removed or overwritten.
- A horizontal rule (`---`) separates entries.
- **If the file exists:** Read it, prepend the new audit entry, write back.
- **If the file does not exist:** Create it with the new audit entry as the initial content.

### Config Status Update

After writing to the audit output files, also update `leafhill.config.md` if it exists and contains a `## Project Status` section:

| Config Key | Value Format | Source |
|------------|-------------|--------|
| `quality_audit` | `VERDICT vX.Y.Z -- DATOR` | Verdict from `QUALITY_AUDIT.md` entry |
| `infosec_audit` | `VERDICT vX.Y.Z -- DATOR` | Verdict from `INFORMATIONSECURITY_AUDIT.md` entry |

Use the date-only DATOR variant. If the config file does not exist or lacks the `## Project Status` section, skip this step silently.

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

### Auto-Populated Keys (Project Status)

The `## Project Status` section in the config contains keys that are automatically written by the skill. Users should not edit these manually.

| Key                    | Populated By                    | Format                                       |
|------------------------|---------------------------------|----------------------------------------------|
| `codebase_description` | Section 2 (session startup)     | Blockquote (`> ` prefixed lines)             |
| `health_check`         | Section 2 (session startup)     | `SCORE -- DATOR -- vX.Y.Z`                   |
| `quality_audit`        | Section 3.1/3.3 (release audit) | `VERDICT vX.Y.Z -- DATOR`                    |
| `infosec_audit`        | Section 3.1/3.3 (release audit) | `VERDICT vX.Y.Z -- DATOR`                    |

## 7. Session Exit Protocol

**Before ending a Claude Code session, always export and save work to file.**

This is mandatory. Before the session ends:

1. **Export a session summary** to a timestamped file in the project root: `DATOR-session-description.txt`
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
   - `session_id`: a stable identifier (use the format `project-name/DATOR`)
   - `role`: `assistant`
   - `entry_type`: `summary`
   - `project`: the project name
   - `content`: the same summary content written to the timestamped file
2. **Update task statuses.** Before exiting, update any tasks that changed during the session (mark completed work as `completed`, note newly blocked items as `blocked`).
3. **The timestamped file export (Section 7) remains mandatory.** Persistent memory logging is an addition, not a replacement. Both happen on session exit.

---

# Part II — Common Specifications

General coding standards and best practices. These apply unless overridden by higher-priority layers.

**Read `references/common-specs.md`** when any of the following apply:

1. Starting a new project and need to establish coding conventions.
2. The user asks about naming, code organization, or project structure.
3. Making decisions about version control, branching, or commit conventions.
4. Unclear on language-specific conventions (JS/TS, Python, Go, Rust).

Do not load this file for tasks where the codebase already has established conventions — follow existing patterns instead.
