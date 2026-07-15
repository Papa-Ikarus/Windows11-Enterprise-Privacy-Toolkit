Set-StrictMode -Version Latest

$script:LogFile = $null

function Initialize-Logger {

    param(
        [string]$LogDirectory = ".\Logs"
    )

    if (!(Test-Path $LogDirectory)) {

        New-Item `
            -ItemType Directory `
            -Path $LogDirectory `
            -Force | Out-Null

    }

    $script:LogFile = Join-Path `
        $LogDirectory `
        ("Toolkit_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".log")

    New-Item `
        -ItemType File `
        -Path $script:LogFile `
        -Force | Out-Null

    Write-Info "Logger initialized."
}

function Write-Log {

    param(

        [Parameter(Mandatory)]
        [ValidateSet(
            "INFO",
            "SUCCESS",
            "WARN",
            "ERROR",
            "DEBUG"
        )]
        [string]$Level,

        [Parameter(Mandatory)]
        [string]$Message

    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $Line = "[$Timestamp] [$Level] $Message"

    if ($script:LogFile) {

        Add-Content `
            -Path $script:LogFile `
            -Value $Line

    }

    switch ($Level) {

        "INFO" {

            Write-Host $Line -ForegroundColor Cyan

        }

        "SUCCESS" {

            Write-Host $Line -ForegroundColor Green

        }

        "WARN" {

            Write-Host $Line -ForegroundColor Yellow

        }

        "ERROR" {

            Write-Host $Line -ForegroundColor Red

        }

        "DEBUG" {

            Write-Host $Line -ForegroundColor DarkGray

        }

    }

}

function Write-Info {

    param([string]$Message)

    Write-Log `
        -Level INFO `
        -Message $Message

}

function Write-Success {

    param([string]$Message)

    Write-Log `
        -Level SUCCESS `
        -Message $Message

}

function Write-WarningLog {

    param([string]$Message)

    Write-Log `
        -Level WARN `
        -Message $Message

}

function Write-ErrorLog {

    param([string]$Message)

    Write-Log `
        -Level ERROR `
        -Message $Message

}

function Write-DebugLog {

    param([string]$Message)

    Write-Log `
        -Level DEBUG `
        -Message $Message

}

Export-ModuleMember `
    -Function `
    Initialize-Logger,
    Write-Info,
    Write-Success,
    Write-WarningLog,
    Write-ErrorLog,
    Write-DebugLog
    