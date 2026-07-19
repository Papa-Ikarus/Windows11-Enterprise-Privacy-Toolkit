BeforeAll {
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Core\Logging.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Privacy\TelemetryEndpoints.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Firewall\FirewallRules.psm1") -Force

    Initialize-Logger -LogDirectory (Join-Path $TestDrive "Logs")

    $script:TelemetryConfig = Join-Path $TestDrive "TelemetryEndpoints-Firewall_$(Get-Random).json"
    @'
[
  { "Domain": "vortex.data.microsoft.com", "Category": "Diagnostics", "Description": "Test" },
  { "Domain": "nicht-aufloesbar.invalid", "Category": "Diagnostics", "Description": "Test - absichtlich nicht aufloesbar" }
]
'@ | Set-Content -Path $script:TelemetryConfig
}

Describe "FirewallRules - Add-TelemetryFirewallRules" {

    Context "wenn NetSecurity-Cmdlets verfügbar sind (Windows/CI)" {

        BeforeEach {
            Mock New-NetFirewallRule { } -ModuleName FirewallRules
            Mock Get-NetFirewallRule { } -ModuleName FirewallRules
            Mock Remove-NetFirewallRule { } -ModuleName FirewallRules

            Mock Resolve-DnsName {
                if ($Name -eq "vortex.data.microsoft.com") {
                    return [PSCustomObject]@{ IPAddress = "13.107.4.50" }
                }
                throw "DNS_ERROR_RCODE_NAME_ERROR"
            } -ModuleName FirewallRules
        }

        It "erstellt eine Regel pro auflösbarer Domain" {
            $Created = Add-TelemetryFirewallRules -TelemetryConfigPath $script:TelemetryConfig
            $Created | Should -Be 1
            Should -Invoke New-NetFirewallRule -ModuleName FirewallRules -Times 1
        }

        It "überspringt nicht auflösbare Domains statt abzubrechen" {
            { Add-TelemetryFirewallRules -TelemetryConfigPath $script:TelemetryConfig } | Should -Not -Throw
        }

        It "legt bei -WhatIf keine Regel an" {
            Add-TelemetryFirewallRules -TelemetryConfigPath $script:TelemetryConfig -WhatIf
            Should -Invoke New-NetFirewallRule -ModuleName FirewallRules -Times 0
        }
    }

    Context "wenn NetSecurity nicht verfügbar ist (z.B. Linux)" {

        It "wirft einen aussagekräftigen Fehler statt eines kryptischen Command-Not-Found" {
            if (Get-Command New-NetFirewallRule -ErrorAction SilentlyContinue) {
                Set-ItResult -Skipped -Because "NetSecurity ist auf diesem System vorhanden"
                return
            }
            { Add-TelemetryFirewallRules -TelemetryConfigPath $script:TelemetryConfig } | Should -Throw "*NetSecurity*"
        }
    }
}

Describe "FirewallRules - Remove-TelemetryFirewallRules" {

    Context "wenn NetSecurity-Cmdlets verfügbar sind (Windows/CI)" {

        It "entfernt alle Regeln mit dem PrivacyToolkit-Präfix" {
            Mock Get-NetFirewallRule {
                @(
                    [PSCustomObject]@{ DisplayName = "PrivacyToolkit-Telemetry-vortex.data.microsoft.com" },
                    [PSCustomObject]@{ DisplayName = "PrivacyToolkit-Telemetry-watson.telemetry.microsoft.com" }
                )
            } -ModuleName FirewallRules
            Mock Remove-NetFirewallRule { } -ModuleName FirewallRules

            $Removed = Remove-TelemetryFirewallRules
            $Removed | Should -Be 2
        }

        It "gibt 0 zurück, wenn keine Regeln vorhanden sind" {
            Mock Get-NetFirewallRule { $null } -ModuleName FirewallRules

            $Removed = Remove-TelemetryFirewallRules
            $Removed | Should -Be 0
        }
    }
}
