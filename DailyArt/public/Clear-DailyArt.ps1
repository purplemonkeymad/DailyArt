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