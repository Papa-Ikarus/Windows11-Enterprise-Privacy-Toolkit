Set-StrictMode -Version Latest

function Test-IsAdministrator {
    <#
    .SYNOPSIS
        Prüft, ob das aktuelle PowerShell-Fenster mit Administratorrechten läuft.
    #>
    param()

    $CurrentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = New-Object Security.Principal.WindowsPrincipal($CurrentIdentity)

    return $Principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Start-SystemCheck {
    <#
    .SYNOPSIS
        Führt Pre-Flight-Checks aus (Admin-Rechte, Windows-Edition/Build,
        PowerShell-Version) und protokolliert das Ergebnis.

    .OUTPUTS
        [bool] $true, wenn alle notwendigen Checks bestanden wurden.
    #>
    param()

    $AllChecksPassed = $true

    # --- Administratorrechte ---
    if (Test-IsAdministrator) {
        Write-Success "Administratorrechte: OK"
    }
    else {
        Write-ErrorLog "Administratorrechte: FEHLEN. Bitte PowerShell als Administrator starten."
        $AllChecksPassed = $false
    }

    # --- Windows-Version/Edition ---
    $Release = Get-WindowsRelease

    Write-Info "Windows Edition: $($Release.ProductName)"
    Write-Info "Windows Version: $($Release.DisplayVersion)"
    Write-Info "Build: $($Release.CurrentBuild).$($Release.UBR)"

    if ($Release.ProductName -notlike "*Enterprise*") {
        Write-WarningLog "Dieses Toolkit ist gegen Windows 11 Enterprise getestet. Erkannt: $($Release.ProductName)"
    }

    # --- PowerShell-Version ---
    $PSVersion = $PSVersionTable.PSVersion
    Write-Info "PowerShell Version: $PSVersion"

    if ($PSVersion.Major -lt 5) {
        Write-ErrorLog "PowerShell 5.1+ wird benötigt. Erkannt: $PSVersion"
        $AllChecksPassed = $false
    }

    # --- Ergebnis ---
    if ($AllChecksPassed) {
        Write-Success "Systemprüfung erfolgreich."
    }
    else {
        Write-ErrorLog "Systemprüfung fehlgeschlagen. Siehe Meldungen oben."
    }

    return $AllChecksPassed
}

Export-ModuleMember -Function Start-SystemCheck, Test-IsAdministrator
