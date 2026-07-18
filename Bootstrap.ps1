<#
.SYNOPSIS
    Haupteinstiegspunkt des Windows11-Enterprise-Privacy-Toolkit.

.DESCRIPTION
    Lädt die Core-Module, initialisiert Logging und Toolkit-Zustand,
    führt eine Systemprüfung durch und bricht kontrolliert ab, falls
    notwendige Voraussetzungen (Admin-Rechte, PowerShell-Version) fehlen.
#>

#Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

try {
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host " Windows11 Enterprise Privacy Toolkit" -ForegroundColor Cyan
    Write-Host " Bootstrap starting..." -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""

    . "$ScriptRoot\Config.ps1"

    Import-Module "$ScriptRoot\Modules\Core\Common.psm1" -Force
    Import-Module "$ScriptRoot\Modules\Core\Logging.psm1" -Force
    Import-Module "$ScriptRoot\Modules\Core\Compatibility.psm1" -Force
    Import-Module "$ScriptRoot\Modules\Core\SystemCheck.psm1" -Force
    Import-Module "$ScriptRoot\Modules\Core\Initialize.psm1" -Force
}
catch {
    Write-Host "FATAL: Module konnten nicht geladen werden." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

try {
    Initialize-Toolkit
    Initialize-Logger -LogDirectory (Join-Path $ScriptRoot "Logs")

    Write-Info "Windows11 Enterprise Privacy Toolkit startet..."
    Write-Info "Toolkit Version: $($Toolkit.Version)"

    $SystemCheckPassed = Start-SystemCheck

    if (-not $SystemCheckPassed) {
        Write-ErrorLog "Systemprüfung fehlgeschlagen. Abbruch."
        exit 1
    }

    Start-PrivacyToolkit

    Write-Success "Bootstrap erfolgreich abgeschlossen."
    exit 0
}
catch {
    Write-Host "FATAL: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
