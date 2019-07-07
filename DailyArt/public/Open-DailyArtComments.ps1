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