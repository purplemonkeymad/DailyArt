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