# Windows11 Enterprise Privacy Toolkit

# PROJECT RULES

Version: 1.0

Status: Draft

Last Updated: 2026-07-20

---

# 1. Purpose

This document defines the official project governance, engineering principles, development standards, quality requirements, and collaboration rules for the Windows11 Enterprise Privacy Toolkit.

It is the highest-level project document.

Every contributor shall follow these rules.

The objective is to ensure that the project remains:

- consistent
- maintainable
- secure
- well documented
- testable
- reproducible
- understandable
- sustainable over the long term

This document establishes a common foundation for both human contributors and AI coding assistants.

---

# 2. Scope

These rules apply to every part of the repository, including but not limited to:

- source code
- PowerShell modules
- manifests
- documentation
- tests
- examples
- templates
- configuration files
- GitHub workflows
- scripts
- release artifacts

These rules apply equally to:

- project maintainers
- contributors
- external contributors
- reviewers
- AI coding assistants
- automated tooling

No implementation is exempt unless explicitly documented.

---

# 3. Compliance

Compliance with this document is mandatory.

Every contributor SHALL follow these rules.

Whenever a conflict exists between project documents, the following order of precedence shall apply.

```
PROJECT_RULES.md
        │
        ├── Architecture.md
        ├── CodingStandards.md
        ├── Development.md
        ├── ModuleGuide.md
        ├── Testing.md
        ├── QualityAssurance.md
        ├── DefinitionOfReady.md
        ├── DefinitionOfDone.md
        ├── ReviewChecklist.md
        └── ReleaseChecklist.md
```

If another document conflicts with PROJECT_RULES.md, PROJECT_RULES.md takes precedence.

Any deviation MUST be:

- documented
- justified
- reviewed
- approved

---

# 4. Terminology

This project follows RFC 2119 terminology.

The following keywords define requirement levels.

| Keyword | Meaning |
|----------|----------|
| MUST | Mandatory requirement |
| MUST NOT | Strictly prohibited |
| REQUIRED | Equivalent to MUST |
| SHALL | Mandatory requirement |
| SHALL NOT | Mandatory prohibition |
| SHOULD | Strong recommendation |
| SHOULD NOT | Strong recommendation against |
| MAY | Optional |
| OPTIONAL | Fully optional |

Examples:

Every public PowerShell function MUST contain Comment-Based Help.

Every module SHOULD remain independent.

Experimental functionality MAY exist inside the Experimental directory.

Temporary debugging code MUST NOT be committed.

---

# 5. Project Vision

The Windows11 Enterprise Privacy Toolkit aims to provide a professional, modular, maintainable and transparent framework for configuring Windows 11 Enterprise privacy settings.

The project prioritizes:

- stability
- security
- maintainability
- documentation
- reversibility
- transparency

over rapid feature development.

Every change should improve long-term quality.

---

# 6. Core Principles

Every architectural and technical decision should support the following principles.

## 6.1 Reliability

The toolkit shall behave predictably.

Unexpected behaviour shall be avoided.

---

## 6.2 Safety

Whenever technically feasible, system modifications shall be reversible.

Rollback capability has higher priority than execution speed.

---

## 6.3 Simplicity

Solutions should be as simple as possible.

Unnecessary complexity shall be avoided.

---

## 6.4 Transparency

The toolkit shall never hide its behaviour.

Users should always understand:

- what happens
- why it happens
- how to undo it

---

## 6.5 Documentation

Documentation is considered part of the implementation.

Undocumented functionality is considered incomplete.

---

## 6.6 Modularity

Every responsibility belongs to one module.

Modules should remain loosely coupled.

---

## 6.7 Consistency

Naming

Structure

Logging

Documentation

Testing

Error handling

shall remain consistent throughout the project.

---

## 6.8 Maintainability

Code is written for future maintainers rather than for today's implementation speed.

Readable code is preferred over clever code.

---

## 6.9 Security

Security takes precedence over convenience.

Unsafe shortcuts shall not be introduced.

---

## 6.10 Quality

No feature is considered complete until it satisfies the Definition of Done.

# 7. Governance

Project governance ensures that development remains consistent throughout the entire lifecycle of the project.

Governance is based on the following principles:

- Consistency
- Transparency
- Accountability
- Maintainability
- Security
- Quality
- Documentation

Every significant technical decision shall be documented.

Every change shall be traceable.

Project quality shall never depend on a single contributor.

---

# 8. Repository Structure

The repository follows a predefined structure.

Contributors MUST NOT introduce arbitrary folders.

The repository structure shall remain logical, modular and predictable.

Example:

/
├── Docs/
├── Modules/
├── Tests/
├── Templates/
├── Assets/
├── Tools/
├── Scripts/
├── Experimental/
├── .github/
├── CHANGELOG.md
├── README.md
├── PROJECT_RULES.md
└── LICENSE

Future structural changes shall be documented before implementation.

---

# 9. Documentation Rules

Documentation is considered part of the source code.

Every implementation shall include the required documentation.

Documentation MUST remain synchronized with implementation.

Required documentation includes:

- README
- Module documentation
- Architecture
- Examples
- Public APIs
- Breaking changes
- Limitations
- Configuration

Documentation SHALL use clear technical language.

Documentation SHOULD explain both:

- What happens
- Why it happens

Whenever behaviour changes, documentation MUST be updated within the same change.

Incomplete documentation means incomplete implementation.

---

# 10. Architecture Rules

Architecture is defined by Architecture.md.

Every contributor SHALL respect architectural boundaries.

Architecture MUST remain stable.

Architecture SHALL evolve through documented decisions.

Major architectural changes require:

- justification
- documentation
- review
- approval

Architecture MUST prioritize:

- modularity
- maintainability
- readability
- testability
- scalability

Large modules SHOULD be divided into smaller responsibilities.

Circular dependencies MUST NOT exist.

---

# 11. Module Design Rules

Every module shall have one clearly defined responsibility.

Modules SHOULD be independent.

Modules SHALL expose only the public functions required by users.

Internal implementation details SHOULD remain private.

Each module SHALL contain:

- module manifest
- implementation
- documentation
- tests
- examples where appropriate

Modules SHALL follow consistent naming.

Public interfaces SHOULD remain stable.

Breaking changes MUST be documented.

Modules SHALL minimize dependencies.

Reusable functionality SHOULD be shared rather than duplicated.

Experimental functionality MUST remain isolated from production modules.

Deprecated modules SHALL remain documented until archived.

# 12. Coding Standards

All source code SHALL comply with the project CodingStandards.md.

Consistency is more important than personal coding style.

Every implementation SHOULD prioritize:

- readability
- maintainability
- predictability
- simplicity

Developers SHALL write code for future maintainers rather than for themselves.

The following principles apply:

- Avoid unnecessary complexity.
- Avoid duplicated code.
- Prefer small functions over large functions.
- Keep modules focused on a single responsibility.
- Use meaningful names.
- Keep public interfaces stable.
- Prefer explicit behaviour over implicit behaviour.

Code formatting SHALL remain consistent throughout the repository.

Comment-Based Help is REQUIRED for every public PowerShell function.

Comments SHOULD explain *why* something exists rather than *what* individual statements do.

Magic values SHOULD NOT be used.

Configuration values SHOULD be centralized whenever practical.

---

# 13. Error Handling

Every unexpected situation SHALL be handled gracefully.

The toolkit MUST NOT terminate unexpectedly because of recoverable errors.

Error handling SHALL be:

- predictable
- consistent
- informative
- documented

Errors SHOULD provide:

- what failed
- why it failed
- possible resolution
- rollback information where applicable

Silent failures MUST NOT occur.

Exceptions SHALL only be thrown when recovery is not possible.

Recoverable errors SHOULD be logged.

Fatal errors SHALL stop execution safely.

User-facing error messages SHOULD be understandable.

Internal diagnostic information MAY be written to log files.

---

# 14. Logging

Logging is mandatory for all modules performing system modifications.

Logging exists to improve:

- troubleshooting
- auditing
- diagnostics
- reproducibility

Every significant action SHOULD generate an appropriate log entry.

Examples include:

- module start
- module completion
- configuration changes
- registry modifications
- firewall modifications
- backup creation
- rollback execution
- warnings
- errors

Sensitive information MUST NOT be written to log files.

Log entries SHOULD include:

- timestamp
- module name
- operation
- result
- severity

Logging SHALL remain consistent across all modules.

Future logging implementations SHOULD use a centralized logging framework.

---

# 15. Configuration

Configuration SHALL be separated from implementation.

Hardcoded configuration values SHOULD be avoided whenever possible.

Configuration SHOULD be:

- centralized
- documented
- validated
- version controlled

Configuration files SHALL use consistent formats.

Configuration changes SHOULD require minimal code changes.

Modules SHALL validate configuration before execution.

Invalid configuration SHALL produce meaningful error messages.

Default values SHOULD be documented.

Optional configuration SHALL remain backwards compatible whenever possible.

Configuration MUST NOT contain:

- passwords
- API keys
- secrets
- personal information
- machine-specific values

Sensitive information SHALL be supplied securely at runtime whenever required.

# 16. Backup & Restore

Protecting the user's system is one of the primary goals of this project.

Whenever technically feasible, every operation that modifies the operating system SHALL support backup and restoration.

System changes SHOULD be reversible.

Before performing destructive or configuration-altering operations, the toolkit SHOULD:

- create a backup
- validate the backup
- record the backup location
- report backup status

Rollback SHALL restore the previous system state as accurately as possible.

Every rollback operation SHALL be logged.

Modules MUST clearly indicate whether rollback is:

- Fully supported
- Partially supported
- Not technically possible

Any irreversible operation MUST be clearly documented before execution.

---

# 17. Security

Security has priority over convenience.

Every implementation SHALL follow the principle of least privilege.

Modules SHALL request only the permissions required to perform their tasks.

The project MUST NOT:

- expose secrets
- expose credentials
- store passwords
- store API keys
- disable security features without documentation
- execute untrusted code

Downloaded content SHALL originate from trusted sources.

External dependencies SHOULD be minimized.

Security-sensitive operations SHALL be documented.

Potential security impacts SHALL be reviewed before release.

Every contributor shares responsibility for maintaining project security.

---

# 18. Testing Requirements

Testing is a mandatory part of development.

No feature is considered complete until appropriate testing has been performed.

Testing SHALL include, where applicable:

- Unit Tests
- Integration Tests
- Manual Validation
- Regression Testing
- Rollback Testing
- Compatibility Testing

Tests SHOULD be repeatable.

Tests SHOULD produce deterministic results.

Every bug fix SHOULD include a regression test whenever practical.

Failed tests SHALL be resolved before release.

Testing requirements are further defined in:

- Docs/Testing.md
- Docs/QualityAssurance.md
- Docs/DefinitionOfDone.md

---

# 19. Performance

Performance optimizations SHALL never reduce reliability.

Modules SHOULD:

- minimize execution time
- minimize unnecessary disk access
- minimize registry access
- minimize network communication
- avoid redundant operations

Large operations SHOULD provide progress information.

Long-running tasks SHOULD remain interruptible whenever practical.

Performance improvements SHALL NOT compromise readability or maintainability.

Performance regressions SHOULD be investigated before release.

---

# 20. Compatibility

The primary supported platform is:

- Windows 11 Enterprise

Other Windows editions MAY function correctly but are not guaranteed unless explicitly documented.

Compatibility SHALL be verified before introducing new features.

Modules SHOULD remain compatible with supported Windows builds whenever practical.

Compatibility testing SHOULD include:

- Group Policy
- Registry
- Windows Update
- Microsoft Account
- Microsoft Store
- Winget
- Windows Defender
- Windows Firewall

Unsupported operating systems SHALL be documented.

Breaking compatibility MUST be documented before release.

Experimental functionality SHALL clearly indicate any compatibility limitations.

# 21. Git Workflow

The project follows a structured Git workflow to ensure a clean and understandable history.

Every change SHALL be traceable.

Contributors SHOULD work in small, focused increments.

Each commit SHOULD represent one logical change.

Unrelated changes MUST NOT be combined into a single commit.

Generated files SHALL only be committed when required.

The default branch SHALL always remain in a releasable state.

---

# 22. Branch Strategy

The default development branch is:

- main

Feature branches SHOULD be used for larger changes.

Recommended naming:

feature/<name>

bugfix/<name>

hotfix/<name>

docs/<name>

refactor/<name>

experiment/<name>

Feature branches SHOULD be merged only after review.

Direct commits to the main branch SHOULD be avoided for large or high-risk changes.

---

# 23. Commit Standards

The project follows Conventional Commits.

Every commit message SHALL describe the purpose of the change.

Recommended commit types include:

- feat
- fix
- docs
- refactor
- test
- chore
- perf
- build
- ci
- revert

Examples:

feat: add firewall module

fix: correct registry backup logic

docs: improve architecture documentation

test: add rollback validation tests

Commits SHOULD remain small.

Temporary commits SHOULD NOT be pushed.

Work-in-progress commits SHOULD be squashed before release where appropriate.

---

# 24. Versioning

The project follows Semantic Versioning.

Format:

MAJOR.MINOR.PATCH

Example:

1.0.0

Version increases:

MAJOR

- Breaking changes

MINOR

- New backwards-compatible functionality

PATCH

- Bug fixes
- Documentation improvements
- Minor corrections

Version numbers SHALL remain consistent throughout the repository.

---

# 25. Release Process

Every release SHALL satisfy:

- Definition of Ready
- Definition of Done
- Testing requirements
- Review requirements
- Release Checklist

Every release SHOULD include:

- Release Notes
- Updated CHANGELOG
- Version Tag
- Documentation updates

Critical defects SHALL be resolved before release.

No release SHALL knowingly introduce severe regressions.

---

# 26. Code Review

Every significant change SHOULD be reviewed.

Reviews SHALL verify:

- architecture
- correctness
- readability
- maintainability
- documentation
- testing
- security

Reviews SHOULD focus on improving the project rather than personal coding style.

Constructive feedback is encouraged.

Review comments SHOULD explain the reasoning behind requested changes.

All review findings SHOULD be resolved before merging.

---

# 27. Decision Records

Significant architectural decisions SHALL be documented.

Decision records SHALL include:

- context
- decision
- rationale
- consequences
- alternatives

Architecture decisions SHOULD remain stable over time.

Superseded decisions SHALL remain documented for historical reference.

Decision records are maintained in accordance with:

Docs/DecisionLog.md

# 28. AI Assistant Rules

AI coding assistants are welcome contributors to this project.

However, AI-generated code SHALL follow exactly the same quality standards as manually written code.

AI assistance never replaces engineering judgement.

Every AI-generated contribution SHALL be reviewed by a human before becoming part of an official release.

AI assistants MUST:

- read the relevant project documentation before generating code
- respect the project architecture
- follow CodingStandards.md
- follow ModuleGuide.md
- follow PROJECT_RULES.md
- generate readable code
- preserve existing functionality
- update documentation when behaviour changes
- generate tests whenever appropriate
- explain assumptions when uncertainty exists

AI assistants MUST NOT:

- invent undocumented project architecture
- remove documentation
- bypass testing
- bypass reviews
- introduce breaking changes without documentation
- commit secrets or credentials
- introduce unnecessary dependencies
- rewrite unrelated code without justification
- ignore existing coding conventions
- fabricate functionality that cannot be verified

AI-generated code SHALL be treated exactly like manually written code during review.

---

# 29. PowerShell Best Practices

PowerShell is the primary implementation language of this project.

All PowerShell code SHALL follow Microsoft's recommended best practices where applicable.

Modules SHOULD:

- use approved PowerShell verbs
- follow standard naming conventions
- provide Comment-Based Help
- support common parameters
- validate input parameters
- use parameter attributes appropriately
- avoid global state
- minimize side effects

Public functions SHALL provide meaningful output.

Private helper functions SHOULD remain internal to their module.

Error handling SHALL use appropriate PowerShell mechanisms.

Advanced Functions SHOULD be preferred over simple scripts whenever practical.

PowerShell code SHOULD remain compatible with the project's supported PowerShell version unless documented otherwise.

---

# 30. Dependency Management

External dependencies SHALL be kept to a minimum.

Every dependency MUST have a clear purpose.

Before introducing a dependency, contributors SHOULD evaluate:

- necessity
- maintenance status
- licensing
- security
- long-term availability

Unused dependencies SHALL be removed.

Experimental dependencies MUST NOT become production requirements without review.

Dependency updates SHOULD be tested before release.

---

# 31. Deprecation Policy

Features occasionally become obsolete.

Deprecation SHALL follow a predictable process.

Deprecated functionality SHOULD remain available for a reasonable transition period whenever practical.

Every deprecation SHALL include:

- reason
- replacement
- migration guidance
- expected removal version

Deprecated functionality SHOULD generate appropriate warnings.

Removal of deprecated functionality SHALL be documented in release notes.

---

# 32. Exception Process

Exceptional situations may require temporary deviations from these rules.

Exceptions SHALL:

- be documented
- include technical justification
- identify affected components
- define a resolution plan
- receive maintainer approval

Temporary exceptions SHALL be reviewed regularly.

Permanent exceptions SHOULD be avoided.

---

# 33. Continuous Improvement

This project is expected to evolve over time.

Contributors are encouraged to improve:

- documentation
- architecture
- testing
- maintainability
- automation
- security
- development workflow

Improvements SHALL preserve the project's long-term consistency.

Quality improvements are considered valuable contributions even when they do not introduce new functionality.

---

# 34. Final Statement

The purpose of these rules is not to restrict contributors, but to ensure that the project remains understandable, maintainable and reliable for many years.

Every contributor shares responsibility for maintaining the project's quality.

Good software is the result of consistent engineering practices, thorough documentation and continuous review.

When uncertainty exists, contributors SHOULD prioritize:

1. Safety
2. Correctness
3. Maintainability
4. Readability
5. Simplicity
6. Performance

Following these principles will help ensure that the Windows11 Enterprise Privacy Toolkit remains a professional, trustworthy and sustainable open-source project.

---

# References

This document is supported by the following project documentation:

- Docs/Architecture.md
- Docs/CodingStandards.md
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

All contributors are expected to familiarize themselves with these documents before making significant changes to the project.

---

# Appendix A – Contributor Expectations

Every contributor is expected to:

- understand the project architecture
- follow all documented standards
- write maintainable code
- document significant changes
- test their work
- review their own changes before submission
- communicate openly when uncertainty exists

Project quality is considered a shared responsibility.

---

# Appendix B – AI Collaboration Principles

AI assistants are intended to increase productivity while preserving project quality.

Human contributors remain responsible for:

- architectural decisions
- security decisions
- final code review
- release approval
- acceptance of generated code

AI-generated content should always be considered a proposal until reviewed.

---

# Appendix C – Long-Term Project Goals

The long-term objectives of this project include:

- Maintain a clean and modular architecture.
- Provide reliable privacy controls for Windows 11 Enterprise.
- Preserve compatibility whenever possible.
- Support safe rollback of system modifications.
- Maintain comprehensive documentation.
- Ensure reproducible builds and releases.
- Keep dependencies minimal.
- Enable efficient collaboration between human developers and AI assistants.

Every future decision should support these objectives.

---

# Appendix D – Engineering Philosophy

The project values engineering discipline over implementation speed.

The preferred order of priorities is:

1. Safety
2. Security
3. Correctness
4. Reliability
5. Maintainability
6. Simplicity
7. Readability
8. Testability
9. Performance
10. Convenience

Whenever two solutions are technically equivalent, the solution with better readability and maintainability should be preferred.

---

# Appendix E – Project Quality Objectives

The project continuously strives to improve:

- Architecture
- Code Quality
- Documentation
- Testing
- Reliability
- Security
- Automation
- User Experience
- Maintainability

Quality improvements are encouraged even when they do not introduce new features.

---

# Document Maintenance

PROJECT_RULES.md is a living document.

It shall evolve together with the project.

Changes to this document SHOULD be:

- carefully considered
- reviewed
- documented
- communicated to contributors

Major revisions SHOULD be reflected in the project's Decision Log.

---

# Revision History

| Version | Date | Description |
|----------|------------|-------------------------------|
| 1.0 | 2026-07-20 | Initial project governance document |

---

**End of Document**
