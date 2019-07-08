<#
.SYNOPSIS
    List some short information about the current daily art image.
.DESCRIPTION
    Retrives the currently stored information on the current daily art image. Includes deatils like poster and full uri.
.EXAMPLE
    Get-DailyArtInfo
.OUTPUTS
    [DAItem] Object.
#>
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