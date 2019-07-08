<#
.SYNOPSIS
    Open up the post that the daily art was pulled from.
.EXAMPLE
    Open-DailyArtComments
.NOTES
    Opens using the system association for https://
#>
function Open-DailyArtComments {
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
            Start-Process $info.commentsuri
        }
    }
}