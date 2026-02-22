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

## Additional Rules

- All API endpoints must return JSON with a consistent `{ data, error }` shape.
- Use Tailwind CSS for styling — no custom CSS unless absolutely necessary.
- Database migrations must be reversible.
