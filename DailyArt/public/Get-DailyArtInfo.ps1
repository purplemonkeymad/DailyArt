function Get-DailyArtInfo {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
    }
    
    end {
        if (Test-Path -LiteralPath $CacheFiles.Info){
            [DaItem](Get-Content $CacheFiles.Info | ConvertFrom-Json)
        } else {
            Write-Warning "No Daily Art info found, have you run Show-DailyArt yet?"
        }
    }
}