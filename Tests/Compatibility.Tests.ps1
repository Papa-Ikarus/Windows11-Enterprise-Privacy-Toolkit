BeforeAll {
    $ModulePath = Join-Path $PSScriptRoot "..\Modules\Core\Compatibility.psm1"
    Import-Module $ModulePath -Force
}

Describe "Compatibility - Get-WindowsRelease" {

    It "gibt ein Objekt mit den erwarteten Eigenschaften zurück" {
        $Result = Get-WindowsRelease

        $Result.PSObject.Properties.Name | Should -Contain 'ProductName'
        $Result.PSObject.Properties.Name | Should -Contain 'DisplayVersion'
        $Result.PSObject.Properties.Name | Should -Contain 'CurrentBuild'
        $Result.PSObject.Properties.Name | Should -Contain 'UBR'
        $Result.PSObject.Properties.Name | Should -Contain 'EditionID'
    }

    It "fällt bei fehlendem Registry-Zugriff auf 'Unknown' zurück, statt zu werfen" {
        Mock Get-ItemProperty { throw "Registry nicht verfügbar (Testumgebung)" } -ModuleName Compatibility

        { Get-WindowsRelease } | Should -Not -Throw

        $Result = Get-WindowsRelease
        $Result.ProductName | Should -Be 'Unknown'
        $Result.DisplayVersion | Should -Be 'Unknown'
    }
}
