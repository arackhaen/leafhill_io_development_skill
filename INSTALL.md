# Installation Guide

This guide covers how to install the leafhill_dev skill for every supported platform, how to configure it per-project, and how to verify it's working.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Claude Code](#2-claude-code)
3. [Cursor](#3-cursor)
4. [Gemini, Codex, and Other Tools](#4-gemini-codex-and-other-tools)
5. [Per-Project Configuration](#5-per-project-configuration)
6. [Required Companion Tools](#6-required-companion-tools)
7. [Verifying the Installation](#7-verifying-the-installation)
8. [Updating](#8-updating)
9. [Uninstalling](#9-uninstalling)
10. [Troubleshooting](#10-troubleshooting)

---

## 1. Prerequisites

- Access to the `leafhill_dev/dist/` directory (this repository).
- A supported AI coding tool installed and working.
- A terminal to run copy commands.

No package manager, build step, or runtime is required. The skill consists entirely of instruction files that your AI tool reads.

---

## 2. Claude Code

Claude Code loads skills from a `skills/` directory. You can install at the project level (recommended) or globally.

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
mkdir .claude/skills/leafhill_dev
```

**Step 3:** Copy the skill file.

```
cp /path/to/leafhill_dev/dist/claude/leafhill_dev/SKILL.md .claude/skills/leafhill_dev/SKILL.md
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
mkdir -p ~/.claude/skills/leafhill_dev
```

**Step 2:** Copy the skill file.

```
cp /path/to/leafhill_dev/dist/claude/leafhill_dev/SKILL.md ~/.claude/skills/leafhill_dev/SKILL.md
```

### Notes for Claude Code

- Project-level skills override global skills of the same name.
- Claude Code automatically detects new skill files — no restart required.
- The skill file must be named `SKILL.md` inside a directory matching the skill alias.

---

## 3. Cursor

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

## 4. Gemini, Codex, and Other Tools

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

---

## 5. Per-Project Configuration

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

## 6. Required Companion Tools

roam-code and superpowers are **enabled by default** and the skill expects them to be installed. If either is missing, the AI will remind you to install it on every session.

### roam-code (Priority 2)

Provides codebase navigation and context gathering. Install roam-code following its own documentation. The leafhill_dev skill will automatically use it at priority 2.

### superpowers skill (Priority 3)

Provides workflow orchestration — brainstorming, debugging, TDD, code review, and more. Install following superpowers documentation. The leafhill_dev skill will automatically use it at priority 3.

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

## 7. Verifying the Installation

After installing, verify the skill is active by asking your AI assistant:

> "What development skill are you using?"

It should respond mentioning leafhill_dev or leafhill.io development skill.

You can also test specific behaviors:

- Ask it to create a directory — it should use explicit names, not glob patterns.
- Ask it to commit code — it should ask for your confirmation first.
- Check if it detects your `leafhill.config.md` — ask "What is my project configuration?"

---

## 8. Updating

When a new version of the skill is released:

**Step 1:** Replace the skill file in your installation location with the new version from `dist/`.

For Claude Code (project-level):
```
cp /path/to/leafhill_dev/dist/claude/leafhill_dev/SKILL.md .claude/skills/leafhill_dev/SKILL.md
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

---

## 9. Uninstalling

### Claude Code

Delete the skill directory:

```
rm -r .claude/skills/leafhill_dev
```

Or for global:

```
rm -r ~/.claude/skills/leafhill_dev
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

## 10. Troubleshooting

### The AI doesn't seem to follow the skill

- **Claude Code:** Verify the file exists at `.claude/skills/leafhill_dev/SKILL.md` (or the global equivalent). The filename must be exactly `SKILL.md`.
- **Cursor:** Verify `.cursorrules` is in the project root. Try reloading the window.
- **Generic:** Confirm your tool is actually reading the instruction file. Check its configuration.

### Config file is ignored

- The file must be named exactly `leafhill.config.md` (lowercase).
- It must be in the project root directory, not a subdirectory.
- Values must follow the `key: value` format inside the correct section.

### Conflicts with existing rules

- If you have other instruction files (e.g., an existing `.cursorrules`), merge them manually. The leafhill_dev rules are designed to be non-conflicting with common conventions.
- The priority system (Leafhill Dev > roam-code > superpowers > Common) resolves conflicts within the skill itself.

### roam-code or superpowers reminder keeps appearing

- This is expected — both are enabled by default and the skill requires them. You have two options:
  1. **Install them** following their respective documentation.
  2. **Disable them** by adding `roam_code: off` and/or `superpowers: off` to your `leafhill.config.md`.
