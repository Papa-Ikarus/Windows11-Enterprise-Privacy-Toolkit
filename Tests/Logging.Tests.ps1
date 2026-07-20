BeforeAll {
    $ModulePath = Join-Path $PSScriptRoot "..\Modules\Core\Logging.psm1"
    Import-Module $ModulePath -Force
}

Describe "Logging" {

    BeforeEach {
        $script:TestLogDir = Join-Path $TestDrive "Logs"
    }

    It "erstellt das Log-Verzeichnis, falls es nicht existiert" {
        Test-Path $script:TestLogDir | Should -BeFalse
        Initialize-Logger -LogDirectory $script:TestLogDir
        Test-Path $script:TestLogDir | Should -BeTrue
    }

    It "erstellt eine Log-Datei beim Initialisieren" {
        Initialize-Logger -LogDirectory $script:TestLogDir
        (Get-ChildItem -Path $script:TestLogDir -Filter "Toolkit_*.log").Count | Should -Be 1
    }

    It "schreibt eine INFO-Zeile über Write-Info in die Log-Datei" {
        Initialize-Logger -LogDirectory $script:TestLogDir
        Write-Info "Testnachricht"

        $LogFile = Get-ChildItem -Path $script:TestLogDir -Filter "Toolkit_*.log" | Select-Object -First 1
        $Content = Get-Content $LogFile.FullName -Raw

        $Content | Should -Match '\[INFO\].*Testnachricht'
    }

    It "schreibt unterschiedliche Log-Level mit korrektem Tag" {
        Initialize-Logger -LogDirectory $script:TestLogDir

        Write-Success "OK"
        Write-WarningLog "Achtung"
        Write-ErrorLog "Kaputt"
        Write-DebugLog "Details"

        $LogFile = Get-ChildItem -Path $script:TestLogDir -Filter "Toolkit_*.log" | Select-Object -First 1
        $Content = Get-Content $LogFile.FullName -Raw

        $Content | Should -Match '\[SUCCESS\].*OK'
        $Content | Should -Match '\[WARN\].*Achtung'
        $Content | Should -Match '\[ERROR\].*Kaputt'
        $Content | Should -Match '\[DEBUG\].*Details'
    }

    It "lehnt ungültige Log-Level ab (privates Write-Log)" {
        InModuleScope Logging {
            { Write-Log -Level "NOPE" -Message "x" } | Should -Throw
        }
    }
}
