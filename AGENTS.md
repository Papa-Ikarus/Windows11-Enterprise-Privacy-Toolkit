# AGENTS.md

# Windows11 Enterprise Privacy Toolkit

This repository is designed to be developed with both human contributors and AI coding assistants.

## Read first

Before making any changes, read:

1. PROJECT_RULES.md
2. README.md

PROJECT_RULES.md contains the authoritative development rules.

---

## General Principles

- Keep changes small.
- One logical change per commit.
- Do not rewrite unrelated code.
- Preserve backwards compatibility whenever possible.
- Prefer improving existing modules over creating duplicates.

---

## Workflow

1. Understand the current implementation.
2. Explain the planned change.
3. Implement the smallest possible change.
4. Ensure existing functionality is preserved.
5. Update documentation if required.

---

## Code Style

Follow PROJECT_RULES.md.

Do not introduce a different coding style.

---

## Testing

If a change affects functionality:

- Update or add Pester tests.
- Do not remove tests to make CI pass.
- Fix the implementation instead.

---

## Documentation

If architecture changes:

Update:

- README.md (if user-facing)
- Docs/
- CHANGELOG.md

---

## Pull Requests

Describe:

- Why the change is needed.
- What changed.
- Possible risks.
- Rollback strategy (if applicable).

---

## Security

Never expose secrets.

Never commit:

- API keys
- Tokens
- Passwords
- Certificates

Use environment variables where appropriate.
