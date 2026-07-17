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

    # Core modules will be loaded here later.

}
catch {
    Write-Error $_
    exit 1
}
