<#
.SYNOPSIS
    Check for and shows a daily art feed in the console.
.DESCRIPTION
    Display a daily art inside the console using Out-ConsolePicture. The pictures are pulled from a reddit subreddit as a back end feed.

    The cmdlet only considers posts that have a direct link to an image. If the image is via a media preview or is a text post it will be ignored.
.EXAMPLE
    Show-DailyArt 

    Displays either the cached or a new picture.
.EXAMPLE
    Show-DailyArt -Refresh -IncludeDescription

    Forces a download of a new picture and display it in the console. It will also include the title of the post.
.PARAMETER Refresh
    Will ignore the cached picture and download a new daily image.

.PARAMETER IncludeDescription
    Include a short line with the title of the source post.

.NOTES
    The cmdlet requires the module OutConsolePicture to work.
#>

function Show-DailyArt {
    [CmdletBinding()]
    param (
        [Alias('Force')]
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