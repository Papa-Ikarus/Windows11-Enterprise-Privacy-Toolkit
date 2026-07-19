BeforeAll {
    $ModulePath = Join-Path $PSScriptRoot "..\Modules\Core\Common.psm1"
    Import-Module $ModulePath -Force
}

Describe "Common - Initialize-Toolkit" {

    It "läuft ohne Fehler, wenn die PowerShell-Version >= 5 ist" {
        if ($PSVersionTable.PSVersion.Major -ge 5) {
            { Initialize-Toolkit } | Should -Not -Throw
        }
        else {
            Set-ItResult -Skipped -Because "Testumgebung nutzt PowerShell < 5"
        }
    }

    It "setzt \$global:ToolkitInitialized auf \$true" {
        $global:ToolkitInitialized = $false
        Initialize-Toolkit
        $global:ToolkitInitialized | Should -BeTrue
    }
}
