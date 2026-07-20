# Windows11 Enterprise Privacy Toolkit

## Glossary

Version: 1.0 (Draft)

Status: Draft

Last Updated: 2026-07-19

---

## Purpose

This glossary defines the terminology used throughout the Windows11 Enterprise Privacy Toolkit.

All contributors, maintainers, and AI coding assistants should use these terms consistently in documentation, code, issues, pull requests, and commit messages.

---

# General Terms

## Bootstrap

The primary entry point of the toolkit.

Responsible for:

- Environment initialization
- Loading configuration
- Importing modules
- Starting execution

Current file:

```
Bootstrap.ps1
```

---

## Core Module

A module that provides shared infrastructure used by the entire toolkit.

Examples:

- Logging
- Registry
- Backup
- Compatibility
- Configuration

Core modules may not depend on Feature Modules.

---

## Feature Module

A module that implements a specific capability.

Examples:

- Privacy
- Firewall
- Winget
- Profiles

Feature modules may depend on Core modules.

---

## Profile

A collection of Windows version-specific settings.

Examples:

```
23H2
24H2
25H2
26H1
```

Profiles isolate operating system differences from the Core framework.

---

## Configuration

Static settings that control toolkit behavior.

Configuration files are stored in:

```
Config/
```

Configuration should never be hardcoded inside modules.

---

## Toolkit

Refers to the complete Windows11 Enterprise Privacy Toolkit project.

Not an individual script.

---

# Privacy Terms

## Telemetry

Windows diagnostic and usage data collected by Microsoft.

The toolkit aims to reduce unnecessary telemetry while maintaining supported functionality.

---

## Diagnostic Data

Information collected by Windows for diagnostics.

Depending on edition and policy configuration, diagnostic data levels may differ.

---

## Privacy Setting

A configuration that reduces data collection or limits communication with Microsoft services.

---

## Rollback

The process of restoring the system to its previous state.

Rollback should be available whenever supported.

---

## Backup

A copy of system settings created before modifications are applied.

Supported backup targets may include:

- Registry
- Firewall Rules
- Scheduled Tasks
- Hosts File

---

# Technical Terms

## Module

A PowerShell module implementing one responsibility.

Each module should remain independent whenever practical.

---

## Function

A reusable PowerShell command.

Public functions should follow approved PowerShell naming conventions.

---

## Public Function

A function intended for use outside its own module.

Must include:

- CmdletBinding()
- Comment-Based Help
- Logging
- Error handling

---

## Private Function

A helper function intended only for internal module use.

Should not be exported.

---

## Registry Engine

The abstraction layer responsible for registry operations.

Responsibilities include:

- Reading
- Writing
- Backup
- Rollback
- Logging

---

## Logging

Centralized recording of toolkit activity.

Logging should replace direct console output whenever practical.

---

## Compatibility Layer

Component responsible for detecting supported Windows versions and enabling version-specific behavior.

---

## Build Profile

A profile containing settings specific to a supported Windows build.

Example:

```
26H1
```

---

# Development Terms

## Sprint

A planned development phase focused on a specific objective.

Each sprint should produce a complete, reviewable result.

---

## Milestone

A significant development goal consisting of one or more completed sprints.

---

## Documentation

Project documentation stored under:

```
Docs/
```

Documentation is considered part of the source code.

---

## Coding Standards

The rules defined in:

```
Docs/CodingStandards.md
```

These rules apply to all project code.

---

## Architecture

The overall software design documented in:

```
Docs/Architecture.md
```

Architecture decisions should be documented before implementation.

---

## Review

The process of validating documentation, code, or tests before merging changes.

---

## Commit

A single logical change recorded in Git.

Each commit should have one clear purpose.

---

# Testing Terms

## Unit Test

A test validating one isolated function.

---

## Integration Test

A test validating interaction between multiple modules.

---

## Mock

A simulated implementation used during testing.

Mocks reduce dependency on the operating system.

---

# AI Development Terms

## AI Assistant

Any coding assistant used during development.

Examples include:

- ChatGPT
- Claude Code
- Aider
- GitHub Copilot

AI assistants should follow the project's documented architecture and coding standards.

---

## Project Rules

Repository-wide development rules documented in:

```
PROJECT_RULES.md
```

---

## Source of Truth

The authoritative documentation for a specific topic.

Examples:

- Architecture → Docs/Architecture.md
- Coding Rules → Docs/CodingStandards.md
- Development Process → Docs/Development.md

When conflicts occur, the Source of Truth takes precedence.

---

# References

- PROJECT_RULES.md
- Docs/Architecture.md
- Docs/CodingStandards.md
- Docs/Development.md
