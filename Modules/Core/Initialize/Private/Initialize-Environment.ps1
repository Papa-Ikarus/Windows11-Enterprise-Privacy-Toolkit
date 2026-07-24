#Requires -Version 7.4

<#
.SYNOPSIS
    Initializes the runtime environment for the toolkit.

.DESCRIPTION
    Configures the PowerShell session to ensure consistent and predictable
    execution across all modules.

.NOTES
    This function is intended for internal use only.
#>

function Initialize-Environment {

    [CmdletBinding()]
    param()

    begin {

        Write-Verbose "Initializing runtime environment..."

    }

    process {

        # Enforce strict coding rules
        Set-StrictMode -Version Latest

        # Stop immediately on non-terminating errors
        $Global:ErrorActionPreference = 'Stop'

        # Use UTF-8 output
        [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

        # Use invariant culture for predictable formatting
        $Global:PSCulture = [System.Globalization.CultureInfo]::InvariantCulture.Name
        $Global:PSUICulture = [System.Globalization.CultureInfo]::InvariantCulture.Name

    }

    end {

        Write-Verbose "Runtime environment initialized."

    }

}
