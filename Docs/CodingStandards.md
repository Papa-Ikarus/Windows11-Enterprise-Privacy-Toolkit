# Windows11 Enterprise Privacy Toolkit

# Coding Standards

Version: 1.0

Status: Stable

Last Updated: 2026-07-21

---

# Purpose

This document defines the official coding standards for the Windows11 Enterprise Privacy Toolkit.

Its purpose is to ensure that all source code remains:

- consistent
- readable
- maintainable
- testable
- secure
- predictable

These standards apply equally to:

- project maintainers
- contributors
- external contributors
- AI coding assistants
- automated code generation tools

Compliance with this document is mandatory.

---

# Scope

These standards apply to all project source code, including but not limited to:

- PowerShell modules
- PowerShell scripts
- helper libraries
- manifests
- test code
- examples
- templates
- build scripts
- GitHub workflows where applicable

Every new implementation SHALL comply with these standards.

---

# Compliance

This document is subordinate to:

PROJECT_RULES.md

Whenever a conflict exists between this document and PROJECT_RULES.md, the rules defined in PROJECT_RULES.md take precedence.

Every contributor SHALL comply with these coding standards.

Code reviews SHALL verify compliance.

Repeated violations SHOULD be corrected before merge approval.

---

# Core Principles

The following principles guide every implementation.

## Readability

Code SHALL be easy to read.

Readable code is preferred over clever code.

Future maintainers should understand an implementation without unnecessary explanation.

---

## Maintainability

Code SHALL remain easy to modify.

Avoid tightly coupled implementations.

Avoid unnecessary complexity.

---

## Consistency

Naming

Formatting

Logging

Documentation

Error handling

Testing

shall remain consistent throughout the repository.

---

## Simplicity

Choose the simplest solution that fulfills the requirements.

Avoid premature optimization.

Avoid unnecessary abstraction.

---

## Testability

Every implementation SHOULD be designed with testing in mind.

Avoid designs that make automated testing unnecessarily difficult.

---

## Security

Security is more important than convenience.

Unsafe shortcuts MUST NOT be introduced.

---

## Reliability

Modules SHALL behave predictably.

Unexpected side effects SHOULD be avoided.

---

# Supported PowerShell Versions

The primary target platform is:

PowerShell 5.1

Compatibility with newer PowerShell versions SHOULD be maintained whenever practical.

PowerShell-specific behavior SHALL be documented whenever compatibility differences exist.

Experimental features requiring newer PowerShell versions MUST be documented explicitly.

---

# File Encoding

All text-based project files SHALL use:

- UTF-8 with BOM
- CRLF line endings

BOM is REQUIRED for all `.ps1`/`.psm1` files, not just "unless required".

Reason: Windows PowerShell 5.1 does not reliably detect UTF-8 without
a BOM. Files containing non-ASCII characters (e.g. German umlauts in
comments or strings) get misread using the system ANSI codepage
instead, which can silently corrupt string literals or even break
parsing entirely (observed: a corrupted quote character inside a
here-string caused a full parse failure, cascading into unrelated
syntax errors reported at unrelated line numbers). PowerShell 7 does
not have this problem, which is why this can pass local testing and
still fail on the actual Windows PowerShell 5.1 target.

All existing `.ps1`/`.psm1` files in this repository already have a
BOM. Keep it when editing them, and add one to any new file.

---

# Repository Structure

Source code SHALL remain organized according to the repository architecture.

Modules MUST NOT be placed into arbitrary directories.

Common structure:

Modules/

Tests/

Docs/

Templates/

Tools/

Scripts/

Experimental/

Every module SHALL reside in its designated location.

---

# Naming Conventions

Names SHALL be descriptive.

Abbreviations SHOULD be avoided unless universally understood.

Examples:

Good

Get-SystemInformation

Backup-RegistrySettings

Test-WindowsBuild

Poor

Get-Info

DoStuff

Run

Temp

Variable names SHALL describe their purpose.

Boolean variables SHOULD begin with:

Is

Has

Can

Should

Examples:

$IsAdministrator

$HasInternetConnection

$ShouldRestart

Constants SHOULD use descriptive names.

Magic values SHOULD NOT appear directly in code.

---

# Approved Verbs

Public PowerShell functions MUST use approved PowerShell verbs.

Examples include:

Get

Set

New

Remove

Enable

Disable

Test

Invoke

Export

Import

Backup

Restore

Custom verbs MUST NOT be introduced.

---

# Code Formatting

Source code SHALL remain consistently formatted.

Formatting rules:

- Four-space indentation.
- Opening braces on the same line.
- Closing braces aligned with the opening statement.
- One statement per line.
- Blank lines between logical sections.
- Consistent spacing around operators.
- Keep line lengths reasonable.
- Break long pipelines across multiple lines when readability improves.

Formatting SHALL prioritize readability over compactness.

---

# Advanced Functions

Public functions SHALL be implemented as Advanced Functions.

Every public function MUST include:

```powershell
[CmdletBinding()]
```

Advanced Functions provide:

- common parameters
- consistent behavior
- pipeline support
- improved usability

Simple script functions SHOULD be avoided in reusable modules.

---

# SupportsShouldProcess

Functions that modify the operating system SHOULD support:

```powershell
SupportsShouldProcess
```

This enables:

- -WhatIf
- -Confirm

Example:

```powershell
[CmdletBinding(SupportsShouldProcess = $true)]
```

Functions that cannot safely support ShouldProcess SHALL document the reason.

---

# Function Design

Each function SHALL have one clearly defined responsibility.

Functions SHOULD remain short.

Large functions SHOULD be divided into smaller helper functions.

Public functions SHALL expose stable interfaces.

Private helper functions SHOULD remain internal.

Functions SHOULD avoid unnecessary side effects.

Reusable logic SHOULD NOT be duplicated.

---

# Parameters

Parameters SHALL be explicitly defined.

Parameter names SHALL be descriptive.

Switch parameters SHOULD be preferred over Boolean parameters whenever practical.

Mandatory parameters SHALL be declared explicitly.

Optional parameters SHOULD provide sensible defaults.

---

# Parameter Validation

Public functions SHOULD validate input whenever practical.

Use validation attributes such as:

- ValidateNotNull()
- ValidateNotNullOrEmpty()
- ValidateSet()
- ValidateRange()
- ValidatePattern()

Parameter validation SHOULD prevent invalid execution before processing begins.

---

# Comment-Based Help

Every public function MUST include complete Comment-Based Help.

Comment-Based Help SHALL include:

- SYNOPSIS
- DESCRIPTION
- PARAMETER
- EXAMPLE
- OUTPUTS
- NOTES (where appropriate)

Documentation SHALL remain synchronized with implementation.

---

# Error Handling

Reliable error handling is mandatory throughout the project.

Errors SHALL never be silently ignored.

Every module SHALL distinguish between:

- expected errors
- unexpected errors
- fatal errors

Whenever practical, recoverable errors SHOULD allow execution to continue safely.

Fatal errors SHALL stop execution in a controlled manner.

Error messages SHALL be:

- accurate
- understandable
- actionable
- consistent

Error messages SHOULD explain:

- what happened
- why it happened
- how the user can resolve the issue

Sensitive implementation details MUST NOT be exposed to end users.

---

# Exceptions

Exceptions SHALL only be thrown when execution cannot safely continue.

Recoverable situations SHOULD NOT generate terminating exceptions.

Exceptions SHOULD contain meaningful messages.

Generic exception messages such as:

- Error
- Failed
- Unknown Error

SHALL NOT be used.

Whenever practical, exceptions SHOULD include sufficient diagnostic information for troubleshooting.

---

# Logging

Logging is mandatory for all modules performing system modifications.

Logging improves:

- diagnostics
- auditing
- reproducibility
- troubleshooting

Every significant operation SHOULD create a log entry.

Examples include:

- module start
- module completion
- backup creation
- rollback execution
- registry modifications
- firewall modifications
- service configuration
- Group Policy changes
- warnings
- errors

Log entries SHOULD contain:

- timestamp
- module name
- operation
- status
- severity

Sensitive information MUST NOT be written to log files.

Future logging SHOULD use a centralized logging framework.

---

# Output

Modules SHALL return useful information.

Output SHOULD consist of PowerShell objects rather than formatted text.

Formatting belongs to the presentation layer.

Modules SHOULD avoid unnecessary console output.

Write-Host SHALL only be used for:

- interactive prompts
- startup banners
- explicitly documented console-only output

Operational messages SHOULD use:

- Write-Verbose
- Write-Information
- Write-Debug
- Write-Warning
- Write-Error

---

# Return Values

Functions SHOULD return structured PowerShell objects.

Returned objects SHOULD expose meaningful properties.

Examples:

- Status
- Success
- ComputerName
- Path
- Result
- Duration

Functions SHOULD return consistent object types.

Null SHOULD only be returned when explicitly documented.

---

# Configuration

Configuration SHALL be separated from implementation.

Hardcoded values SHOULD be avoided whenever practical.

Configuration SHOULD be:

- centralized
- documented
- validated
- version controlled

Default values SHOULD be sensible.

Configuration validation SHALL occur before execution.

Invalid configuration SHALL generate meaningful error messages.

Configuration files MUST NOT contain:

- passwords
- API keys
- secrets
- tokens
- personal information

---

# Registry Access

Registry operations SHALL be centralized whenever practical.

Direct registry access SHOULD be avoided when reusable helper functions exist.

Registry modifications SHOULD:

- validate paths
- verify permissions
- support backup
- support rollback whenever technically feasible

Registry operations SHALL be logged.

---

# File System Operations

File operations SHALL validate:

- existence
- permissions
- destination
- available disk space where appropriate

Existing files SHOULD NOT be overwritten without confirmation unless explicitly documented.

Temporary files SHOULD be removed after successful execution.

File paths SHOULD support long path handling whenever practical.

---

# Dependency Management

External dependencies SHALL be minimized.

Every dependency MUST have a documented purpose.

Before introducing a dependency, contributors SHOULD evaluate:

- maintenance status
- licensing
- security
- compatibility
- long-term availability

Unused dependencies SHALL be removed.

Experimental dependencies MUST NOT become production requirements without review.

---

# Security

Security takes precedence over convenience.

The principle of least privilege SHALL always apply.

Modules MUST NOT:

- expose credentials
- store passwords
- store secrets
- disable security protections without documentation
- execute untrusted code

Downloaded resources SHOULD originate from trusted sources.

Security-sensitive operations SHALL be documented.

Potential security implications SHALL be reviewed before release.

---

# Testing

Testing is a mandatory part of development.

Every public function SHOULD have corresponding tests whenever practical.

Testing SHALL include, where applicable:

- Unit Tests
- Integration Tests
- Manual Validation
- Rollback Validation
- Compatibility Testing
- Regression Testing

Tests SHOULD be:

- repeatable
- deterministic
- independent

Every bug fix SHOULD include a regression test whenever practical.

No implementation SHALL be considered complete without appropriate testing.

---

# Documentation

Documentation is considered part of the implementation.

Whenever code changes, related documentation SHALL be reviewed.

Documentation SHOULD explain:

- purpose
- behavior
- limitations
- assumptions
- examples

Every public module SHALL include:

- README (where applicable)
- Comment-Based Help
- examples
- changelog impact

Undocumented functionality SHALL be considered incomplete.

Documentation SHALL remain synchronized with implementation.

---

# AI Development Rules

AI coding assistants are considered development tools.

AI-generated code SHALL comply with exactly the same quality standards as manually written code.

AI assistance does not replace engineering judgement.

Human contributors remain responsible for reviewing, validating and approving all generated code.

AI assistants MUST:

- read relevant project documentation before generating code
- follow PROJECT_RULES.md
- follow Architecture.md
- follow ModuleGuide.md
- follow CodingStandards.md
- preserve existing project architecture
- generate maintainable code
- generate tests whenever practical
- update documentation when behaviour changes
- explain assumptions when uncertainty exists

AI assistants MUST NOT:

- invent undocumented project architecture
- bypass coding standards
- remove documentation
- bypass testing
- introduce unnecessary dependencies
- rewrite unrelated code without justification
- introduce breaking changes without documentation
- expose credentials or secrets
- commit generated code directly without human review

Generated code SHALL be treated as a proposal until reviewed.

---

# Performance Guidelines

Performance optimizations SHALL never reduce:

- readability
- maintainability
- reliability
- security

Modules SHOULD:

- avoid unnecessary loops
- avoid repeated registry access
- avoid repeated file access
- avoid unnecessary object creation
- minimize network communication
- cache expensive operations where appropriate

Optimization SHOULD only occur after identifying an actual bottleneck.

Premature optimization SHOULD be avoided.

---

# Best Practices

Contributors SHOULD:

- write self-explanatory code
- keep functions focused
- minimize dependencies
- prefer composition over duplication
- reuse existing helper functions
- keep modules independent
- document assumptions
- write predictable code
- validate input early
- fail safely

Every implementation SHOULD leave the project in a better state than before.

---

# Anti-Patterns

The following practices SHOULD be avoided.

## Large Functions

Functions performing multiple unrelated tasks.

Preferred solution:

Split into smaller functions.

---

## Duplicate Code

Identical logic copied into multiple locations.

Preferred solution:

Create reusable helper functions.

---

## Magic Values

Hardcoded values without explanation.

Preferred solution:

Named constants or configuration values.

---

## Hidden Side Effects

Functions changing unrelated system state.

Preferred solution:

Single responsibility.

---

## Silent Failures

Ignoring exceptions or returning misleading success.

Preferred solution:

Meaningful error handling.

---

## Global State

Unnecessary use of global variables.

Preferred solution:

Pass data explicitly through parameters.

---

## Tight Coupling

Modules depending directly on implementation details of other modules.

Preferred solution:

Well-defined public interfaces.

---

# Example Structure

Recommended module structure:

Modules/

ModuleName/

├── ModuleName.psd1

├── ModuleName.psm1

├── Private/

├── Public/

├── Tests/

├── Examples/

└── README.md

Every module SHOULD follow this structure whenever practical.

---

# Example Function

Public functions SHOULD follow this general structure.

```powershell
function Get-Example {

    [CmdletBinding()]

    param(

        [Parameter(Mandatory)]

        [ValidateNotNullOrEmpty()]

        [string]$Name

    )

    begin {

    }

    process {

    }

    end {

    }

}
```

Consistency is more important than personal preference.

---

# Coding Philosophy

The primary objective is not writing code quickly.

The primary objective is writing code that remains understandable and maintainable for many years.

Every implementation SHOULD prioritize:

1. Correctness

2. Safety

3. Security

4. Readability

5. Maintainability

6. Simplicity

7. Testability

8. Reliability

9. Consistency

10. Performance

Readable code is preferred over clever code.

Code should be written for the next maintainer.

Every implementation should reduce technical debt whenever practical.

---

# Continuous Improvement

Coding standards are expected to evolve.

Contributors are encouraged to improve:

- readability
- maintainability
- testing
- documentation
- automation
- security
- consistency

Suggestions SHOULD be documented through the project's decision process.

Changes to this document SHOULD be reviewed before adoption.

---

# References

The following documents complement these coding standards:

- PROJECT_RULES.md
- Docs/Architecture.md
- Docs/Development.md
- Docs/ModuleGuide.md
- Docs/ModuleLifecycle.md
- Docs/Testing.md
- Docs/QualityAssurance.md
- Docs/DefinitionOfReady.md
- Docs/DefinitionOfDone.md
- Docs/ReviewChecklist.md
- Docs/ReleaseChecklist.md
- Docs/DecisionLog.md

Contributors are expected to familiarize themselves with these documents before implementing significant changes.

---

# Document Maintenance

This document is maintained by the project maintainers.

Changes SHALL:

- preserve consistency
- improve clarity
- remain backwards compatible whenever practical
- be documented in the Decision Log when significant

Major revisions SHOULD be reviewed before becoming effective.

---

# Revision History

| Version | Date | Description |
|----------|------------|------------------------------------|
| 1.0 | 2026-07-21 | Initial stable coding standards |

---

**End of Document**
