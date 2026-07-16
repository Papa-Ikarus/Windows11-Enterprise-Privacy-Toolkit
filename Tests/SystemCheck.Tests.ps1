BeforeAll {
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Core\Logging.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Core\Compatibility.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "..\Modules\Core\SystemCheck.psm1") -Force

    Initialize-Logger -LogDirectory (Join-Path $TestDrive "Logs")
}

Describe "SystemCheck - Start-SystemCheck" {

    Context "wenn alle Voraussetzungen erfüllt sind" {

        BeforeEach {
            Mock Test-IsAdministrator { $true } -ModuleName SystemCheck
            Mock Get-WindowsRelease -ModuleName SystemCheck {
                [PSCustomObject]@{
                    ProductName    = 'Windows 11 Enterprise'
                    DisplayVersion = '24H2'
                    CurrentBuild   = '28000'
                    UBR            = '2340'
                    EditionID      = 'Enterprise'
                }
            }
        }

        It "gibt \$true zurück" {
            Start-SystemCheck | Should -BeTrue
        }
    }

    Context "wenn Administratorrechte fehlen" {

        BeforeEach {
            Mock Test-IsAdministrator { $false } -ModuleName SystemCheck
            Mock Get-WindowsRelease -ModuleName SystemCheck {
                [PSCustomObject]@{
                    ProductName    = 'Windows 11 Enterprise'
                    DisplayVersion = '24H2'
                    CurrentBuild   = '28000'
                    UBR            = '2340'
                    EditionID      = 'Enterprise'
                }
            }
        }

        It "gibt \$false zurück" {
            Start-SystemCheck | Should -BeFalse
        }
    }

    Context "wenn eine nicht unterstützte Edition erkannt wird" {

        BeforeEach {
            Mock Test-IsAdministrator { $true } -ModuleName SystemCheck
            Mock Get-WindowsRelease -ModuleName SystemCheck {
                [PSCustomObject]@{
                    ProductName    = 'Windows 11 Home'
                    DisplayVersion = '24H2'
                    CurrentBuild   = '28000'
                    UBR            = '2340'
                    EditionID      = 'Core'
                }
            }
        }

        It "warnt, gibt aber trotzdem \$true zurück (nur Admin/PS-Version sind hart)" {
            Start-SystemCheck | Should -BeTrue
        }
    }
}
