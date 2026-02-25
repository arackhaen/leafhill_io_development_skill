# Leafhill Project Configuration

## Project Info

name: my-web-app
description: A full-stack web application for task management

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

## Companion Tools

roam_code: on
superpowers: on
persistent_memory: on

## Project Status

> Auto-populated by the leafhill-dev skill. Do not edit manually.

codebase_description:
> - **Files:** 42
> - **Symbols:** 156
> - **Edges:** 89
> - **Languages:** typescript (30), javascript (8), markdown (4)
>
> ## Directory Structure
>
> | Directory | Files | Primary Language |
> |-----------|-------|------------------|
> | `src/` | 30 | typescript |
> | `tests/` | 8 | typescript |
> | `docs/` | 4 | markdown |

health_check: 95/100 -- 20260225 -- v2.1.0

quality_audit: PASS v2.1.0 -- 20260225

infosec_audit: PASS v2.1.0 -- 20260225

## Additional Rules

- All API endpoints must return JSON with a consistent `{ data, error }` shape.
- Use Tailwind CSS for styling — no custom CSS unless absolutely necessary.
- Database migrations must be reversible.
