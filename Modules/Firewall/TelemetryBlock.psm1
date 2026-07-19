Set-StrictMode -Version Latest

function Block-TelemetryEndpoints {
    <#
    .SYNOPSIS
        Orchestriert das Blockieren von Telemetrie-Endpunkten über
        Hosts-Datei und/oder Windows-Firewall.

    .DESCRIPTION
        Führt vor jeder Aktion Test-TelemetryWhitelistConflict aus und
        bricht bei einem Konflikt hart ab, damit nie versehentlich ein
        essenzieller Endpunkt (Windows Update, Winget, MS-Login)
        blockiert wird.

    .PARAMETER Method
        'Hosts'    = nur Hosts-Datei-Redirect
        'Firewall' = nur Windows-Firewall-Regeln
        'Both'     = beides

    .EXAMPLE
        Block-TelemetryEndpoints -Method Hosts -WhatIf
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [ValidateSet('Hosts', 'Firewall', 'Both')]
        [string]$Method = 'Hosts',

        [string]$TelemetryConfigPath,
        [string]$EssentialConfigPath,
        [string]$HostsFilePath,
        [string]$RedirectTarget = '0.0.0.0'
    )

    $ConflictParams = @{}
    if ($TelemetryConfigPath) { $ConflictParams['TelemetryConfigPath'] = $TelemetryConfigPath }
    if ($EssentialConfigPath) { $ConflictParams['EssentialConfigPath'] = $EssentialConfigPath }

    $Conflicts = @(Test-TelemetryWhitelistConflict @ConflictParams)

    if ($Conflicts.Count -gt 0) {
        throw "Abbruch: $($Conflicts.Count) Domain(s) stehen sowohl auf der Telemetrie- als auch auf der Whitelist: $($Conflicts -join ', ')"
    }

    $Result = [PSCustomObject]@{
        HostsEntriesAdded  = 0
        FirewallRulesAdded = 0
    }

    if ($Method -in @('Hosts', 'Both')) {
        $HostsParams = @{ RedirectTarget = $RedirectTarget }
        if ($TelemetryConfigPath) { $HostsParams['TelemetryConfigPath'] = $TelemetryConfigPath }
        if ($HostsFilePath) { $HostsParams['HostsFilePath'] = $HostsFilePath }

        $Result.HostsEntriesAdded = Add-TelemetryHostsEntries @HostsParams
    }

    if ($Method -in @('Firewall', 'Both')) {
        $FirewallParams = @{}
        if ($TelemetryConfigPath) { $FirewallParams['TelemetryConfigPath'] = $TelemetryConfigPath }

        $Result.FirewallRulesAdded = Add-TelemetryFirewallRules @FirewallParams
    }

    return $Result
}

function Unblock-TelemetryEndpoints {
    <#
    .SYNOPSIS
        Macht Block-TelemetryEndpoints rückgängig (Hosts-Einträge
        und/oder Firewall-Regeln entfernen).
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [ValidateSet('Hosts', 'Firewall', 'Both')]
        [string]$Method = 'Hosts',

        [string]$HostsFilePath
    )

    $Result = [PSCustomObject]@{
        HostsEntriesRemoved  = 0
        FirewallRulesRemoved = 0
    }

    if ($Method -in @('Hosts', 'Both')) {
        $HostsParams = @{}
        if ($HostsFilePath) { $HostsParams['HostsFilePath'] = $HostsFilePath }

        $Result.HostsEntriesRemoved = Remove-TelemetryHostsEntries @HostsParams
    }

    if ($Method -in @('Firewall', 'Both')) {
        $Result.FirewallRulesRemoved = Remove-TelemetryFirewallRules
    }

    return $Result
}

Export-ModuleMember -Function Block-TelemetryEndpoints, Unblock-TelemetryEndpoints
