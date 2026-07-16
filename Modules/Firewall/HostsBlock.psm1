Set-StrictMode -Version Latest

$script:MarkerStart = '# === PrivacyToolkit Telemetry Block START (NICHT MANUELL BEARBEITEN) ==='
$script:MarkerEnd   = '# === PrivacyToolkit Telemetry Block END ==='

function Get-DefaultHostsPath {
    if ($env:SystemRoot) {
        return (Join-Path $env:SystemRoot "System32\drivers\etc\hosts")
    }
    return "/etc/hosts"
}

function Remove-TelemetryMarkerBlock {
    <#
    .SYNOPSIS
        Privater Helfer: entfernt einen vorhandenen Marker-Block aus
        einer Zeilen-Liste, lässt den Rest unangetastet.
    #>
    param([string[]]$Lines)

    $Result = New-Object System.Collections.Generic.List[string]
    $InBlock = $false

    foreach ($Line in $Lines) {
        if ($Line.Trim() -eq $script:MarkerStart) { $InBlock = $true; continue }
        if ($Line.Trim() -eq $script:MarkerEnd)   { $InBlock = $false; continue }
        if (-not $InBlock) { $Result.Add($Line) }
    }

    return $Result.ToArray()
}

function Add-TelemetryHostsEntries {
    <#
    .SYNOPSIS
        Schreibt Telemetrie-Endpunkte als Redirect-Einträge in die
        Hosts-Datei (Standard: Redirect auf 0.0.0.0).

    .DESCRIPTION
        Idempotent: ein vorhandener PrivacyToolkit-Block wird zuerst
        entfernt und dann neu geschrieben. Vor jeder Änderung wird ein
        Backup der Hosts-Datei angelegt.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$HostsFilePath = (Get-DefaultHostsPath),
        [string]$RedirectTarget = '0.0.0.0',
        [string]$TelemetryConfigPath
    )

    if (-not (Test-Path $HostsFilePath)) {
        throw "Hosts-Datei nicht gefunden: $HostsFilePath"
    }

    $EndpointParams = @{}
    if ($TelemetryConfigPath) { $EndpointParams['ConfigPath'] = $TelemetryConfigPath }
    $Endpoints = Get-TelemetryEndpoints @EndpointParams

    $ExistingLines = Get-Content -Path $HostsFilePath
    $CleanLines = @(Remove-TelemetryMarkerBlock -Lines $ExistingLines)

    # Anhängende Leerzeilen abschneiden, damit wiederholte Läufe nicht
    # bei jedem Aufruf eine zusätzliche Leerzeile anhäufen (Idempotenz).
    while ($CleanLines.Count -gt 0 -and [string]::IsNullOrWhiteSpace($CleanLines[-1])) {
        $CleanLines = @($CleanLines[0..($CleanLines.Count - 2)])
    }

    $NewBlock = New-Object System.Collections.Generic.List[string]
    $NewBlock.Add($script:MarkerStart)
    foreach ($Endpoint in $Endpoints) {
        $NewBlock.Add("$RedirectTarget`t$($Endpoint.Domain)")
    }
    $NewBlock.Add($script:MarkerEnd)

    $FinalContent = @($CleanLines) + @('') + @($NewBlock)

    if ($PSCmdlet.ShouldProcess($HostsFilePath, "Telemetrie-Einträge schreiben ($($Endpoints.Count) Domains)")) {

        $BackupPath = "$HostsFilePath.privacytoolkit-backup-$(Get-Date -Format 'yyyyMMdd_HHmmssfff')"
        Copy-Item -Path $HostsFilePath -Destination $BackupPath -Force
        Write-Info "Backup der Hosts-Datei erstellt: $BackupPath"

        Set-Content -Path $HostsFilePath -Value $FinalContent -Encoding ASCII
        Write-Success "$($Endpoints.Count) Telemetrie-Einträge in Hosts-Datei geschrieben."
    }

    return $Endpoints.Count
}

function Remove-TelemetryHostsEntries {
    <#
    .SYNOPSIS
        Entfernt den PrivacyToolkit-Telemetrie-Block wieder aus der
        Hosts-Datei (Rücksetzoption zu Add-TelemetryHostsEntries).
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$HostsFilePath = (Get-DefaultHostsPath)
    )

    if (-not (Test-Path $HostsFilePath)) {
        throw "Hosts-Datei nicht gefunden: $HostsFilePath"
    }

    $ExistingLines = Get-Content -Path $HostsFilePath
    $CleanLines = Remove-TelemetryMarkerBlock -Lines $ExistingLines

    if ($CleanLines.Count -eq $ExistingLines.Count) {
        Write-Info "Keine PrivacyToolkit-Telemetrie-Einträge in der Hosts-Datei gefunden."
        return 0
    }

    if ($PSCmdlet.ShouldProcess($HostsFilePath, "Telemetrie-Einträge entfernen")) {

        $BackupPath = "$HostsFilePath.privacytoolkit-backup-$(Get-Date -Format 'yyyyMMdd_HHmmssfff')"
        Copy-Item -Path $HostsFilePath -Destination $BackupPath -Force
        Write-Info "Backup der Hosts-Datei erstellt: $BackupPath"

        Set-Content -Path $HostsFilePath -Value $CleanLines -Encoding ASCII
        Write-Success "Telemetrie-Einträge aus Hosts-Datei entfernt."
    }

    return ($ExistingLines.Count - $CleanLines.Count)
}

function Get-TelemetryHostsEntries {
    <#
    .SYNOPSIS
        Liest die aktuell aktiven PrivacyToolkit-Einträge aus der
        Hosts-Datei aus (Status-Abfrage, keine Änderung).
    #>
    param(
        [string]$HostsFilePath = (Get-DefaultHostsPath)
    )

    if (-not (Test-Path $HostsFilePath)) {
        throw "Hosts-Datei nicht gefunden: $HostsFilePath"
    }

    $Lines = Get-Content -Path $HostsFilePath
    $InBlock = $false
    $Entries = New-Object System.Collections.Generic.List[object]

    foreach ($Line in $Lines) {
        if ($Line.Trim() -eq $script:MarkerStart) { $InBlock = $true; continue }
        if ($Line.Trim() -eq $script:MarkerEnd)   { $InBlock = $false; continue }

        if ($InBlock -and $Line.Trim()) {
            $Parts = $Line.Trim() -split '\s+', 2
            if ($Parts.Count -eq 2) {
                $Entries.Add([PSCustomObject]@{
                    RedirectTarget = $Parts[0]
                    Domain         = $Parts[1]
                })
            }
        }
    }

    return $Entries.ToArray()
}

Export-ModuleMember -Function Add-TelemetryHostsEntries, Remove-TelemetryHostsEntries, Get-TelemetryHostsEntries
