Import-Module "$ScriptRoot\Modules\Core\Common.psm1" -Force
Import-Module "$ScriptRoot\Modules\Core\Logging.psm1" -Force
Import-Module "$ScriptRoot\Modules\Core\SystemCheck.psm1" -Force

Initialize-Toolkit
Initialize-Logger

Write-Info "Windows11 Enterprise Privacy Toolkit starting..."

Start-SystemCheck