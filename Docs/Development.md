# Windows11 Enterprise Privacy Toolkit

## Development Guide

Version: 1.0 (Draft)

Status: Draft

Last Updated: 2026-07-19

---

# Purpose

This document defines the official development workflow for the Windows11 Enterprise Privacy Toolkit.

All contributors—human and AI—should follow this process to ensure consistent, reviewable, and maintainable development.

---

# Development Philosophy

The project follows a documentation-first approach.

New functionality should be designed before implementation.

Every significant change should be:

- Planned
- Documented
- Reviewed
- Implemented
- Tested
- Documented again (if necessary)

---

# Development Workflow

Every feature follows the same lifecycle.

```
Plan
    ↓
Documentation
    ↓
Architecture Review
    ↓
Implementation
    ↓
Testing
    ↓
Code Review
    ↓
Documentation Update
    ↓
Commit
    ↓
Push
```

No step should be skipped.

---

# Sprint Model

Development is organized into small sprints.

Each sprint should have:

- one objective
- clear scope
- reviewable result

Large features should be divided into multiple sprints.

---

# Branch Strategy

For now the project uses:

```
main
```

Future versions may introduce:

```
develop
feature/*
release/*
hotfix/*
```

---

# Documentation First

Architecture should always be documented before implementation.

Examples:

New module

↓

ModuleGuide

↓

Implementation

New subsystem

↓

Architecture update

↓

Implementation

---

# Commit Strategy

Each commit should represent one logical change.

Good examples:

```
docs: add coding standards

feat(core): add logging module

fix(registry): restore backup handling

test(core): add logging tests

refactor(core): simplify module loading
```

Avoid mixing unrelated changes in a single commit.

---

# Review Process

Every change should be reviewed before merging.

Review checklist:

- Architecture respected
- Coding standards followed
- Documentation updated
- Tests passing
- No unnecessary changes

---

# Testing Workflow

Testing should occur before every commit.

Recommended order:

```
Pester Tests

↓

Manual Validation

↓

Commit
```

Broken code should never be committed intentionally.

---

# Documentation Maintenance

Documentation is part of the project.

Whenever architecture changes:

Update:

- Architecture.md
- ModuleGuide.md
- Glossary.md

Whenever development rules change:

Update:

- Development.md
- CodingStandards.md

---

# Issue Tracking

Every planned feature should have:

- objective
- expected behavior
- completion criteria

Whenever practical, link commits to issues.

---

# AI Development Workflow

AI coding assistants should:

- read Architecture.md first
- follow CodingStandards.md
- follow PROJECT_RULES.md
- preserve module boundaries
- avoid unrelated refactoring

Generated code should always be reviewed by a human.

---

# Definition of Done

A task is considered complete when:

- implementation finished
- tests passing
- documentation updated
- review completed
- committed
- pushed

---

# Continuous Improvement

Development rules may evolve.

Changes should improve:

- readability
- maintainability
- safety
- consistency

---

# References

- PROJECT_RULES.md
- Docs/Architecture.md
- Docs/CodingStandards.md
- Docs/Glossary.md
