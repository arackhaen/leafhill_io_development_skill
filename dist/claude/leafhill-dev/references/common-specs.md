# Common Specifications

General coding standards and best practices. These apply unless overridden by higher-priority layers (Leafhill Dev Specifications, roam-code, persistent-memory, superpowers).

---

## Coding Standards

### Naming Conventions

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

### Code Organization

1. Assign one concern per file with a single, clear responsibility.
2. Group by feature, not by type. Prefer `features/auth/` over `controllers/`, `models/`, `views/` when the project grows beyond a handful of files.
3. Keep files under ~300 lines. Split larger files by responsibility.
4. Place imports at the top: standard library first, then third-party, then local — separated by blank lines.

### Documentation

1. Add comments only when the _why_ is not obvious from the code. Avoid restating the _what_.
2. Add docstrings to public API functions, classes, and modules.
3. Remove commented-out code — use version control instead.
4. Include a `README.md` in every project explaining what it does and how to run it.

### Error Handling

1. Validate input at system boundaries (user input, API calls, file I/O). Trust internal code.
2. Fail early and clearly. Throw or raise on invalid state rather than silently continuing.
3. Use typed errors when the language supports them (custom error classes, typed Result types).
4. Log actionable information: what happened, what was expected, and enough context to debug.

---

## Project Structure

### Standard Layout

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

### Required Files

Every project must have at minimum:
- `README.md` — what the project does and how to run it
- `.gitignore` — appropriate for the project's language/framework (when using git)

### Config Patterns

1. Store secrets in environment variables. Never commit secrets to version control.
2. Provide a `.env.example` to document required environment variables (without actual values).
3. Keep configuration separate from code.

---

## Development Workflow

### Version Control

**Default:** git

When git is configured:
1. Initialize a repository if one does not exist and the user asks to set up the project.
2. Use a `.gitignore` appropriate for the project's stack.
3. Commit early, commit often. Each commit represents one logical change.

When VCS is set to `none`: skip all git-related actions.

### Branching Strategy

**Default:** simple (main + feature branches)

| Strategy      | Description                                                   |
|---------------|---------------------------------------------------------------|
| `simple`      | `main` branch + short-lived feature branches                  |
| `trunk-based` | All work on `main`, use feature flags for incomplete work     |
| `gitflow`     | `main`, `develop`, `feature/*`, `release/*`, `hotfix/*`       |

### Commit Conventions

**Default:** conventional commits

Format: `type(scope): description`

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, `ci`, `perf`

Examples:
- `feat(auth): add login with email`
- `fix(api): handle null response from user endpoint`
- `docs: update installation instructions`

When commit style is `free-form`: no enforced format, but keep commits descriptive.

### Code Review

1. Keep pull requests small and focused (under 400 lines changed when possible).
2. Write descriptive PR titles that describe the change, not the ticket number.
3. Review the diff before requesting review from others.

### Testing

1. Write tests for business logic. Not every line needs a test, but core logic does.
2. Test behavior, not implementation. Verify what the code does, not how it does it.
3. Name tests descriptively: `test_user_cannot_login_with_expired_token` over `test_login_3`.
4. Keep tests fast. Slow tests do not get run.
5. Mirror source structure in test file locations (e.g., `src/auth/login.ts` → `tests/auth/login.test.ts`).

---

## AI Behavior (Common)

### General Behavior

1. **Read before writing.** Read existing code before modifying it.
2. **Stay in scope.** Only modify files relevant to the current task. Do not refactor unrelated code.
3. **Make minimal changes.** Apply the smallest change that solves the problem. Do not add features, abstractions, or improvements that were not requested.
4. **Respect existing patterns.** Follow the conventions already established in the codebase, even if they differ from these defaults.
5. **Confirm before destructive actions.** Deleting files, dropping tables, force-pushing — confirm with the user first.

### Communication Style

1. Keep responses concise. Short, direct answers.
2. Prefer code examples over lengthy explanations.
3. Surface trade-offs when multiple valid approaches exist, with a recommendation.
4. State uncertainty explicitly rather than guessing.

---

## Language-Specific Notes

### JavaScript / TypeScript
- Prefer `const` over `let`. Never use `var`.
- Prefer strict equality (`===`).
- Prefer async/await over raw promises.
- Do not mix JS and TS in the same project without reason.

### Python
- Follow PEP 8.
- Add type hints to function signatures.
- Prefer f-strings over `.format()` or `%`.
- Use virtual environments.

### Go
- Follow standard Go project layout conventions.
- Run `gofmt` / `goimports`.
- Handle errors explicitly — never assign error returns to blank `_`.

### Rust
- Enable `clippy` lints.
- Prefer `Result` over `unwrap()` in library code.
- Run `cargo fmt`.
