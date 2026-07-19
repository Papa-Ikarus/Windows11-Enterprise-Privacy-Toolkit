Set-StrictMode -Version Latest

$script:RulePrefix = "PrivacyToolkit-Telemetry-"

function Add-TelemetryFirewallRules {
    <#
    .SYNOPSIS
        Erstellt pro Telemetrie-Endpunkt eine Outbound-Block-Regel in
        der Windows-Firewall (Domain wird zur Laufzeit per DNS
        aufgelöst, da die Firewall selbst keine FQDN-Regeln kennt).

    .DESCRIPTION
        Erfordert das NetSecurity-Modul (nur unter Windows verfügbar).
        Bereits vorhandene Regeln mit demselben Namen werden vorher
        entfernt (idempotent). Nicht auflösbare Domains werden
        übersprungen und als Warnung protokolliert statt das gesamte
        Kommando abzubrechen.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$TelemetryConfigPath
    )

    if (-not (Get-Command New-NetFirewallRule -ErrorAction SilentlyContinue)) {
        throw "New-NetFirewallRule ist nicht verfügbar. Dieses Feature benötigt Windows mit dem NetSecurity-Modul."
    }

    $EndpointParams = @{}
    if ($TelemetryConfigPath) { $EndpointParams['ConfigPath'] = $TelemetryConfigPath }
    $Endpoints = Get-TelemetryEndpoints @EndpointParams

    $CreatedCount = 0

    foreach ($Endpoint in $Endpoints) {

        $RuleName = "$script:RulePrefix$($Endpoint.Domain)"

        try {
            $ResolvedIPs = @((Resolve-DnsName -Name $Endpoint.Domain -Type A -ErrorAction Stop).IPAddress)
        }
        catch {
            Write-WarningLog "Konnte '$($Endpoint.Domain)' nicht auflösen, überspringe: $($_.Exception.Message)"
            continue
        }

        if (-not $ResolvedIPs) {
            Write-WarningLog "Keine IP-Adresse fuer '$($Endpoint.Domain)' gefunden, ueberspringe."
            continue
        }

        if ($PSCmdlet.ShouldProcess($Endpoint.Domain, "Firewall-Blockregel anlegen ($RuleName) fuer $($ResolvedIPs -join ', ')")) {

            Get-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue |
                Remove-NetFirewallRule -ErrorAction SilentlyContinue

            New-NetFirewallRule `
                -DisplayName $RuleName `
                -Direction Outbound `
                -Action Block `
                -RemoteAddress $ResolvedIPs `
                -Profile Any `
                -Description "Automatisch erstellt vom Windows11-Enterprise-Privacy-Toolkit (Telemetrie-Endpunkt: $($Endpoint.Domain))" `
                | Out-Null

            Write-Success "Firewall-Regel erstellt: $RuleName ($($ResolvedIPs.Count) IP(s))"
            $CreatedCount++
        }
    }

    return $CreatedCount
}

function Remove-TelemetryFirewallRules {
    <#
    .SYNOPSIS
        Entfernt alle vom Toolkit erstellten Telemetrie-Firewallregeln
        (Rücksetzoption zu Add-TelemetryFirewallRules).
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param()

    if (-not (Get-Command Get-NetFirewallRule -ErrorAction SilentlyContinue)) {
        throw "Get-NetFirewallRule ist nicht verfügbar. Dieses Feature benötigt Windows mit dem NetSecurity-Modul."
    }

    $Rules = Get-NetFirewallRule -DisplayName "$script:RulePrefix*" -ErrorAction SilentlyContinue

    if (-not $Rules) {
        Write-Info "Keine PrivacyToolkit-Firewall-Regeln gefunden."
        return 0
    }

    $RemovedCount = 0

    foreach ($Rule in $Rules) {
        if ($PSCmdlet.ShouldProcess($Rule.DisplayName, "Firewall-Regel entfernen")) {
            Remove-NetFirewallRule -DisplayName $Rule.DisplayName
            $RemovedCount++
        }
    }

    Write-Success "$RemovedCount Firewall-Regel(n) entfernt."
    return $RemovedCount
}

function Get-TelemetryFirewallRules {
    <#
    .SYNOPSIS
        Listet die aktuell aktiven, vom Toolkit erstellten
        Firewall-Regeln auf (Status-Abfrage, keine Änderung).
    #>
    param()

    if (-not (Get-Command Get-NetFirewallRule -ErrorAction SilentlyContinue)) {
        throw "Get-NetFirewallRule ist nicht verfügbar. Dieses Feature benötigt Windows mit dem NetSecurity-Modul."
    }

    return Get-NetFirewallRule -DisplayName "$script:RulePrefix*" -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function Add-TelemetryFirewallRules, Remove-TelemetryFirewallRules, Get-TelemetryFirewallRules
