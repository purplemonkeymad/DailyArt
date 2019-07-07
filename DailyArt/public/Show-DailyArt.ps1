function Show-DailyArt {
    [CmdletBinding()]
    param (
        [switch]$Refresh,
        [switch]$IncludeDescription
    )
    
    begin {
    }
    
    process {
    }
    
    end {
        
        # run updater
        Update-DailyArt -Refresh:$Refresh

        $ArtData = Get-DailyArtInfo
        if ($ArtData) {
            $file = Join-Path $FileCacheFolder $ArtData.FileName

            Out-ConsolePicture $file

            if ($IncludeDescription){
                Write-Host $ArtData.Description -ForegroundColor Green
            }

        }

    }
}