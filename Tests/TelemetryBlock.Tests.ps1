BeforeAll {
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Core\Logging.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Privacy\TelemetryEndpoints.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Firewall\HostsBlock.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Firewall\FirewallRules.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Firewall\TelemetryBlock.psm1") -Force

    Initialize-Logger -LogDirectory (Join-Path $TestDrive "Logs")
}

Describe "TelemetryBlock - Block-TelemetryEndpoints" {

    Context "wenn die Whitelist-Prüfung einen Konflikt findet" {

        BeforeEach {
            Mock Test-TelemetryWhitelistConflict { @("update.microsoft.com") } -ModuleName TelemetryBlock
            Mock Add-TelemetryHostsEntries { 999 } -ModuleName TelemetryBlock
            Mock Add-TelemetryFirewallRules { 999 } -ModuleName TelemetryBlock
        }

        It "bricht ab und führt KEINE Blockier-Aktion aus" {
            { Block-TelemetryEndpoints -Method Both } | Should -Throw "*update.microsoft.com*"
            Should -Invoke Add-TelemetryHostsEntries -ModuleName TelemetryBlock -Times 0
            Should -Invoke Add-TelemetryFirewallRules -ModuleName TelemetryBlock -Times 0
        }
    }

    Context "wenn keine Konflikte vorliegen" {

        BeforeEach {
            Mock Test-TelemetryWhitelistConflict { @() } -ModuleName TelemetryBlock
            Mock Add-TelemetryHostsEntries { 30 } -ModuleName TelemetryBlock
            Mock Add-TelemetryFirewallRules { 30 } -ModuleName TelemetryBlock
        }

        It "ruft bei -Method Hosts nur die Hosts-Funktion auf" {
            $Result = Block-TelemetryEndpoints -Method Hosts
            $Result.HostsEntriesAdded | Should -Be 30
            $Result.FirewallRulesAdded | Should -Be 0
            Should -Invoke Add-TelemetryFirewallRules -ModuleName TelemetryBlock -Times 0
        }

        It "ruft bei -Method Firewall nur die Firewall-Funktion auf" {
            $Result = Block-TelemetryEndpoints -Method Firewall
            $Result.FirewallRulesAdded | Should -Be 30
            $Result.HostsEntriesAdded | Should -Be 0
            Should -Invoke Add-TelemetryHostsEntries -ModuleName TelemetryBlock -Times 0
        }

        It "ruft bei -Method Both beide Funktionen auf" {
            $Result = Block-TelemetryEndpoints -Method Both
            $Result.HostsEntriesAdded | Should -Be 30
            $Result.FirewallRulesAdded | Should -Be 30
        }
    }
}

Describe "TelemetryBlock - Unblock-TelemetryEndpoints" {

    BeforeEach {
        Mock Remove-TelemetryHostsEntries { 30 } -ModuleName TelemetryBlock
        Mock Remove-TelemetryFirewallRules { 5 } -ModuleName TelemetryBlock
    }

    It "ruft bei -Method Both beide Remove-Funktionen auf" {
        $Result = Unblock-TelemetryEndpoints -Method Both
        $Result.HostsEntriesRemoved | Should -Be 30
        $Result.FirewallRulesRemoved | Should -Be 5
    }

    It "ruft bei -Method Hosts nur Remove-TelemetryHostsEntries auf" {
        $Result = Unblock-TelemetryEndpoints -Method Hosts
        $Result.HostsEntriesRemoved | Should -Be 30
        $Result.FirewallRulesRemoved | Should -Be 0
        Should -Invoke Remove-TelemetryFirewallRules -ModuleName TelemetryBlock -Times 0
    }
}
