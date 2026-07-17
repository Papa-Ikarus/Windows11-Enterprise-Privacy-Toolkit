# Windows 11 Enterprise Privacy Toolkit

> A modular, enterprise-grade PowerShell toolkit to improve privacy on Windows 11 Enterprise without breaking core Microsoft functionality.

> **Status:** 🚧 Early Development (v0.1.0-alpha)

---

## 🎯 Project Goals

This project aims to reduce Windows telemetry and improve privacy while preserving:

- ✅ Windows Update
- ✅ Microsoft Account Sign-in
- ✅ Microsoft Store
- ✅ winget
- ✅ Microsoft Defender
- ✅ Windows Activation

This project is **not** a Windows debloater.

Every change is designed to be:
- Reversible
- Documented
- Logged
- Tested

---

## 🖥 Supported Operating Systems

| Windows Version | Status |
|----------------|--------|
| Windows 11 Enterprise 23H2 | Planned |
| Windows 11 Enterprise 24H2 | Planned |
| Windows 11 Enterprise 25H2 | Planned |
| Windows 11 Enterprise 26H1 | Primary Target |

---

## 📁 Repository Structure

```text
Modules/
├── Core/
├── Privacy/
├── Firewall/
├── Winget/
└── Profiles/

Docs/
Tests/
.github/
```

---

## 🚀 Planned Features

- Logging Framework
- System Detection
- Compatibility Profiles
- Registry Engine
- Backup & Restore
- Privacy Configuration
- Firewall Rules
- Scheduled Task Management
- Reporting

---

## 🛠 Development Principles

- Modular architecture
- PowerShell 5.1 and PowerShell 7+
- Enterprise-first design
- Comprehensive logging
- Rollback support where technically possible
- Conventional Commits

---

## 📄 License

MIT License

---

## 🤝 Contributing

Contributions are welcome after the first stable alpha release.