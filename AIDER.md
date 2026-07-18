# Aider Instructions

Read PROJECT_RULES.md before making changes.

Never bypass the documented architecture.

Prefer modifying existing modules over creating duplicates.

Keep commits small.

Do not rewrite unrelated code.

# Windows11 Enterprise Privacy Toolkit - Aider Instructions

## Project Goal

Develop a professional, modular, enterprise-grade privacy toolkit for Windows 11 Enterprise.

The toolkit must improve privacy while keeping the following features fully functional:

- Windows Update
- Microsoft Account Login
- Microsoft Store
- winget
- Microsoft Defender
- Activation

Target platforms:

- Windows 11 Enterprise 23H2
- Windows 11 Enterprise 24H2
- Windows 11 Enterprise 25H2
- Windows 11 Enterprise 26H1

---

# General Rules

Always prefer

- readable code
- modular architecture
- extensive comments
- robust error handling
- logging
- rollback support

Never create "debloat" scripts.

Everything must be reversible whenever technically possible.

---

# Coding Standards

PowerShell only.

Compatible with

- Windows PowerShell 5.1
- PowerShell 7+

Use

Set-StrictMode -Version Latest

Use CmdletBinding()

Use approved PowerShell verbs.

Every public function needs comment-based help.

No duplicated code.

No hardcoded paths.

---

# Logging

Every module must use Logging.psm1.

No Write-Host except inside Logging.psm1.

Supported log levels

- INFO
- SUCCESS
- WARNING
- ERROR
- DEBUG

---

# Error Handling

Always use Try/Catch.

Never ignore exceptions.

Always log failures.

---

# Architecture

Repository

Modules/

Core/

Privacy/

Firewall/

Winget/

Profiles/

Compatibility/

Docs/

Tests/

---

# Core Modules

Implement first

Logging

SystemCheck

Compatibility

Registry

Backup

Report

Afterwards

Telemetry

Privacy

Services

ScheduledTasks

Firewall

Explorer

Winget

---

# Registry

Never call Set-ItemProperty directly.

Always use Registry.psm1 helper functions.

Every registry change must support

- logging
- backup
- rollback

---

# Services

Never disable services without

documentation

risk assessment

rollback

---

# Scheduled Tasks

Only disable tasks after

documentation

compatibility verification

rollback support

---

# Documentation

Every feature requires

documentation

reason

affected Windows versions

rollback information

---

# Git

Use Conventional Commits.

Examples

feat(core): implement logging framework

fix(logging): resolve initialization bug

docs(readme): update installation guide

refactor(core): simplify registry engine

---

# Tests

Every new feature must

compile

load correctly

produce no PowerShell errors

---

# Mission

Build a professional privacy toolkit.

Not another Windows debloater.
