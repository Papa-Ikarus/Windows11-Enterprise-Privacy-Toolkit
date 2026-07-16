# Firewall / Blocking

## Übersicht

Drei Module übernehmen das eigentliche Blockieren der Telemetrie-Endpunkte aus `Modules/Privacy/TelemetryEndpoints.psm1`:

- **`Modules/Firewall/HostsBlock.psm1`** – schreibt Redirect-Einträge (Standard: `0.0.0.0`) in die Hosts-Datei
- **`Modules/Firewall/FirewallRules.psm1`** – erstellt echte Windows-Firewall-Blockregeln (Outbound, per aufgelöster IP)
- **`Modules/Firewall/TelemetryBlock.psm1`** – Orchestrator, der beide Methoden über einen einzigen Aufruf steuert

## Sicherheitsprinzip

`Block-TelemetryEndpoints` ruft **immer zuerst** `Test-TelemetryWhitelistConflict` auf und bricht mit einer Exception ab, falls eine Domain sowohl auf der Telemetrie- als auch auf der Essential-Whitelist steht. So kann nie versehentlich Windows Update, Winget, Microsoft-Login oder der Store blockiert werden.

## Verwendung

```powershell
Import-Module .\Modules\Privacy\TelemetryEndpoints.psm1
Import-Module .\Modules\Firewall\HostsBlock.psm1
Import-Module .\Modules\Firewall\FirewallRules.psm1
Import-Module .\Modules\Firewall\TelemetryBlock.psm1

# Nur ansehen, was passieren würde (keine Änderung):
Block-TelemetryEndpoints -Method Both -WhatIf

# Nur Hosts-Datei-Redirect:
Block-TelemetryEndpoints -Method Hosts

# Nur Firewall-Regeln:
Block-TelemetryEndpoints -Method Firewall

# Beides:
Block-TelemetryEndpoints -Method Both

# Rückgängig machen:
Unblock-TelemetryEndpoints -Method Both
```

## Hosts-Datei-Variante

- Nutzt einen klar markierten Block (`# === PrivacyToolkit Telemetry Block START/END ===`), damit bestehende Einträge nicht angetastet werden.
- Idempotent: mehrfaches Ausführen verändert die Zeilenzahl nicht.
- Legt vor jeder Änderung automatisch ein Backup an (`<hosts-datei>.privacytoolkit-backup-<timestamp>`).
- Unterstützt `-WhatIf` für einen Trockenlauf.

## Firewall-Variante

- Benötigt das Windows-`NetSecurity`-Modul (`New-NetFirewallRule`, `Resolve-DnsName`) – funktioniert nicht auf Nicht-Windows-Systemen und wirft dort eine klare Fehlermeldung statt eines kryptischen "Command not found".
- Domains werden zur Laufzeit per DNS aufgelöst, da Windows-Firewallregeln keine FQDN-Ziele unterstützen. Domains, die sich nicht auflösen lassen, werden übersprungen und als Warnung protokolliert statt das gesamte Kommando abzubrechen.
- Regeln werden konsistent benannt (`PrivacyToolkit-Telemetry-<Domain>`), damit `Remove-TelemetryFirewallRules` sie zuverlässig wiederfindet.

## Bekannte Einschränkung

Da Microsoft-Endpunkte teils hinter CDNs mit wechselnden IP-Adressen liegen, kann sich die per DNS aufgelöste IP mit der Zeit ändern. Die Firewall-Regeln sollten daher regelmäßig neu erstellt werden (z.B. per geplanter Aufgabe), damit sie nicht auf veraltete IPs zeigen. Die Hosts-Datei-Variante ist davon nicht betroffen, da sie den Domainnamen direkt umleitet.
