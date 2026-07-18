# Windows11 Enterprise Privacy Toolkit
## Development Rules

### Project Philosophy

This project is developed as a professional software project.

Quality is preferred over speed.

Every change must improve the project without breaking existing functionality.

---

## Development Workflow

Development is organized into sprints.

Each sprint has one clear goal.

A sprint is complete only if:

- The project builds successfully.
- Existing tests pass.
- Documentation is updated.
- The repository remains in a working state.

---

## Commit Rules

Keep commits small.

One logical change per commit.

Use Conventional Commits.

Examples:

feat(core): add logging initialization

fix(firewall): correct rule detection

docs: update architecture

refactor(core): introduce bootstrap

---

## Architecture Rules

Never implement multiple subsystems in one commit.

Architecture first.

Implementation second.

Optimization last.

---

## Code Quality

Use:

- PowerShell 5.1 compatible syntax
- PowerShell 7 compatible syntax where possible
- Set-StrictMode -Version Latest
- CmdletBinding()
- Approved PowerShell verbs
- Comment-Based Help

---

## Logging

Modules never use Write-Host.

Only Logging.psm1 is allowed to write user-facing output.

---

## Registry

Every registry modification must support:

- Backup
- Logging
- Rollback

No direct registry changes without helper functions.

---

## Testing

Every public function should have a Pester test.

No feature is complete without passing tests.

---

## Development Strategy

Repository stabilization first.

Architecture second.

Features third.

Performance optimization last.

Never skip steps.

The toolkit must always remain functional.
