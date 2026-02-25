## Audit — v1.3.0 — 20260225

### OWASP Top 10+ (Adapted for AI Skill Instructions)

1. **Injection risks** — Severity: Low
   All shell commands (`roam --version`, `roam describe`, `roam health`) remain hardcoded with no user-supplied arguments. Config values are simple key-value pairs never passed to shell interpreters. New in v1.3.0: Section 2 steps 5-6 write `roam describe` and `roam health` output into `leafhill.config.md`. The roam output is external tool output being written into a markdown file read on every session start. Content is blockquote-formatted (`> ` prefix), limiting interpretive risk. Section 3.3 writes audit verdicts as structured `VERDICT vX.Y.Z -- DATOR` strings with no user-controlled components. No actionable injection vector identified, but the roam-output-to-config pipeline warrants monitoring.

2. **Access control** — Severity: Info
   Section 5 (Project Boundaries) prevents unauthorized file access, auto-commits, auto-pushes, and auto-installs. Consistently enforced across all distribution formats. The build script and installer operate only within expected directory trees.

3. **Data exposure** — Severity: Low
   Session exports stored locally. Persistent memory (Section 8.3) prohibits storing secrets. New in v1.3.0: The `codebase_description` key writes `roam describe` output to `leafhill.config.md`. For company projects, codebase descriptions could inadvertently expose internal architecture details. The skill does not differentiate behavior based on project `type` for this feature.

4. **Security misconfiguration** — Severity: Info
   All defaults are documented and secure. Companion tools degrade gracefully when unavailable. `roam health` failures are silently skipped (Section 2 step 6).

5. **Dependencies** — Severity: Low
   roam-code, persistent-memory, and superpowers are external dependencies never auto-installed. All three default to `on`, meaning the skill attempts to call them on every session start. No integrity verification (checksum, version pinning, signature) for companion tools. Standard for the ecosystem but represents a theoretical supply chain surface.

6. **Logging** — Severity: Low
   All logging is local. New in v1.3.0: `health_check` and audit verdict values in config are informational metadata with no sensitive content. Session export files may include references to sensitive topics without redaction guidance.

7. **Prompt injection resistance** — Severity: Medium
   Config values are limited to predefined keys with documented options. Priority 1 rules cannot be overridden by config. However, the `## Additional Rules` section allows open-ended instructions the AI will follow. A malicious `leafhill.config.md` in a cloned repo could contain override instructions. New in v1.3.0: The `codebase_description` field auto-populated from `roam describe` is stored in the config read on every session start. If a codebase manipulated its structure to produce adversarial `roam describe` output, that content would be written into the config. Blockquote format provides structural but not semantic isolation.

8. **Supply chain risks** — Severity: Low
   Distribution is file-copy based with no network registry. Build script uses `set -euo pipefail`, validates version format, includes monotonic guard. Tar archive not signed or checksummed after build. Acceptable for current single-author distribution model.

9. **Excessive permissions** — Severity: Info
   Permissions scoped to project root. All destructive actions require explicit user permission. `roam describe` and `roam health` are read-only. Config writes target only `leafhill.config.md` and audit files within project root.

10. **Insecure defaults** — Severity: Info
    All defaults are the most restrictive reasonable option. Companion tools default to `on` as expected dependencies.

### ISO 27001 Checks

1. **Information classification** — Severity: Low
   Clear distinction between code, config, secrets, and audit artifacts. New in v1.3.0: Auto-populated `codebase_description` and `health_check` introduce automated project metadata not classified by sensitivity. For company projects, codebase descriptions may constitute confidential information.

2. **Access control policy** — Severity: Info
   Section 5 enforces least-privilege principles consistently across all distribution formats.

3. **Change management** — Severity: Info
   Version tracking controlled via `application_version.txt` and 8 version-bearing files. Build script includes validation and monotonic guards. New in v1.3.0: Audit verdicts now recorded in `leafhill.config.md` in addition to dedicated audit files, providing redundant audit trail.

4. **Incident response** — Severity: Info
   Session exports, persistent memory, and audit files support investigation. New in v1.3.0: `health_check` field provides dated snapshots of codebase health for timeline reconstruction.

5. **Asset management** — Severity: Info
   All distribution files enumerated in the build script. Tar archive contents explicitly specified.

### Summary

| Severity | Count |
|----------|-------|
| Critical | 0     |
| High     | 0     |
| Medium   | 1     |
| Low      | 6     |
| Info     | 8     |

**Verdict:** PASS

---

## Audit — v1.2.1 — 2026-02-24

### OWASP Top 10+ (Adapted for AI Skill Instructions)

1. **Injection risks** — Severity: Info
   All commands (`roam --version`, `roam describe`) are hardcoded. Config values are simple key-value pairs, not executed. Audit output files use hardcoded filenames. No injection vectors identified.

2. **Access control** — Severity: Info
   Section 5 (Project Boundaries) prevents unauthorized file access, auto-commits, auto-pushes, and auto-installs. Consistently enforced across all distribution copies.

3. **Data exposure** — Severity: Low
   Session export files are stored locally in the project root with no external transmission. Persistent memory (Section 8.3) explicitly prohibits storing secrets, credentials, or sensitive data. Audit output files contain only skill review findings.

4. **Security misconfiguration** — Severity: Info
   All defaults are reasonable and documented. No insecure fallbacks identified. Config overrides are limited to Priority 3 settings.

5. **Dependencies** — Severity: Low
   roam-code, persistent-memory, and superpowers are external dependencies installed manually by the user. The skill reminds but does not auto-install, mitigating supply chain risk.

6. **Logging** — Severity: Info
   All logging is local (timestamped files, MCP server, audit output files). No external transmission of logs.

7. **Prompt injection resistance** — Severity: Low
   Config values are limited to predefined keys with documented options. Priority 1 rules cannot be overridden by config. No explicit instruction to validate/reject unexpected keys or values, but the constrained schema limits risk.

8. **Supply chain risks** — Severity: Info
   Distribution is file-copy based with no network-based package registry. install-leafhill-dev-skill.sh performs local copies only.

9. **Excessive permissions** — Severity: Info
   Permissions are scoped to project root. All destructive actions require explicit user permission.

10. **Insecure defaults** — Severity: Info
    All defaults are the most restrictive reasonable option.

### ISO 27001 Checks

1. **Information classification** — Severity: Info
   Clear distinction between code, config, secrets, and audit artifacts. Secrets are explicitly prohibited from storage.

2. **Access control policy** — Severity: Info
   Section 5 enforces least-privilege principles consistently.

3. **Change management** — Severity: Info
   Version tracking, release audit protocol, and new audit output files provide a controlled and auditable change process.

4. **Incident response** — Severity: Info
   Session exports, persistent memory, and audit history files support incident investigation.

5. **Asset management** — Severity: Info
   All distribution files are tracked in README.md and distribution-guide.txt.

### Summary

| Severity | Count |
|----------|-------|
| Critical | 0     |
| High     | 0     |
| Medium   | 0     |
| Low      | 3     |
| Info     | 12    |

**Verdict:** PASS
