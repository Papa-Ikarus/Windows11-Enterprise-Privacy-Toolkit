# Telemetry

## Übersicht

Dieses Modul (`Modules/Privacy/TelemetryEndpoints.psm1`) stellt zwei Listen bereit:

- **Telemetrie-Endpunkte** (`Config/TelemetryEndpoints.json`): bekannte Microsoft-Domains, über die Diagnose-, Absturz-, Feedback- und Werbedaten übertragen werden.
- **Essential-Endpunkte / Whitelist** (`Config/EssentialEndpoints.json`): Domains, die unter keinen Umständen blockiert werden dürfen, damit Windows Update, Winget, Microsoft-Login und der Store weiterhin funktionieren.

Beide Listen liegen bewusst als JSON vor, nicht hartkodiert im Code – sie lassen sich ohne PowerShell-Kenntnisse erweitern oder korrigieren.

## Kategorien (Telemetrie)

| Kategorie      | Beispiel                              | Zweck                                    |
|----------------|----------------------------------------|-------------------------------------------|
| Diagnostics    | `vortex.data.microsoft.com`            | Allgemeine Diagnose- und Nutzungsdaten     |
| ErrorReporting | `watson.telemetry.microsoft.com`       | Absturzberichte (Windows Error Reporting)  |
| Feedback       | `feedback.windows.com`                 | Feedback Hub / Umfragen                   |
| Advertising    | `ads.msn.com`                          | Werbe-ID und Anzeigenauslieferung          |

## Kategorien (Essential / Whitelist)

| Kategorie       | Beispiel                        | Zweck                                  |
|-----------------|----------------------------------|------------------------------------------|
| MicrosoftLogin  | `login.microsoftonline.com`      | Microsoft-Konto- / Azure-AD-Login        |
| WindowsUpdate   | `update.microsoft.com`           | Windows Update inkl. Delivery Optimization |
| Winget          | `cdn.winget.microsoft.com`       | Winget-Paketquellen                      |
| Store           | `storeedgefd.dsx.mp.microsoft.com` | Microsoft Store Auslieferung/Lizenzierung |

## Funktionen

```powershell
Get-TelemetryEndpoints [-Category <string>] [-ConfigPath <string>]
Get-EssentialEndpoints [-Category <string>] [-ConfigPath <string>]
Test-TelemetryWhitelistConflict [-TelemetryConfigPath <string>] [-EssentialConfigPath <string>]
```

`Test-TelemetryWhitelistConflict` ist die zentrale Sicherheitsprüfung: Sie stellt sicher, dass keine Domain gleichzeitig auf der Telemetrie-Liste und der Whitelist steht. Das Firewall-Modul sollte diese Prüfung vor dem Anlegen von Regeln aufrufen und bei Konflikten abbrechen.

## Hinweis zur Datenqualität

Die mitgelieferten Listen basieren auf öffentlich dokumentierten und häufig zitierten Microsoft-Telemetrie-Endpunkten. Da sich Endpunkte je nach Windows-Build und -Version ändern können, sollten sie regelmäßig gegen eigene Netzwerk-Captures verifiziert werden (siehe eigenes VM-Bridge-Capture-Setup).

## Roadmap

- [ ] Abgleich der Listen mit eigenen Wireshark/tshark-Captures
- [ ] Erweiterung um IP-Ranges (für Fälle ohne stabilen DNS-Namen)
- [ ] Anbindung an das Firewall-Modul (`New-NetFirewallRule` je Telemetrie-Endpunkt)
