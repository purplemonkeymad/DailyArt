function Get-DailyArtSettings {
    [CmdletBinding()]
    param (

    )
    
    begin {
    }
    
    process {
    }
    
    end {
        if (Test-Path -LiteralPath $SettingsPath){
            [DASettings](Import-Clixml $SettingsPath)
        }
        else {
            [DASettings]::new()
        }
    }
}