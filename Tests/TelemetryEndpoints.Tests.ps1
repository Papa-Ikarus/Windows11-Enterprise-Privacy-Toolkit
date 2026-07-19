BeforeAll {
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Core\Logging.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Privacy\TelemetryEndpoints.psm1") -Force

    Initialize-Logger -LogDirectory (Join-Path $TestDrive "Logs")

    # Kleine, isolierte Test-Konfigurationsdateien statt der echten
    # Config/*.json, damit die Tests unabhängig vom Datenstand sind.
    $script:TelemetryConfig = Join-Path $TestDrive "TelemetryEndpoints.json"
    $script:EssentialConfig = Join-Path $TestDrive "EssentialEndpoints.json"

    @'
[
  { "Domain": "vortex.data.microsoft.com", "Category": "Diagnostics", "Description": "Test-Diagnose-Endpunkt" },
  { "Domain": "watson.telemetry.microsoft.com", "Category": "ErrorReporting", "Description": "Test-Absturzbericht-Endpunkt" }
]
'@ | Set-Content -Path $script:TelemetryConfig

    @'
[
  { "Domain": "login.microsoftonline.com", "Category": "MicrosoftLogin", "Description": "Test-Login-Endpunkt" },
  { "Domain": "update.microsoft.com", "Category": "WindowsUpdate", "Description": "Test-Update-Endpunkt" }
]
'@ | Set-Content -Path $script:EssentialConfig
}

Describe "TelemetryEndpoints - Get-TelemetryEndpoints" {

    It "gibt alle Einträge zurück, wenn keine Kategorie angegeben ist" {
        $Result = Get-TelemetryEndpoints -ConfigPath $script:TelemetryConfig
        $Result.Count | Should -Be 2
    }

    It "filtert korrekt nach Kategorie" {
        $Result = Get-TelemetryEndpoints -ConfigPath $script:TelemetryConfig -Category "ErrorReporting"
        $Result.Count | Should -Be 1
        $Result[0].Domain | Should -Be "watson.telemetry.microsoft.com"
    }

    It "wirft einen Fehler, wenn die Konfigurationsdatei fehlt" {
        { Get-TelemetryEndpoints -ConfigPath (Join-Path $TestDrive "nicht-vorhanden.json") } | Should -Throw
    }
}

Describe "TelemetryEndpoints - Get-EssentialEndpoints" {

    It "gibt alle Whitelist-Einträge zurück" {
        $Result = Get-EssentialEndpoints -ConfigPath $script:EssentialConfig
        $Result.Count | Should -Be 2
    }

    It "filtert korrekt nach Kategorie" {
        $Result = Get-EssentialEndpoints -ConfigPath $script:EssentialConfig -Category "WindowsUpdate"
        $Result.Count | Should -Be 1
        $Result[0].Domain | Should -Be "update.microsoft.com"
    }
}

Describe "TelemetryEndpoints - Test-TelemetryWhitelistConflict" {

    It "meldet keine Konflikte, wenn die Listen disjunkt sind" {
        $Conflicts = Test-TelemetryWhitelistConflict -TelemetryConfigPath $script:TelemetryConfig -EssentialConfigPath $script:EssentialConfig
        $Conflicts.Count | Should -Be 0
    }

    It "erkennt einen Konflikt, wenn eine Domain in beiden Listen steht" {
        $ConflictingTelemetryConfig = Join-Path $TestDrive "TelemetryEndpoints-Conflict.json"

        @'
[
  { "Domain": "vortex.data.microsoft.com", "Category": "Diagnostics", "Description": "Test" },
  { "Domain": "update.microsoft.com", "Category": "Diagnostics", "Description": "Fälschlicherweise als Telemetrie gelistet" }
]
'@ | Set-Content -Path $ConflictingTelemetryConfig

        $Conflicts = Test-TelemetryWhitelistConflict -TelemetryConfigPath $ConflictingTelemetryConfig -EssentialConfigPath $script:EssentialConfig

        $Conflicts.Count | Should -Be 1
        $Conflicts | Should -Contain "update.microsoft.com"
    }
}

Describe "TelemetryEndpoints - reale Konfigurationsdateien im Repo" {

    BeforeAll {
        $script:RealTelemetryConfig = Join-Path $PSScriptRoot "..\Config\TelemetryEndpoints.json"
        $script:RealEssentialConfig = Join-Path $PSScriptRoot "..\Config\EssentialEndpoints.json"
    }

    It "Config/TelemetryEndpoints.json ist gültiges JSON mit mindestens einem Eintrag" {
        $Result = Get-TelemetryEndpoints -ConfigPath $script:RealTelemetryConfig
        $Result.Count | Should -BeGreaterThan 0
    }

    It "Config/EssentialEndpoints.json ist gültiges JSON mit mindestens einem Eintrag" {
        $Result = Get-EssentialEndpoints -ConfigPath $script:RealEssentialConfig
        $Result.Count | Should -BeGreaterThan 0
    }

    It "es gibt keine Überschneidung zwischen echter Telemetrie-Liste und echter Whitelist" {
        $Conflicts = Test-TelemetryWhitelistConflict -TelemetryConfigPath $script:RealTelemetryConfig -EssentialConfigPath $script:RealEssentialConfig
        $Conflicts.Count | Should -Be 0
    }
}
