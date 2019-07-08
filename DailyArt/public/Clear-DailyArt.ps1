<#
.SYNOPSIS
    Clears the currently stored daily art cache.
.DESCRIPTION
    Removes that cached info and file for the daily art. After running this Show-DailArt will have to download a new image before any art can be displayed.
.EXAMPLE
    Clear-DailyArt
#>
function Clear-DailyArt {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
    }
    
    end {
        $CurrentInfo = Get-DailyArtInfo -WarningAction SilentlyContinue
        if ($CurrentInfo){
            Remove-Item -LiteralPath (Join-Path $FileCacheFolder $CurrentInfo.FileName)
            Remove-Item -LiteralPath $CacheFiles.Info
        }
    }
}