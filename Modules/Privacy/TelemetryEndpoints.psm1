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

    # WICHTIG (Windows PowerShell 5.1): ConvertFrom-Json liefert ein
    # JSON-Array als EIN nicht-aufgezähltes Pipeline-Objekt zurück,
    # was in Kombination mit @() um eine Pipeline herum zu
    # verschachtelten Arrays führen kann. Wir vermeiden das komplett,
    # indem wir explizit mit dem foreach-Sprachkonstrukt iterieren
    # (das ist von der Pipeline-"enumerate"-Eigenart unabhängig) statt
    # mit Where-Object/Pipeline zu filtern.
    $Parsed = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

    $AllEndpoints = New-Object System.Collections.Generic.List[object]
    foreach ($Item in $Parsed) {
        $AllEndpoints.Add($Item)
    }

    if ($Category) {
        $Filtered = New-Object System.Collections.Generic.List[object]
        foreach ($Item in $AllEndpoints) {
            if ($Item.Category -and ([string]$Item.Category).Trim() -ieq $Category.Trim()) {
                $Filtered.Add($Item)
            }
        }
        $ResultArray = $Filtered.ToArray()
    }
    else {
        $ResultArray = $AllEndpoints.ToArray()
    }

    # Komma-Operator zwingend: verhindert, dass PowerShell ein leeres
    # oder einelementiges Rückgabe-Array beim "return" in $null bzw.
    # einen Skalar auflöst (klassische PowerShell-Falle).
    return ,$ResultArray
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

    # Siehe ausführlicher Kommentar in Get-TelemetryEndpoints.
    $Parsed = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

    $AllEndpoints = New-Object System.Collections.Generic.List[object]
    foreach ($Item in $Parsed) {
        $AllEndpoints.Add($Item)
    }

    if ($Category) {
        $Filtered = New-Object System.Collections.Generic.List[object]
        foreach ($Item in $AllEndpoints) {
            if ($Item.Category -and ([string]$Item.Category).Trim() -ieq $Category.Trim()) {
                $Filtered.Add($Item)
            }
        }
        $ResultArray = $Filtered.ToArray()
    }
    else {
        $ResultArray = $AllEndpoints.ToArray()
    }

    return ,$ResultArray
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

    $ConflictList = New-Object System.Collections.Generic.List[string]
    foreach ($Domain in $TelemetryDomains) {
        if ($Domain -in $EssentialDomains) {
            $ConflictList.Add($Domain)
        }
    }
    $Conflicts = $ConflictList.ToArray()

    if ($Conflicts.Count -gt 0) {
        Write-ErrorLog "Whitelist-Konflikt: folgende Domains stehen sowohl auf der Telemetrie- als auch auf der Essential-Liste: $($Conflicts -join ', ')"
    }

    return ,$Conflicts
}

Export-ModuleMember -Function Get-TelemetryEndpoints, Get-EssentialEndpoints, Test-TelemetryWhitelistConflict
