<#
.SYNOPSIS
    Open up the source url that the daily art was pulled from.
.EXAMPLE
    Open-DailyArt
.NOTES
    Opens using the system association for https://
#>
function Open-DailyArt {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
    }
    
    end {
        $Info = Get-DailyArtInfo
        if ($Info) {
            Start-Process $info.uri
        }
    }
}