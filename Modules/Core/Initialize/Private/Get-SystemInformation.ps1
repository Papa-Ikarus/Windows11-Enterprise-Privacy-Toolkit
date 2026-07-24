#Requires -Version 7.4

<#
.SYNOPSIS
    Collects system information required by the toolkit.

.DESCRIPTION
    Retrieves operating system and PowerShell information used during
    toolkit initialization and environment validation.

.NOTES
    Internal function.
#>

function Get-SystemInformation {

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param()

    begin {

        Write-Verbose 'Collecting system information.'

    }

    process {

        try {

            $OperatingSystem = Get-CimInstance `
                -ClassName Win32_OperatingSystem `
                -ErrorAction Stop

            $ComputerSystem = Get-CimInstance `
                -ClassName Win32_ComputerSystem `
                -ErrorAction Stop

            [PSCustomObject]@{

                ComputerName       = $env:COMPUTERNAME

                UserName           = $env:USERNAME

                PowerShellVersion  = $PSVersionTable.PSVersion.ToString()

                PowerShellEdition  = $PSVersionTable.PSEdition

                OperatingSystem    = $OperatingSystem.Caption

                Version            = $OperatingSystem.Version

                BuildNumber        = $OperatingSystem.BuildNumber

                Architecture       = $OperatingSystem.OSArchitecture

                Manufacturer       = $ComputerSystem.Manufacturer

                Model              = $ComputerSystem.Model

                WindowsDirectory   = $env:windir

                SystemDrive        = $env:SystemDrive

                Culture            = (Get-Culture).Name

                UICulture          = (Get-UICulture).Name

                TimeZone           = (Get-TimeZone).Id

                IsAdministrator    = (
                    [Security.Principal.WindowsPrincipal] `
                    [Security.Principal.WindowsIdentity]::GetCurrent()
                ).IsInRole(
                    [Security.Principal.WindowsBuiltInRole]::Administrator
                )

                Timestamp          = Get-Date

            }

        }
        catch {

            throw "Unable to collect system information. $($_.Exception.Message)"

        }

    }

    end {

        Write-Verbose 'System information successfully collected.'

    }

}
