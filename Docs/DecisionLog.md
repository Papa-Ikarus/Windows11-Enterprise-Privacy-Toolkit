Decision ID:
ADR-0001

Title:
Documentation First

Status:
Accepted

Reason:

Large projects become difficult to maintain if architecture exists only inside the source code.

Consequences:

Every architectural change requires updating the documentation before implementation.

---

Decision ID:
ADR-0002

Title:
UTF-8 BOM Required for All .ps1/.psm1 Files

Status:
Accepted

Reason:

CI on the actual target platform (Windows PowerShell 5.1) repeatedly
failed with parse errors and corrupted string content in files
containing non-ASCII characters (German umlauts). Root cause: Windows
PowerShell 5.1 does not reliably detect UTF-8 without a BOM and falls
back to the system ANSI codepage, silently corrupting multi-byte
characters. In one case this corrupted a quote character inside a
here-string, breaking parsing for the entire file. PowerShell 7 does
not exhibit this problem, which made the issue invisible during local
development/testing.

Consequences:

All .ps1/.psm1 files must be saved with a UTF-8 BOM. CodingStandards.md
updated accordingly ("No BOM unless required" -> "BOM required").