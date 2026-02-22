# leafhill.io Development Skill

A universal AI coding skill for system development. It provides coding standards, project scaffolding, and development workflow guidance — all configurable per-project.

Works with any AI coding tool (Claude Code, Cursor, Gemini, Codex, etc.) and is guaranteed to work with Claude Code.

## How It Works

The skill is split into two layers:

### Leafhill Dev Specifications (Priority 1)

Explicit rules unique to this skill that always take precedence:

- **Configuration detection** — reads `leafhill.config.md` from your project root
- **Version tracking** — keeps `application_version.txt` in sync
- **File creation rules** — no glob patterns or brace expansion; explicit names only
- **Project boundaries** — stays in project folder, no auto-commit/push/install
- **Config system** — per-project overrides via `leafhill.config.md`

### Common Specifications (Priority 4)

General best practices that apply as a baseline:

- Naming conventions and code organization
- Documentation and error handling patterns
- Version control workflow (branching, commits, PRs)
- Testing approach
- AI behavior and communication style
- Language-specific notes (JS/TS, Python, Go, Rust)

### Priority Order

| Priority | Layer                          | Default | Description                                              |
|----------|--------------------------------|---------|----------------------------------------------------------|
| 1        | **Leafhill Dev Specifications** | on      | Explicit rules unique to this skill. Always win on conflicts. |
| 2        | **roam-code**                  | on      | Codebase navigation and context gathering.               |
| 3        | **superpowers skill**          | on      | Workflow orchestration (brainstorming, debugging, TDD, code review, etc.). |
| 4        | **Common Specifications**      | on      | General coding standards and best practices defined in this file. |

Higher-priority layers win on conflicts. roam-code and superpowers are **enabled by default** and the AI will request installation if they're missing. Both can be disabled per-project by setting `roam_code: off` or `superpowers: off` in `leafhill.config.md`.

## Installation

See [INSTALL.md](INSTALL.md) for complete setup instructions for all platforms.

**Quick start (Claude Code, project-level):**

```
mkdir .claude
mkdir .claude/skills
mkdir .claude/skills/leafhill_dev
cp dist/claude/leafhill_dev/SKILL.md .claude/skills/leafhill_dev/SKILL.md
```

## Configuration

Create a `leafhill.config.md` in your project root to override defaults:

```
cp dist/config/leafhill.config.template.md leafhill.config.md
```

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

Any key left blank or removed uses the default. See `examples/leafhill.config.example.md` for a complete example.

## File Structure

```
leafhill_dev/
├── SKILL.md                        # Main skill (source of truth)
├── README.md                       # This file
├── INSTALL.md                      # Installation guide for all platforms
├── leafhill.config.template.md     # Config template
├── dist/                           # Ready-to-use distribution copies
│   ├── claude/leafhill_dev/SKILL.md
│   ├── cursor/.cursorrules
│   ├── generic/leafhill_dev.md
│   └── config/leafhill.config.template.md
├── txt/
│   └── distribution-guide.txt      # Plain-text setup reference
└── examples/
    └── leafhill.config.example.md  # Example configuration
```

## Version

Current version: **1.1.0**

## License

Created by leafhill.io.
