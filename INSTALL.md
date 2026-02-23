# Installation Guide

This guide covers how to install the leafhill-dev skill for every supported platform, how to configure it per-project, and how to verify it's working.

This skill follows the [Agent Skills](https://agentskills.io) open standard, which means it works across Claude Code, Cursor, Gemini CLI, VS Code, Codex, GitHub Copilot, and other compatible tools.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Quick Install (install.sh)](#2-quick-install-installsh)
3. [Claude Code (Manual)](#3-claude-code-manual)
4. [Cursor (Manual)](#4-cursor-manual)
5. [Gemini, Codex, and Other Tools (Manual)](#5-gemini-codex-and-other-tools-manual)
6. [Per-Project Configuration](#6-per-project-configuration)
7. [Required Companion Tools](#7-required-companion-tools)
8. [Verifying the Installation](#8-verifying-the-installation)
9. [Updating](#9-updating)
10. [Uninstalling](#10-uninstalling)
11. [Troubleshooting](#11-troubleshooting)

---

## 1. Prerequisites

- Access to the `leafhill_dev/dist/` directory (this repository), or the `leafhill-dev.tar.gz` archive.
- A supported AI coding tool installed and working.
- A terminal to run commands.

No package manager, build step, or runtime is required. The skill consists entirely of instruction files that your AI tool reads.

---

## 2. Quick Install (install.sh)

The fastest way to install. The `install.sh` script is included in the `dist/` directory and bundled inside the `leafhill-dev.tar.gz` archive.

### From the tar archive

```
tar xzf leafhill-dev.tar.gz
cd /path/to/your/project
/path/to/extracted/install.sh claude
```

This installs the skill to `.claude/skills/leafhill-dev/` in your current project and copies `leafhill.config.md` if it doesn't already exist.

### From the dist/ directory

```
cd /path/to/your/project
/path/to/leafhill_dev/dist/install.sh claude
```

### Available targets

| Command | What it does |
|---------|-------------|
| `./install.sh claude` | Install to current project (`.claude/skills/leafhill-dev/`) + config template |
| `./install.sh claude-global` | Install globally (`~/.claude/skills/leafhill-dev/`) |
| `./install.sh cursor` | Copy `.cursorrules` to current project + config template |
| `./install.sh generic <dir>` | Copy `leafhill_dev.md` to the specified directory + config template |

Run `./install.sh` with no arguments to see usage help.

### Notes

- The `claude` and `cursor` targets must be run from your project root directory.
- The `cursor` target will prompt before overwriting an existing `.cursorrules` file.
- The `generic` target requires running from the `dist/` directory (not the extracted tar), since the tar only bundles the Claude Code skill file.

---

## 3. Claude Code (Manual)

Claude Code auto-discovers skills from a `skills/` directory. Each skill is a directory containing a `SKILL.md` file with YAML frontmatter. You can install at the project level (recommended) or globally.

### Skill File Format

The `SKILL.md` file must start with YAML frontmatter containing at minimum `name` and `description`:

```yaml
---
name: leafhill-dev
description: Universal AI coding skill for system development — coding standards, project scaffolding, and development workflows.
license: Apache-2.0
metadata:
  author: leafhill.io
  version: "1.1.1"
---
```

The `name` field must use lowercase alphanumeric characters and hyphens only (no underscores). The directory name must match the `name` field.

The distribution copy at `dist/claude/leafhill-dev/SKILL.md` already includes this frontmatter — no manual editing is needed.

### Project-Level Installation (Recommended)

This makes the skill available only within a specific project.

**Step 1:** Navigate to your project root.

```
cd /path/to/your/project
```

**Step 2:** Create the skills directory structure.

```
mkdir .claude
mkdir .claude/skills
mkdir .claude/skills/leafhill-dev
```

**Step 3:** Copy the skill file.

```
cp /path/to/leafhill_dev/dist/claude/leafhill-dev/SKILL.md .claude/skills/leafhill-dev/SKILL.md
```

**Step 4 (optional):** Add the config template to your project.

```
cp /path/to/leafhill_dev/dist/config/leafhill.config.template.md leafhill.config.md
```

Edit `leafhill.config.md` to match your project's needs.

### Global Installation

This makes the skill available across all projects for your user.

**Step 1:** Create the global skills directory.

```
mkdir -p ~/.claude/skills/leafhill-dev
```

**Step 2:** Copy the skill file.

```
cp /path/to/leafhill_dev/dist/claude/leafhill-dev/SKILL.md ~/.claude/skills/leafhill-dev/SKILL.md
```

### Advanced Claude Code Features

The SKILL.md frontmatter supports additional Claude Code-specific options:

| Field | Description | Default |
|-------|-------------|---------|
| `disable-model-invocation` | When `true`, only the user can invoke the skill (via `/leafhill-dev`). Claude won't auto-invoke it. Use for skills with side effects. | `false` |
| `user-invocable` | When `false`, only Claude can invoke the skill (background knowledge). The user cannot trigger it manually. | `true` |
| `context` | Set to `fork` to run the skill in an isolated subagent context. | (none) |
| `allowed-tools` | Space-delimited list of tools the skill can use without prompting (e.g., `Read Grep Glob`). | (none) |

Dynamic context injection is also supported — wrap shell commands in backticks prefixed with `!` to execute them before the skill loads:

```yaml
---
name: my-skill
description: Example with dynamic context
---

Current branch: !`git branch --show-current`
```

### Notes for Claude Code

- Project-level skills override global skills of the same name.
- Skills are discovered at session startup. Adding a new skill directory requires starting a new Claude Code session.
- The skill file must be named `SKILL.md` inside a directory matching the skill name.
- The directory name must match the `name` field in the YAML frontmatter and must use hyphens, not underscores.

---

## 4. Cursor (Manual)

Cursor reads a `.cursorrules` file from the project root.

**Step 1:** Navigate to your project root.

```
cd /path/to/your/project
```

**Step 2:** Copy the rules file.

```
cp /path/to/leafhill_dev/dist/cursor/.cursorrules .cursorrules
```

**Step 3 (optional):** Add the config template.

```
cp /path/to/leafhill_dev/dist/config/leafhill.config.template.md leafhill.config.md
```

**Step 4:** Reload Cursor (Cmd/Ctrl+Shift+P > "Reload Window") or restart it.

### Notes for Cursor

- Only one `.cursorrules` file is supported per project. If you already have one, merge the contents manually.
- The file must be in the project root directory.
- Cursor reads it on window load; changes require a reload.

---

## 5. Gemini, Codex, and Other Tools (Manual)

For any AI tool that accepts custom instructions as a markdown or text file:

**Step 1:** Copy the generic skill file.

```
cp /path/to/leafhill_dev/dist/generic/leafhill_dev.md /your/tool/instructions/directory/
```

**Step 2:** Configure your tool to load the file. Common approaches:

| Tool     | How to Load                                                        |
|----------|--------------------------------------------------------------------|
| Gemini   | Paste into system instructions or upload as context                |
| Codex    | Place in the instructions directory or reference in config         |
| Aider    | Add to `.aider.conf.yml` under `read:` or use `--read` flag       |
| Windsurf | Add to `.windsurfrules` or project instructions                    |
| Other    | Check your tool's docs for custom instruction / system prompt setup|

**Step 3 (optional):** Add the config template to your project root.

```
cp /path/to/leafhill_dev/dist/config/leafhill.config.template.md leafhill.config.md
```

### If Your Tool Only Accepts Plain Text

The generic file is standard markdown and works as plain text. You can also use the plain-text reference at `txt/distribution-guide.txt`.

### Agent Skills Compatibility

This skill follows the [Agent Skills](https://agentskills.io) open standard. Any tool that supports Agent Skills can load the skill directly from the `dist/claude/` directory using its standard discovery mechanism.

---

## 6. Per-Project Configuration

The skill checks for `leafhill.config.md` in the project root on every session. This file lets you override default behavior.

**Step 1:** Copy the template.

```
cp /path/to/leafhill_dev/dist/config/leafhill.config.template.md leafhill.config.md
```

**Step 2:** Edit the values.

```markdown
# Leafhill Project Configuration

## Project Info
name: my-app
description: A task management API

## Project Type
type: open-source

## Version Control
vcs: git
branching: simple
commit_style: conventional

## Languages
primary: typescript

## Testing
test_framework: vitest
```

**Step 3:** Save the file. The AI will read it at the start of each session.

### Available Settings

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

Any setting left blank or removed falls back to the default. See `examples/leafhill.config.example.md` for a complete example.

### Additional Rules

You can add free-form project-specific rules at the bottom of `leafhill.config.md` under the "Additional Rules" section. The AI will follow these in addition to the skill defaults.

---

## 7. Required Companion Tools

roam-code and superpowers are **enabled by default** and the skill expects them to be installed. If either is missing, the AI will remind you to install it on every session.

### roam-code (Priority 2)

Provides codebase navigation and context gathering. Install roam-code following its own documentation. The leafhill-dev skill will automatically use it at priority 2.

### superpowers skill (Priority 3)

Provides workflow orchestration — brainstorming, debugging, TDD, code review, and more. Install following superpowers documentation. The leafhill-dev skill will automatically use it at priority 3.

### Priority Order

| Priority | Layer                          | Default | Description                                              |
|----------|--------------------------------|---------|----------------------------------------------------------|
| 1        | **Leafhill Dev Specifications** | on      | Explicit rules unique to this skill. Always win on conflicts. |
| 2        | **roam-code**                  | on      | Codebase navigation and context gathering.               |
| 3        | **superpowers skill**          | on      | Workflow orchestration (brainstorming, debugging, TDD, code review, etc.). |
| 4        | **Common Specifications**      | on      | General coding standards and best practices defined in this file. |

### Disabling a Companion Tool

If you do not want to use roam-code or superpowers in a specific project, set them to `off` in your `leafhill.config.md`:

```markdown
## Companion Tools
roam_code: off
superpowers: off
```

When disabled, the skill skips that layer entirely and does not remind you to install it.

---

## 8. Verifying the Installation

After installing, verify the skill is active by asking your AI assistant:

> "What development skill are you using?"

It should respond mentioning leafhill-dev or leafhill.io development skill.

For Claude Code specifically, you can also invoke it directly:

> `/leafhill-dev`

If the skill is properly registered, Claude Code will load and follow its instructions.

You can also test specific behaviors:

- Ask it to create a directory — it should use explicit names, not glob patterns.
- Ask it to commit code — it should ask for your confirmation first.
- Check if it detects your `leafhill.config.md` — ask "What is my project configuration?"

---

## 9. Updating

When a new version of the skill is released:

**Step 1:** Replace the skill file in your installation location with the new version from `dist/`.

For Claude Code (project-level):
```
cp /path/to/leafhill_dev/dist/claude/leafhill-dev/SKILL.md .claude/skills/leafhill-dev/SKILL.md
```

For Cursor:
```
cp /path/to/leafhill_dev/dist/cursor/.cursorrules .cursorrules
```

For generic:
```
cp /path/to/leafhill_dev/dist/generic/leafhill_dev.md /your/tool/instructions/directory/
```

**Step 2:** Your `leafhill.config.md` does not need to change unless new config options are added (check the release notes).

**Step 3 (Claude Code):** Start a new session for the updated skill to be loaded.

---

## 10. Uninstalling

### Claude Code

Delete the skill directory:

```
rm -r .claude/skills/leafhill-dev
```

Or for global:

```
rm -r ~/.claude/skills/leafhill-dev
```

### Cursor

Delete the rules file:

```
rm .cursorrules
```

### Generic

Remove the `leafhill_dev.md` file from your tool's instructions directory.

### Config file

Optionally remove `leafhill.config.md` from your project root.

---

## 11. Troubleshooting

### The AI doesn't seem to follow the skill

- **Claude Code:** Verify the file exists at `.claude/skills/leafhill-dev/SKILL.md` (or the global equivalent). The filename must be exactly `SKILL.md`. Also verify the file starts with valid YAML frontmatter containing `name: leafhill-dev` and a `description` field.
- **Cursor:** Verify `.cursorrules` is in the project root. Try reloading the window.
- **Generic:** Confirm your tool is actually reading the instruction file. Check its configuration.

### Skill not appearing in Claude Code's skill list

- The directory name must match the `name` field in the YAML frontmatter exactly.
- The `name` field must use lowercase alphanumeric characters and hyphens only — no underscores, spaces, or uppercase.
- Skills are discovered at session startup. If you added the skill during a session, start a new one.

### Config file is ignored

- The file must be named exactly `leafhill.config.md` (lowercase).
- It must be in the project root directory, not a subdirectory.
- Values must follow the `key: value` format inside the correct section.

### Conflicts with existing rules

- If you have other instruction files (e.g., an existing `.cursorrules`), merge them manually. The leafhill-dev rules are designed to be non-conflicting with common conventions.
- The priority system (Leafhill Dev > roam-code > superpowers > Common) resolves conflicts within the skill itself.

### roam-code or superpowers reminder keeps appearing

- This is expected — both are enabled by default and the skill requires them. You have two options:
  1. **Install them** following their respective documentation.
  2. **Disable them** by adding `roam_code: off` and/or `superpowers: off` to your `leafhill.config.md`.

### Migrating from leafhill_dev (underscores) to leafhill-dev (hyphens)

If you installed an earlier version that used `leafhill_dev` as the directory name:

1. Remove the old directory: `rm -r .claude/skills/leafhill_dev`
2. Follow the installation steps above using the new `leafhill-dev` directory name.
