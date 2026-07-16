BeforeAll {
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Core\Logging.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Privacy\TelemetryEndpoints.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Firewall\HostsBlock.psm1") -Force

    Initialize-Logger -LogDirectory (Join-Path $TestDrive "Logs")

    $script:TelemetryConfig = Join-Path $TestDrive "TelemetryEndpoints.json"
    @'
[
  { "Domain": "vortex.data.microsoft.com", "Category": "Diagnostics", "Description": "Test" },
  { "Domain": "watson.telemetry.microsoft.com", "Category": "ErrorReporting", "Description": "Test" }
]
'@ | Set-Content -Path $script:TelemetryConfig
}

Describe "HostsBlock - Add-TelemetryHostsEntries" {

    BeforeEach {
        $script:HostsFile = Join-Path $TestDrive "hosts_$(Get-Random)"
        @"
127.0.0.1 localhost
::1 localhost
10.0.0.5 mein-server.local
"@ | Set-Content -Path $script:HostsFile
    }

    It "fügt die konfigurierten Domains als Redirect-Einträge hinzu" {
        $Count = Add-TelemetryHostsEntries -HostsFilePath $script:HostsFile -TelemetryConfigPath $script:TelemetryConfig
        $Count | Should -Be 2

        $Content = Get-Content $script:HostsFile -Raw
        $Content | Should -Match "0\.0\.0\.0\s+vortex\.data\.microsoft\.com"
        $Content | Should -Match "0\.0\.0\.0\s+watson\.telemetry\.microsoft\.com"
    }

    It "lässt die Datei bei -WhatIf unverändert" {
        $Before = Get-Content $script:HostsFile -Raw
        Add-TelemetryHostsEntries -HostsFilePath $script:HostsFile -TelemetryConfigPath $script:TelemetryConfig -WhatIf
        $After = Get-Content $script:HostsFile -Raw
        $After | Should -Be $Before
    }

    It "erhält bestehende Hosts-Einträge" {
        Add-TelemetryHostsEntries -HostsFilePath $script:HostsFile -TelemetryConfigPath $script:TelemetryConfig | Out-Null
        Get-Content $script:HostsFile -Raw | Should -Match "mein-server\.local"
    }

    It "legt vor der Änderung ein Backup an" {
        Add-TelemetryHostsEntries -HostsFilePath $script:HostsFile -TelemetryConfigPath $script:TelemetryConfig | Out-Null
        $Backups = Get-ChildItem -Path (Split-Path $script:HostsFile) -Filter "$(Split-Path $script:HostsFile -Leaf)*.privacytoolkit-backup-*"
        $Backups.Count | Should -BeGreaterThan 0
    }

    It "ist idempotent - mehrfaches Ausführen ändert die Zeilenzahl nicht" {
        Add-TelemetryHostsEntries -HostsFilePath $script:HostsFile -TelemetryConfigPath $script:TelemetryConfig | Out-Null
        $LinesAfterFirst = (Get-Content $script:HostsFile).Count

        1..3 | ForEach-Object {
            Add-TelemetryHostsEntries -HostsFilePath $script:HostsFile -TelemetryConfigPath $script:TelemetryConfig | Out-Null
        }
        $LinesAfterMore = (Get-Content $script:HostsFile).Count

        $LinesAfterMore | Should -Be $LinesAfterFirst
    }

    It "verwendet einen benutzerdefinierten RedirectTarget" {
        Add-TelemetryHostsEntries -HostsFilePath $script:HostsFile -TelemetryConfigPath $script:TelemetryConfig -RedirectTarget "127.0.0.1" | Out-Null
        Get-Content $script:HostsFile -Raw | Should -Match "127\.0\.0\.1\s+vortex\.data\.microsoft\.com"
    }

    It "wirft einen Fehler, wenn die Hosts-Datei nicht existiert" {
        $MissingPath = Join-Path $TestDrive "existiert-nicht"
        { Add-TelemetryHostsEntries -HostsFilePath $MissingPath -TelemetryConfigPath $script:TelemetryConfig } | Should -Throw
    }
}

Describe "HostsBlock - Remove-TelemetryHostsEntries" {

    BeforeEach {
        $script:HostsFile = Join-Path $TestDrive "hosts_remove_$(Get-Random)"
        @"
127.0.0.1 localhost
::1 localhost
10.0.0.5 mein-server.local
"@ | Set-Content -Path $script:HostsFile
    }

    It "entfernt einen vorhandenen Telemetrie-Block vollständig" {
        Add-TelemetryHostsEntries -HostsFilePath $script:HostsFile -TelemetryConfigPath $script:TelemetryConfig | Out-Null

        Remove-TelemetryHostsEntries -HostsFilePath $script:HostsFile | Out-Null

        $Content = Get-Content $script:HostsFile -Raw
        $Content | Should -Not -Match "vortex\.data\.microsoft\.com"
        $Content | Should -Match "mein-server\.local"
    }

    It "gibt 0 zurück, wenn kein Block vorhanden ist" {
        $Removed = Remove-TelemetryHostsEntries -HostsFilePath $script:HostsFile
        $Removed | Should -Be 0
    }

    It "lässt die Datei bei -WhatIf unverändert" {
        Add-TelemetryHostsEntries -HostsFilePath $script:HostsFile -TelemetryConfigPath $script:TelemetryConfig | Out-Null
        $Before = Get-Content $script:HostsFile -Raw

        Remove-TelemetryHostsEntries -HostsFilePath $script:HostsFile -WhatIf

        $After = Get-Content $script:HostsFile -Raw
        $After | Should -Be $Before
    }
}

Describe "HostsBlock - Get-TelemetryHostsEntries" {

    It "gibt die aktiven Einträge korrekt zurück" {
        $HostsFile = Join-Path $TestDrive "hosts_get_$(Get-Random)"
        "127.0.0.1 localhost" | Set-Content -Path $HostsFile

        Add-TelemetryHostsEntries -HostsFilePath $HostsFile -TelemetryConfigPath $script:TelemetryConfig | Out-Null

        $Entries = Get-TelemetryHostsEntries -HostsFilePath $HostsFile
        $Entries.Count | Should -Be 2
        ($Entries.Domain) | Should -Contain "vortex.data.microsoft.com"
    }

    It "gibt ein leeres Array zurück, wenn kein Block vorhanden ist" {
        $HostsFile = Join-Path $TestDrive "hosts_empty_$(Get-Random)"
        "127.0.0.1 localhost" | Set-Content -Path $HostsFile

        $Entries = @(Get-TelemetryHostsEntries -HostsFilePath $HostsFile)
        $Entries.Count | Should -Be 0
    }
}
