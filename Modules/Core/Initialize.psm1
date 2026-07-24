@{

# Script module or binary module file associated with this manifest.
RootModule = 'Initialize.psm1'

# Version number of this module.
ModuleVersion = '1.0.0'

# Unique identifier for this module.
GUID = '<GENERATE-NEW-GUID>'

# Author of this module.
Author = 'Windows11 Enterprise Privacy Toolkit Contributors'

# Company or vendor.
CompanyName = 'Open Source'

# Copyright statement.
Copyright = '(c) 2026 Windows11 Enterprise Privacy Toolkit. All rights reserved.'

# Description of the module.
Description = 'Initializes the Windows11 Enterprise Privacy Toolkit runtime environment.'

# Minimum supported PowerShell version.
PowerShellVersion = '7.4'

# Processor architecture.
ProcessorArchitecture = 'None'

# Required modules.
RequiredModules = @()

# Required assemblies.
RequiredAssemblies = @()

# Scripts executed before module import.
ScriptsToProcess = @()

# Types to import.
TypesToProcess = @()

# Format definitions.
FormatsToProcess = @()

# Nested modules.
NestedModules = @()

# Functions exported by this module.
FunctionsToExport = @(
    'Initialize-Toolkit',
    'Get-InitializationStatus',
    'Test-ToolkitEnvironment'
)

# Cmdlets exported.
CmdletsToExport = @()

# Variables exported.
VariablesToExport = @()

# Aliases exported.
AliasesToExport = @()

# DSC resources.
DscResourcesToExport = @()

# Compatible PowerShell editions.
CompatiblePSEditions = @(
    'Core'
)

# Private module metadata.
PrivateData = @{

    PSData = @{

        Tags = @(
            'Windows11'
            'Enterprise'
            'Privacy'
            'Toolkit'
            'Core'
            'Initialization'
        )

        LicenseUri = ''

        ProjectUri = 'https://github.com/Papa-Ikarus/Windows11-Enterprise-Privacy-Toolkit'

        IconUri = ''

        ReleaseNotes = @'
Initial release of the Initialize Core module.

Provides:

- Environment initialization
- Runtime validation
- Toolkit startup
- System information collection
'@

        Prerelease = ''

        RequireLicenseAcceptance = $false

        ExternalModuleDependencies = @()

    }

}

}

#Requires -Version 7.4

<#
    Module: Initialize
    Description:
        Initializes the Windows11 Enterprise Privacy Toolkit runtime environment.

    Responsibilities:
        - Load all module functions
        - Initialize module environment
        - Export public functions

    Copyright:
        Windows11 Enterprise Privacy Toolkit

    SPDX-License-Identifier: MIT
#>

Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'

#region Module Paths

$ModuleRoot = $PSScriptRoot
$PublicPath = Join-Path $ModuleRoot 'Public'
$PrivatePath = Join-Path $ModuleRoot 'Private'

#endregion Module Paths

#region Helper Functions

function Import-ModuleFolder {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    Get-ChildItem -Path $Path -Filter '*.ps1' -File |
        Sort-Object Name |
        ForEach-Object {

            try {
                . $_.FullName
            }
            catch {

                throw "Failed to import module file '$($_.FullName)'. $($_.Exception.Message)"

            }

        }

}

#endregion Helper Functions

#region Load Private Functions

Import-ModuleFolder -Path $PrivatePath

#endregion

#region Load Public Functions

Import-ModuleFolder -Path $PublicPath

#endregion

#region Module Initialization

try {

    if (Get-Command Initialize-Environment -ErrorAction SilentlyContinue) {

        Initialize-Environment

    }

}
catch {

    throw "Module initialization failed. $($_.Exception.Message)"

}

#endregion

#region Export Public Functions

$PublicFunctions = @()

if (Test-Path -LiteralPath $PublicPath) {

    $PublicFunctions = Get-ChildItem `
        -Path $PublicPath `
        -Filter '*.ps1' `
        -File |
        Sort-Object Name |
        ForEach-Object {

            $_.BaseName

        }

}

Export-ModuleMember -Function $PublicFunctions

#endregion

