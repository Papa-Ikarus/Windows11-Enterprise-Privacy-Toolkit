# Windows11 Enterprise Privacy Toolkit

# Review Checklist

Version: 1.0 (Draft)

Status: Draft

Last Updated: 2026-07-20

---

# Purpose

This document defines the official review process for the Windows11 Enterprise Privacy Toolkit.

Every change to the project shall be reviewed against the same quality standards before it is considered complete.

These rules apply equally to:

- Project maintainers
- Contributors
- External contributors
- AI coding assistants
- Automated code generation tools

The goal of every review is to improve the project while preserving consistency, reliability, and maintainability.

---

# Review Philosophy

A review is not intended to criticize the author.

Its purpose is to ensure that every contribution:

- improves the project
- follows the project architecture
- respects established standards
- does not introduce unnecessary risk

Every review should answer one simple question:

> Does this change improve the project without reducing its quality?

---

# Review Workflow

Every significant change should follow this workflow.

```
Implementation
        │
        ▼
Self Review
        │
        ▼
Documentation Review
        │
        ▼
Code Review
        │
        ▼
Testing Review
        │
        ▼
Security Review
        │
        ▼
Approval
        │
        ▼
Merge
```

Skipping review steps is strongly discouraged.

---

# Review Checklist

## Architecture

- [ ] Architecture follows Architecture.md
- [ ] Module responsibilities are respected
- [ ] No circular dependencies introduced
- [ ] Folder structure follows project standards
- [ ] Public and Private functions are separated
- [ ] Dependencies remain minimal

---

## Code Quality

- [ ] Code is readable
- [ ] Naming follows CodingStandards.md
- [ ] Approved PowerShell verbs are used
- [ ] CmdletBinding() implemented where appropriate
- [ ] No duplicated code
- [ ] No unused variables
- [ ] No dead code
- [ ] No commented legacy code
- [ ] Code complexity remains reasonable

---

## Error Handling

- [ ] Proper try/catch blocks
- [ ] Meaningful error messages
- [ ] Errors are logged
- [ ] Exceptions are not ignored
- [ ] ErrorAction handled correctly

---

## Logging

- [ ] Central logging module used
- [ ] No Write-Host for application logic
- [ ] Log messages are meaningful
- [ ] Sensitive information is never logged

---

## Configuration

- [ ] No hardcoded paths
- [ ] No hardcoded registry locations
- [ ] No hardcoded credentials
- [ ] Configuration documented
- [ ] Defaults documented

---

## Registry Changes

If registry modifications exist:

- [ ] Registry abstraction layer used
- [ ] Backup created
- [ ] Rollback implemented
- [ ] Registry paths documented

---

## Documentation

Verify documentation.

- [ ] README updated
- [ ] Comment-Based Help complete
- [ ] Examples provided
- [ ] Dependencies documented
- [ ] References updated
- [ ] Related documentation updated

---

## Testing

Verify:

- [ ] Unit Tests
- [ ] Integration Tests
- [ ] Manual validation completed
- [ ] Rollback tested
- [ ] Existing tests still pass

---

## Security

Verify:

- [ ] No secrets committed
- [ ] No credentials logged
- [ ] No unsafe downloads
- [ ] Input validation implemented
- [ ] Least privilege respected

---

## Performance

Verify:

- [ ] No obvious regressions
- [ ] Expensive operations minimized
- [ ] Readability preserved
- [ ] Optimization justified

---

# Risk Classification

Every review should classify the overall risk.

| Risk | Description |
|------|-------------|
| 🟢 Low | Documentation, formatting, comments |
| 🟡 Medium | Small feature additions |
| 🟠 High | Registry, Services, Firewall, Policies |
| 🔴 Critical | Backup, Restore, Security, Core Framework |

High and Critical changes should receive additional attention during review.

---

# AI Generated Code

When AI contributed to the implementation:

- [ ] Architecture respected
- [ ] Coding standards respected
- [ ] ModuleGuide respected
- [ ] Documentation updated
- [ ] Tests created or updated
- [ ] No unrelated changes introduced
- [ ] Generated code reviewed manually

AI-generated code must never bypass the normal review process.

---

# Commit Review

Verify:

- [ ] Conventional Commit format
- [ ] Single logical purpose
- [ ] No unrelated files included
- [ ] Commit history remains understandable

---

# Review Metrics

Reviewer:

Date:

Risk Level:

Files Reviewed:

Functions Reviewed:

Tests Executed:

Documentation Updated:

Issues Found:

Issues Resolved:

Review Duration:

---

# Approval Decision

Select one:

- [ ] Approved
- [ ] Approved with Recommendations
- [ ] Changes Requested
- [ ] Rejected

---

# Approval Criteria

A change may be approved only when:

- All review items completed
- No critical issues remain
- Documentation updated
- Tests pass successfully
- Security review completed
- Quality standards fulfilled

---

# References

- PROJECT_RULES.md
- Docs/Architecture.md
- Docs/CodingStandards.md
- Docs/Development.md
- Docs/ModuleGuide.md
- Docs/Testing.md
- Docs/QualityAssurance.md
- Docs/Security.md
- Docs/DefinitionOfDone.md
