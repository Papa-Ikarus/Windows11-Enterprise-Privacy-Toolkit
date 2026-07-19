Set-StrictMode -Version Latest

function Get-TelemetryEndpoints {
    <#
    .SYNOPSIS
        Liefert die bekannten Windows-Telemetrie-Endpunkte aus
        Config/TelemetryEndpoints.json.

    .PARAMETER Category
        Optionaler Filter (z.B. 'Diagnostics', 'ErrorReporting',
        'Feedback', 'Advertising'). Ohne Angabe werden alle
        Endpunkte zurückgegeben.

    .PARAMETER ConfigPath
        Pfad zur JSON-Datei. Nur zu Testzwecken überschreibbar,
        Standard ist Config/TelemetryEndpoints.json relativ zum
        Repository-Root.
    #>
    param(
        [string]$Category,
        [string]$ConfigPath
    )

    if (-not $ConfigPath) {
        $ConfigPath = Join-Path $PSScriptRoot "..\..\Config\TelemetryEndpoints.json"
    }

    if (-not (Test-Path $ConfigPath)) {
        throw "Telemetrie-Konfigurationsdatei nicht gefunden: $ConfigPath"
    }

    # WICHTIG: ConvertFrom-Json gibt unter Windows PowerShell 5.1 ein
    # JSON-Array als EIN nicht-aufgezähltes Pipeline-Objekt zurück.
    # "@(cmd | ConvertFrom-Json)" wuerde das dadurch in ein
    # verschachteltes 1-Element-Array einwickeln (Bug nur unter 5.1,
    # unter PS7 unauffaellig). Deshalb zwingend zwei Schritte: erst
    # zuweisen, DANN separat mit @() re-flatten.
    $Endpoints = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
    $Endpoints = @($Endpoints)

    if ($Category) {
        $Endpoints = @($Endpoints | Where-Object { $_.Category -eq $Category })
    }

    return $Endpoints
}

function Get-EssentialEndpoints {
    <#
    .SYNOPSIS
        Liefert die Whitelist essenzieller Endpunkte (Windows Update,
        Winget, Microsoft-Login, Store) aus
        Config/EssentialEndpoints.json.

    .PARAMETER Category
        Optionaler Filter (z.B. 'WindowsUpdate', 'Winget',
        'MicrosoftLogin', 'Store').

    .PARAMETER ConfigPath
        Pfad zur JSON-Datei. Nur zu Testzwecken überschreibbar.
    #>
    param(
        [string]$Category,
        [string]$ConfigPath
    )

    if (-not $ConfigPath) {
        $ConfigPath = Join-Path $PSScriptRoot "..\..\Config\EssentialEndpoints.json"
    }

    if (-not (Test-Path $ConfigPath)) {
        throw "Essential-Endpoints-Konfigurationsdatei nicht gefunden: $ConfigPath"
    }

    # Siehe Kommentar in Get-TelemetryEndpoints: zwei Schritte wegen
    # ConvertFrom-Json-Verhalten unter Windows PowerShell 5.1.
    $Endpoints = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
    $Endpoints = @($Endpoints)

    if ($Category) {
        $Endpoints = @($Endpoints | Where-Object { $_.Category -eq $Category })
    }

    return $Endpoints
}

function Test-TelemetryWhitelistConflict {
    <#
    .SYNOPSIS
        Sicherheitsprüfung: stellt sicher, dass kein Domain-Eintrag
        gleichzeitig in der Telemetrie-Liste UND in der
        Essential-Whitelist auftaucht.

    .DESCRIPTION
        Diese Prüfung soll verhindern, dass das Firewall-Modul
        versehentlich einen essenziellen Endpunkt (Windows Update,
        Winget, Microsoft-Login) blockiert, weil er fälschlicherweise
        auch in der Telemetrie-Liste steht.

    .OUTPUTS
        Ein Array der Domains, die in beiden Listen vorkommen.
        Leeres Array = keine Konflikte.
    #>
    param(
        [string]$TelemetryConfigPath,
        [string]$EssentialConfigPath
    )

    $TelemetryParams = @{}
    if ($TelemetryConfigPath) { $TelemetryParams['ConfigPath'] = $TelemetryConfigPath }

    $EssentialParams = @{}
    if ($EssentialConfigPath) { $EssentialParams['ConfigPath'] = $EssentialConfigPath }

    $TelemetryDomains = (Get-TelemetryEndpoints @TelemetryParams).Domain
    $EssentialDomains = (Get-EssentialEndpoints @EssentialParams).Domain

    $Conflicts = @($TelemetryDomains | Where-Object { $_ -in $EssentialDomains })

    if ($Conflicts) {
        Write-ErrorLog "Whitelist-Konflikt: folgende Domains stehen sowohl auf der Telemetrie- als auch auf der Essential-Liste: $($Conflicts -join ', ')"
    }

    return @($Conflicts)
}

Export-ModuleMember -Function Get-TelemetryEndpoints, Get-EssentialEndpoints, Test-TelemetryWhitelistConflict
