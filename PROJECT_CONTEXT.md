# Windows11-Enterprise-Privacy-Toolkit

## Projektbeschreibung für Claude / KI-Entwicklung

## Ziel des Projekts

**Windows11-Enterprise-Privacy-Toolkit** ist ein PowerShell-basiertes Hardening- und Privacy-Toolkit für Windows 11 Enterprise 24H2.

Ziel ist es, unnötige Telemetrie, Tracking und nicht benötigte Windows-Dienste zu reduzieren, ohne die wichtigen Microsoft-Funktionen zu beschädigen.

Das System soll weiterhin vollständig nutzbar bleiben:

* Windows Update muss funktionieren
* Microsoft-Konto Login muss funktionieren
* Lokale Konten müssen funktionieren
* Winget muss funktionieren
* PowerShell Skripte müssen lokal ausführbar bleiben
* Microsoft Store / App-Komponenten dürfen nicht unnötig beschädigt werden

---

# Zielplattform

## Windows Version

Getestete Basis:

```
Windows 11 Enterprise
Build:
28000.2340.260619-0343.BR_RELEASE_SVC_PROD3_CLIENTMULTI_X64FRE_DE-DE
```

Architektur:

```
x64
```

---

# Hauptfunktionen

## Privacy Hardening

Reduzierung von:

* Windows Telemetrie
* Diagnose-Daten
* Tracking-Dienste
* unnötigen Hintergrunddiensten
* nicht benötigten Aufgaben der Aufgabenplanung

Dabei gilt:

Keine aggressiven Blockaden, die Windows-Funktionen zerstören.

---

# Erhaltene Funktionen

Folgende Funktionen müssen weiterhin funktionieren:

## Windows Update

Nicht blockieren:

* Windows Update Server
* Update Orchestrator
* Update Health Services

## Winget

Muss weiterhin funktionieren:

* Paketlisten abrufen
* Programme installieren
* Programme aktualisieren

## Microsoft Login

Muss weiterhin funktionieren:

* Microsoft Konto Anmeldung
* Authentifizierung
* Store Login
* Cloud Funktionen

---

# Firewall Konzept

Die Firewall-Regeln sollen gezielt Telemetrie reduzieren.

Nicht erlaubt:

* komplette Microsoft Blockierung
* pauschales Blockieren aller Microsoft Endpunkte

Erlaubt:

* bekannte Telemetrie-Endpunkte reduzieren
* Diagnose-Verbindungen einschränken

Ausnahmen:

```
Windows Update
Winget
Microsoft Login
Store Authentifizierung
```

müssen erhalten bleiben.

---

# Projektstruktur

Geplante Struktur:

```
Windows11-Enterprise-Privacy-Toolkit
│
├── Install
│
├── Modules
│   │
│   └── Core
│       │
│       └── Logging.psm1
│
├── Scripts
│
├── Config
│
├── Firewall
│
├── Logs
│
├── Documentation
│
└── PostInstall.ps1
```

---

# PowerShell Architektur

Das Toolkit wird modular aufgebaut.

Beispiel:

```
Modules\Core\Logging.psm1
```

Aufgaben:

* zentrale Protokollierung
* Fehlererfassung
* Statusmeldungen

Geplante Funktionen:

```powershell
Initialize-Logger
Write-Log
Write-Info
Write-Success
Write-Warning
Write-Error
Write-Debug
```

Logs werden gespeichert unter:

```
Logs\
```

---

# PostInstall.ps1

Hauptstartpunkt nach Installation.

Aufgaben:

* Module laden
* System prüfen
* Logging starten
* Datenschutz-Einstellungen anwenden
* Ergebnis protokollieren

Wichtig:

Der Scriptpfad muss zuverlässig erkannt werden.

Empfohlen:

```powershell
$ScriptRoot = Split-Path -Parent $PSCommandPath
```

Damit funktionieren relative Modulpfade:

```powershell
Import-Module "$ScriptRoot\Modules\Core\Logging.psm1"
```

---

# Sicherheitsprinzipien

Das Toolkit soll:

* nachvollziehbar sein
* rückgängig machbar sein
* jede Änderung protokollieren
* keine versteckten Änderungen durchführen

Jede Änderung benötigt:

* Beschreibung
* vorheriger Zustand
* neuer Zustand
* Rücksetzoption

---

# GitHub Ziel

Repository:

```
Windows11-Enterprise-Privacy-Toolkit
```

Ziel:

Ein professionelles Open-Source Toolkit für Windows 11 Enterprise.

Dokumentation:

* README.md
* CHANGELOG.md
* LICENSE
* Dokumentation der Module
* Beispiele

---

# Entwicklungsstand

Bereits geplant:

✅ Projektstruktur
✅ Grundkonzept Privacy Hardening
✅ Erhaltung von Windows Update / Winget / MS Login
✅ modulare PowerShell Architektur
✅ Logging System geplant

Nächster Entwicklungsschritt:

## Logging.psm1 erstellen

Mit:

* Logger Initialisierung
* Log-Dateien
* Zeitstempel
* Statuslevel
* Fehlerbehandlung

Danach:

* Telemetrie Module
* Firewall Module
* Gruppenrichtlinien Module
* Restore Funktionen

---

# Aufgabe für Claude

Arbeite an diesem Projekt als PowerShell-Entwickler.

Beachte:

1. Keine aggressiven Privacy Tweaks, die Windows beschädigen.
2. Windows Update muss funktionieren.
3. Winget muss funktionieren.
4. Microsoft Login muss funktionieren.
5. Jede Änderung muss dokumentiert und rücksetzbar sein.
6. Code muss sauber modular aufgebaut sein.

Ziel:

Ein professionelles Windows 11 Enterprise Privacy Toolkit.
