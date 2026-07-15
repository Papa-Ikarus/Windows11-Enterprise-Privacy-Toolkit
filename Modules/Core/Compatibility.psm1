Set-StrictMode -Version Latest

function Get-WindowsRelease {
    <#
    .SYNOPSIS
        Liefert Informationen zur installierten Windows-Version/Edition/Build.

    .DESCRIPTION
        Liest die relevanten Werte aus der Registry
        (HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion).
        Fällt bei fehlendem Zugriff auf "Unknown"-Werte zurück,
        statt das Skript hart abbrechen zu lassen.
    #>
    param()

    $RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'

    try {

        $Reg = Get-ItemProperty -Path $RegPath -ErrorAction Stop

        [PSCustomObject]@{
            ProductName    = $Reg.ProductName
            DisplayVersion = $Reg.DisplayVersion
            CurrentBuild   = $Reg.CurrentBuild
            UBR            = $Reg.UBR
            EditionID      = $Reg.EditionID
        }

    }
    catch {

        [PSCustomObject]@{
            ProductName    = 'Unknown'
            DisplayVersion = 'Unknown'
            CurrentBuild   = 'Unknown'
            UBR            = 'Unknown'
            EditionID      = 'Unknown'
        }

    }
}

Export-ModuleMember -Function Get-WindowsRelease
