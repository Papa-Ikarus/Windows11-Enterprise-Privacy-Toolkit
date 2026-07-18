# Coding Standards

> Windows11 Enterprise Privacy Toolkit

Version: 1.0 (Draft)

---

# Purpose

This document defines the coding standards used throughout the project.

All contributors—human and AI—must follow these rules to ensure consistent, maintainable, and high-quality code.

---

# Supported PowerShell Versions

The toolkit must support:

- Windows PowerShell 5.1
- PowerShell 7.x (where compatible)

Do not introduce syntax that breaks PowerShell 5.1 compatibility unless explicitly approved.

---

# General Principles

Code should be:

- Simple
- Readable
- Predictable
- Testable
- Reusable

Avoid clever code if a simpler solution exists.

Readability is preferred over brevity.

---

# File Encoding

Use:

- UTF-8
- CRLF line endings

No BOM unless required.

---

# Strict Mode

Every module should enable:

```powershell
Set-StrictMode -Version Latest
```

This helps detect programming errors early.

---

# Error Handling

Use:

```powershell
try {
    ...
}
catch {
    ...
}
```

Avoid silent failures.

Never suppress exceptions without logging.

---

# Functions

Public functions should use:

```powershell
[CmdletBinding()]
param()
```

Use approved PowerShell verbs.

Examples:

- Get-
- Set-
- Test-
- New-
- Remove-
- Initialize-
- Start-
- Stop-
- Invoke-

Avoid custom verbs.

---

# Naming Conventions

Functions:

```
Verb-Noun
```

Examples:

```
Get-WindowsBuild
Test-Administrator
Initialize-Logging
Start-PrivacyToolkit
```

Variables:

```
$WindowsBuild
$RegistryPath
$BackupDirectory
```

Constants:

```
$script:ToolkitVersion
```

---

# Comments

Comment why.

Do not comment what the code obviously does.

Bad:

```powershell
$i++
```

Good:

```powershell
# Retry counter for registry access
$i++
```

---

# Write-Host

Avoid Write-Host inside modules.

Use the logging system instead.

Allowed:

- Bootstrap banner
- Interactive CLI prompts (if intentionally designed)

---

# Logging

Modules should use Logging.psm1.

Do not implement custom logging inside feature modules.

---

# Registry Access

Never write directly to the registry if a helper function exists.

Preferred:

```powershell
Set-ToolkitRegistryValue
```

instead of:

```powershell
Set-ItemProperty
```

This enables:

- logging
- backup
- rollback

---

# Configuration

Avoid hardcoded values.

Configuration should come from:

```
Config/
```

---

# Module Design

Each module should have one responsibility.

Examples:

Logging

Registry

Firewall

Privacy

Profiles

Avoid mixing unrelated functionality.

---

# Dependencies

Minimize dependencies between modules.

Feature modules should depend only on Core modules.

Core modules should never depend on Feature modules.

---

# Testing

Every public function should have a Pester test.

Tests should be:

- deterministic
- isolated
- repeatable

Mock Windows-specific APIs where appropriate.

---

# Documentation

Every public function should include Comment-Based Help.

Example:

```powershell
<#
.SYNOPSIS
Returns the current Windows build.

.DESCRIPTION
Detects the installed Windows version.

.EXAMPLE
Get-WindowsBuild
#>
```

---

# Formatting

Indentation:

- 4 spaces

Maximum line length:

- approximately 120 characters

One statement per line.

Avoid deeply nested code.

Prefer early returns.

---

# Security

Never commit:

- passwords
- API keys
- access tokens
- certificates

Secrets must be provided through environment variables or secure configuration.

---

# Performance

Optimize only after correctness.

Avoid premature optimization.

Measure before optimizing.

---

# AI Development

AI assistants should:

- preserve existing architecture
- keep changes small
- avoid unrelated refactoring
- update documentation when architecture changes

---

# Commit Quality

Every commit should:

- have one purpose
- compile successfully
- preserve functionality
- keep tests passing
- include documentation updates if required

---

# Code Review Checklist

Before submitting changes, verify:

- Architecture preserved
- Coding standards followed
- Tests updated
- Documentation updated
- No unnecessary refactoring
- No secrets committed

---

# Philosophy

Readable code is better than clever code.

Correct code is better than fast code.

Maintainable code is better than short code.

Consistency is more valuable than personal preference.
