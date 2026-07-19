Set-StrictMode -Version Latest

function Initialize-Toolkit {
    <#
    .SYNOPSIS
        Initialisiert globalen Zustand des Toolkits.

    .DESCRIPTION
        Prüft PowerShell-Mindestversion und setzt einheitliche
        Fehlerbehandlung (StrictMode, ErrorActionPreference), bevor
        die restlichen Module geladen/genutzt werden.
    #>
    param()

    Set-StrictMode -Version Latest

    if ($PSVersionTable.PSVersion.Major -lt 5) {
        throw "PowerShell 5.1 oder höher wird benötigt. Erkannt: $($PSVersionTable.PSVersion)"
    }

    $global:ToolkitInitialized = $true
}

Export-ModuleMember -Function Initialize-Toolkit
