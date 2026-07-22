# Windows11 Enterprise Privacy Toolkit

# PowerShell Style Guide

Version: 1.0

Status: Stable

Last Updated: 2026-07-21

---

# Purpose

This document defines the official PowerShell style guidelines for the Windows11 Enterprise Privacy Toolkit.

Its purpose is to ensure that all PowerShell code remains:

- consistent
- readable
- maintainable
- predictable
- easy to review

These guidelines define how code should look rather than how it should function.

Functional requirements are documented in:

- PROJECT_RULES.md
- CodingStandards.md
- PowerShellSecurity.md

---

# Scope

This guide applies to every PowerShell file contained within this repository.

Including:

- Public modules
- Private modules
- Helper functions
- Build scripts
- Installation scripts
- Test scripts
- Development scripts

These rules apply equally to:

- Human contributors
- AI coding assistants
- Automated code generation tools

---

# Compliance

Compliance with this document is mandatory.

Whenever style conflicts with readability, readability SHALL take precedence.

Whenever this document conflicts with PROJECT_RULES.md, PROJECT_RULES.md takes precedence.

Code reviews SHALL verify compliance with this style guide.

---

# Style Philosophy

Good code is easier to maintain than clever code.

The project values:

- consistency
- simplicity
- readability
- maintainability

over individual coding preferences.

Every contributor should write code that another contributor can immediately understand.

---

# File Organization

PowerShell files SHOULD follow a predictable structure.

Recommended order:

1. Comment-Based Help (if applicable)
2. Using statements
3. Module variables
4. Private helper functions
5. Public functions
6. Export statements (if required)

The order SHALL remain consistent throughout the repository.

---

# File Encoding

All PowerShell source files SHALL use:

UTF-8 with BOM

This ensures compatibility with Windows PowerShell 5.1.

Files SHALL use consistent line endings.

Trailing whitespace SHOULD be removed.

Files SHOULD end with a single newline.

---

# File Naming

File names SHALL clearly describe their contents.

Examples:

BackupRegistry.ps1

FirewallRules.ps1

SystemInformation.ps1

Avoid names such as:

temp.ps1

script.ps1

new.ps1

test2.ps1

File names SHOULD use PascalCase.

---

# Folder Layout

Each module SHOULD use the following structure.

Module/

Public/

Private/

Tests/

Examples/

README.md

Module.psm1

Module.psd1

Helper functions SHALL remain inside the Private folder.

Only public commands belong inside Public.

---

# Naming Conventions

Names SHALL be descriptive.

Avoid abbreviations whenever practical.

Good examples:

Get-SystemInformation

Backup-RegistrySettings

Test-FirewallConfiguration

Poor examples:

DoStuff

Info

Run

Temp

Variable names SHALL describe their purpose.

---

# Approved Verbs

Public functions MUST use approved PowerShell verbs.

Examples:

Get

Set

New

Remove

Enable

Disable

Test

Invoke

Import

Export

Backup

Restore

Custom verbs SHALL NOT be introduced.

---

# Variable Naming

Variables SHOULD use PascalCase.

Examples:

$ComputerName

$RegistryPath

$FirewallRules

Boolean variables SHOULD begin with:

Is

Has

Can

Should

Examples:

$IsAdministrator

$HasNetworkConnection

$CanRollback

$ShouldRestart

Single-letter variable names SHOULD only be used inside short loops.

---

# Constants

Constants SHOULD use descriptive names.

Avoid:

$x = 5

Instead use:

$MaximumRetries = 5

Magic values SHOULD NOT appear directly in implementation code.

---

# Whitespace

Use four spaces for indentation.

Do not use tabs.

Insert blank lines between logical sections.

Avoid excessive blank lines.

One blank line is usually sufficient.

Whitespace SHOULD improve readability.

---

# Line Length

Lines SHOULD remain reasonably short.

Long expressions SHOULD be wrapped across multiple lines.

Long pipelines SHOULD place each pipeline element on its own line.

Example:

Get-Service |
    Where-Object {
        $_.Status -eq 'Running'
    } |
    Sort-Object Name

Readability is more important than minimizing line count.

---

# Braces

Opening braces SHALL appear on the same line.

Example:

if ($Condition) {

Closing braces SHALL align with the opening statement.

This convention SHALL remain consistent throughout the project.

---

# Regions

The use of #region SHOULD be minimized.

Regions MAY be used for:

- very large modules
- generated code

Small modules SHOULD NOT require regions.

Readable structure is preferred over code folding.

---

# Function Layout

Public functions SHALL follow a consistent structure.

Recommended order:

1. Comment-Based Help
2. Function declaration
3. CmdletBinding
4. Parameter block
5. Begin block
6. Process block
7. End block

Every public function SHOULD follow this structure whenever practical.

---

# Function Length

Functions SHOULD remain small and focused.

Recommended guidelines:

- One responsibility per function.
- Prefer multiple small helper functions over one large function.
- Avoid deeply nested logic.
- Extract reusable logic into private helper functions.

Large functions reduce readability and increase maintenance effort.

---

# CmdletBinding

Every public function SHALL use:

```powershell
[CmdletBinding()]
```

Functions modifying the operating system SHOULD additionally support:

```powershell
SupportsShouldProcess = $true
```

Example:

```powershell
[CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'Medium'
)]
```

---

# Parameter Layout

Parameter declarations SHOULD remain easy to read.

Recommended formatting:

```powershell
param (

    [Parameter(
        Mandatory = $true
    )]

    [ValidateNotNullOrEmpty()]

    [string]$ComputerName

)
```

Each attribute SHOULD appear on its own line whenever readability improves.

---

# Parameter Ordering

Parameters SHOULD be ordered logically.

Recommended order:

1. Mandatory parameters
2. Optional parameters
3. Switch parameters

Frequently used parameters SHOULD appear before less common parameters.

---

# Begin / Process / End

Advanced Functions SHOULD use the standard PowerShell execution model.

Recommended structure:

```powershell
begin {

}

process {

}

end {

}
```

Unused blocks MAY be omitted.

Avoid empty blocks unless they improve readability during development.

---

# Variables

Variables SHOULD be declared as close as possible to their first use.

Avoid unnecessarily long variable lifetimes.

Variable names SHALL describe their purpose.

Avoid names such as:

$temp

$data

$var

$item2

Prefer:

$RegistryPath

$BackupDirectory

$FirewallProfile

$NetworkAdapter

---

# Boolean Expressions

Boolean expressions SHOULD remain explicit.

Preferred:

```powershell
if ($IsAdministrator) {

}
```

Avoid unnecessary comparisons.

Instead of:

```powershell
if ($IsAdministrator -eq $true)
```

prefer:

```powershell
if ($IsAdministrator)
```

---

# Conditional Statements

Conditions SHOULD remain simple.

Complex conditions SHOULD be split into intermediate variables.

Avoid:

```powershell
if (($A -and $B) -or ($C -and !$D) -or ($E)) {

}
```

Prefer:

```powershell
$CanContinue =
    ($A -and $B) -or
    ($C -and -not $D) -or
    $E

if ($CanContinue) {

}
```

---

# Switch Statements

Switch SHOULD be preferred over long if/elseif chains whenever practical.

Example:

```powershell
switch ($State) {

    'Enabled' {

    }

    'Disabled' {

    }

    default {

    }

}
```

Switch statements SHOULD always include a default case unless explicitly unnecessary.

---

# Loops

Loops SHOULD remain easy to understand.

Avoid excessive nesting.

Nested loops SHOULD be refactored whenever practical.

Prefer:

```powershell
foreach ($Item in $Items) {

}
```

over index-based loops unless indexing is required.

---

# Pipelines

Pipelines SHOULD remain readable.

Long pipelines SHOULD place every pipeline stage on its own line.

Example:

```powershell
Get-Service |
    Where-Object {
        $_.Status -eq 'Running'
    } |
    Sort-Object Name |
    Select-Object Name
```

Pipelines SHOULD NOT become excessively long.

Complex processing SHOULD be extracted into helper functions.

---

# Error Handling Style

Use structured error handling.

Preferred:

```powershell
try {

}
catch {

}
finally {

}
```

Avoid empty catch blocks.

Errors SHALL either:

- be handled
- be logged
- be re-thrown

Silent failures MUST NOT occur.

---

# Output Style

Functions SHOULD return PowerShell objects.

Avoid formatted strings as function output.

Formatting belongs to the caller.

Good:

```powershell
[PSCustomObject]@{

    Success = $true

    Path = $Path

}
```

Poor:

```powershell
"Operation completed successfully."
```

---

# Comment-Based Help

Every public function SHALL contain complete Comment-Based Help.

Required sections:

- SYNOPSIS
- DESCRIPTION
- PARAMETER
- EXAMPLE
- OUTPUTS

Optional sections:

- NOTES
- LINK

Examples SHOULD reflect realistic project usage.

---

# Inline Comments

Inline comments SHOULD explain:

- why something exists
- why a decision was made
- why an unusual implementation is necessary

Avoid comments that simply repeat the code.

Poor:

```powershell
# Increment counter

$Counter++
```

Better:

```powershell
# Retry counter required because the Windows API may temporarily
# return ERROR_BUSY after registry modifications.

$RetryCount++
```

---

# Logging Style

Logging SHOULD remain consistent.

Messages SHOULD describe:

- operation
- target
- result

Examples:

Good

Creating registry backup...

Applying firewall configuration...

Rollback completed successfully.

Avoid vague messages such as:

Processing...

Working...

Done...

Error...

---

# Module Layout

Every PowerShell module SHALL follow a consistent directory structure.

Recommended layout:

```text
ModuleName/

├── ModuleName.psd1
├── ModuleName.psm1
├── Public/
├── Private/
├── Classes/
├── Tests/
├── Examples/
├── Assets/
└── README.md
```

## Public

Contains only exported functions.

Every public function SHALL have:

- Comment-Based Help
- Parameter validation
- Pester tests
- Documentation

---

## Private

Contains internal helper functions.

Private functions SHALL NOT be exported.

Implementation details SHOULD remain isolated inside this folder.

---

## Classes

If PowerShell classes are required, they SHOULD remain isolated from procedural code.

Classes SHOULD only be introduced when they provide clear architectural benefits.

---

## Tests

Every module SHOULD contain its own test directory.

Recommended layout:

```text
Tests/

Unit/

Integration/

Regression/
```

Test files SHOULD mirror the module structure.

---

## Examples

Every public module SHOULD provide practical examples.

Examples SHOULD demonstrate:

- common usage
- recommended usage
- expected output

Examples SHALL remain synchronized with the implementation.

---

# Code Examples

## Preferred Function

```powershell
function Get-SystemInformation {

    [CmdletBinding()]

    param (

        [Parameter(Mandatory)]

        [ValidateNotNullOrEmpty()]

        [string]$ComputerName

    )

    begin {

        Write-Verbose "Initializing"

    }

    process {

        Get-CimInstance `
            -ClassName Win32_OperatingSystem `
            -ComputerName $ComputerName

    }

    end {

        Write-Verbose "Completed"

    }

}
```

---

## Preferred Object Output

```powershell
[PSCustomObject]@{

    ComputerName = $ComputerName

    Success      = $true

    Timestamp    = Get-Date

}
```

Objects SHOULD remain consistent throughout the project.

---

# Anti-Patterns

The following patterns SHOULD be avoided.

---

## Large Functions

Poor:

One function performing dozens of unrelated operations.

Preferred:

Several focused helper functions.

---

## Deep Nesting

Avoid deeply nested code.

Poor:

```powershell
if (...) {

    if (...) {

        if (...) {

        }

    }

}
```

Prefer early exits.

---

## Hardcoded Values

Avoid:

```powershell
$Retries = 7
```

Prefer:

```powershell
$MaximumRetries = 7
```

Configuration values SHOULD be centralized whenever practical.

---

## Duplicate Code

Duplicate implementations SHOULD be refactored into reusable helper functions.

Every duplicated block increases future maintenance effort.

---

## Write-Host Abuse

Avoid using:

```powershell
Write-Host
```

for operational logging.

Prefer:

- Write-Verbose
- Write-Debug
- Write-Information
- Write-Warning
- Write-Error

---

## Global Variables

Avoid unnecessary global variables.

State SHOULD be passed through parameters or returned as objects.

---

## Silent Error Handling

Avoid:

```powershell
try {

}
catch {

}
```

Every exception SHALL be:

- handled
- logged
- re-thrown

Silent failures MUST NOT occur.

---

# Style Checklist

Before submitting code, verify:

- [ ] Approved PowerShell verbs used.
- [ ] PascalCase naming followed.
- [ ] Four-space indentation used.
- [ ] Consistent brace placement.
- [ ] CmdletBinding applied.
- [ ] Parameters validated.
- [ ] Comment-Based Help completed.
- [ ] Functions remain focused.
- [ ] Object output returned.
- [ ] Logging implemented.
- [ ] Error handling reviewed.
- [ ] Pester tests created.
- [ ] Documentation updated.

---

# AI Style Rules

AI coding assistants SHALL follow exactly the same style rules as human contributors.

AI-generated code SHOULD:

- follow existing project formatting
- preserve naming conventions
- avoid unnecessary refactoring
- generate readable code
- minimize duplication
- respect module boundaries
- generate Comment-Based Help where appropriate

AI assistants MUST NOT:

- invent project conventions
- ignore formatting rules
- change unrelated code
- introduce inconsistent styles

Generated code SHALL always be reviewed before merging.

---

# Continuous Improvement

Coding style is expected to evolve.

Contributors are encouraged to improve:

- readability
- consistency
- maintainability
- documentation
- examples

Style changes SHOULD remain backwards compatible whenever practical.

Major style changes SHOULD be discussed before adoption.

---

# References

This document complements:

- PROJECT_RULES.md
- Docs/CodingStandards.md
- Docs/PowerShellSecurity.md
- Docs/Architecture.md
- Docs/Development.md
- Docs/Testing.md
- Docs/QualityAssurance.md
- Docs/DefinitionOfReady.md
- Docs/DefinitionOfDone.md
- Docs/ReviewChecklist.md
- Docs/ReleaseChecklist.md
- Docs/DecisionLog.md

Contributors are expected to understand these documents before making significant changes.

---

# Document Maintenance

This document SHALL evolve together with the project.

Changes SHALL:

- improve readability
- improve consistency
- remain aligned with CodingStandards.md
- preserve established conventions whenever practical

Major revisions SHOULD be documented in the project's Decision Log.

---

# Revision History

| Version | Date | Description |
|----------|------------|------------------------------------------|
| 1.0 | 2026-07-21 | Initial stable PowerShell style guide |

---

# Final Statement

Consistent code is easier to understand, review, test and maintain.

This style guide exists to ensure that every PowerShell module within the Windows11 Enterprise Privacy Toolkit follows a single, predictable coding style.

When uncertainty exists, contributors SHOULD prioritize:

1. Readability
2. Consistency
3. Simplicity
4. Maintainability
5. Testability
6. Performance

A consistent coding style is an investment in the long-term quality of the project.

---

**End of Document**
