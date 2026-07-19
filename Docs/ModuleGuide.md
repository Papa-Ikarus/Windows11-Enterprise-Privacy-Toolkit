# Windows11 Enterprise Privacy Toolkit

# Module Development Guide

Version: 1.0 (Draft)

Status: Draft

Last Updated: 2026-07-19

---

# Purpose

This document defines the official specification for developing PowerShell modules within the Windows11 Enterprise Privacy Toolkit.

Its purpose is to ensure that every module:

- follows the same architecture
- has a consistent layout
- is easy to understand
- is easy to test
- is easy to maintain
- behaves consistently

These rules apply equally to:

- project maintainers
- contributors
- AI coding assistants
- automated code generators

Following this guide is mandatory.

---

# Design Philosophy

Every module should be:

- Small
- Focused
- Predictable
- Reusable
- Testable
- Self-contained

A module should perform one responsibility only.

If a module becomes responsible for multiple unrelated tasks, it should be split into multiple modules.

---

# Single Responsibility Principle

Each module should have one clearly defined purpose.

Good examples:

Logging

Registry

Firewall

Backup

Privacy

Profiles

Poor examples:

SystemUtilities

Helpers

Miscellaneous

CommonStuff

Generic "utility" modules should be avoided whenever practical.

---

# Module Directory Structure

Each module should follow a consistent directory layout.

Example:

Modules/

Core/

Logging/

Logging.psd1

Logging.psm1

Private/

PrivateFunction1.ps1

PrivateFunction2.ps1

Public/

Initialize-Logging.ps1

Write-Log.ps1

README.md

Tests/

Logging.Tests.ps1

Not every module requires all folders immediately.

However, the structure should remain expandable.

---

# Module Manifest

Whenever practical, every module should include a PowerShell module manifest.

Example:

Logging.psd1

The manifest defines:

- module version
- exported functions
- author
- dependencies

---

# File Responsibilities

Each file should have a single purpose.

Example:

Logging.psm1

Module bootstrap.

Public/

Contains exported functions.

Private/

Contains helper functions.

README.md

Documents the module.

Tests/

Contains Pester tests.

---

# Module Initialization

Modules should never initialize themselves automatically.

Modules should not:

- modify global state
- write registry values
- change configuration
- execute business logic

Importing a module should only make functions available.

---

# Module Loading

Only Bootstrap.ps1 and the initialization process should import modules.

Feature modules must never import unrelated feature modules.

---

# Public Functions

Public functions are the module interface.

Requirements:

- CmdletBinding()
- approved PowerShell verbs
- comment-based help
- logging
- error handling

Public functions should remain stable whenever possible.

---

# Private Functions

Private functions support public functions.

Rules:

- not exported
- documented when necessary
- focused
- reusable inside the module

---

# Function Size

Functions should remain reasonably small.

Recommended:

20–60 lines

Functions exceeding approximately 100 lines should be reviewed for possible refactoring.

Large functions are usually an indicator that responsibilities should be divided.

---

# Naming

Use approved PowerShell naming.

Examples:

Initialize-Logger

Write-Log

Get-WindowsBuild

Test-Administrator

Set-ToolkitRegistryValue

Avoid abbreviations.

Function names should clearly describe their purpose.

---

# Module Dependencies

Dependencies should always flow downward.

Bootstrap

↓

Core

↓

Feature Modules

Feature modules may depend on Core modules.

Core modules must never depend on Feature modules.

Circular dependencies are not permitted.

---

# Configuration

Modules should never contain hardcoded configuration values.

Configuration belongs in:

Config/

Profiles/

or dedicated configuration providers.

---

# Registry Operations

Registry modifications should always be performed through the toolkit registry abstraction.

Do not call:

Set-ItemProperty

directly if a toolkit helper exists.

Every registry change should support:

- logging
- backup
- rollback

---

# Logging

Modules must never implement custom logging.

Use the central logging module.

Avoid Write-Host.

Logging should provide:

- Information
- Warning
- Error
- Debug
- Verbose

---

# Error Handling

All public functions should use structured exception handling.

Use:

try

catch

Errors should:

- be logged
- provide meaningful messages
- preserve useful diagnostic information

Silent failures are not acceptable.

---

# Output

Functions should return objects whenever practical.

Avoid returning formatted text.

Formatting belongs to the presentation layer.

---

# Comment-Based Help

Every public function should contain:

.SYNOPSIS

.DESCRIPTION

.PARAMETER

.EXAMPLE

.NOTES

This improves usability and supports Get-Help.

---

# Testing

Every public function should have at least one Pester test.

Tests should verify:

expected behavior

invalid input

edge cases

error handling

Mocks should replace operating system interactions whenever possible.

---

# Documentation

Every module should include a README.md.

The README should explain:

Purpose

Responsibilities

Dependencies

Public Functions

Examples

Known Limitations

---

# Performance

Optimize only after correctness.

Readable code is preferred over micro-optimizations.

Performance improvements should be measurable.

---

# Security

Modules must never:

store passwords

store API keys

disable Windows security without documentation

download executable content without validation

execute remote code automatically

---

# Backward Compatibility

Public interfaces should remain stable.

Breaking changes should be documented.

Whenever possible:

extend

rather than

replace.

---

# AI Development Guidelines

AI coding assistants should:

read Architecture.md

read CodingStandards.md

read Development.md

read this document

before generating modules.

AI-generated code should:

follow repository conventions

avoid unrelated modifications

keep commits focused

respect module boundaries

update documentation when architecture changes

---

# Example Module Layout

Modules/

Core/

Logging/

Logging.psd1

Logging.psm1

Public/

Initialize-Logging.ps1

Write-Log.ps1

Private/

Get-TimeStamp.ps1

Format-LogMessage.ps1

README.md

Tests/

Logging.Tests.ps1

---

# Module Checklist

Before considering a module complete, verify:

☐ One responsibility only

☐ Uses approved verbs

☐ Uses CmdletBinding()

☐ Includes Comment-Based Help

☐ No Write-Host

☐ Uses centralized logging

☐ Error handling implemented

☐ No unnecessary dependencies

☐ README.md created

☐ Tests written

☐ Documentation updated

☐ Architecture respected

---

# References

- PROJECT_RULES.md
- Docs/Architecture.md
- Docs/CodingStandards.md
- Docs/Development.md
- Docs/Glossary.md
