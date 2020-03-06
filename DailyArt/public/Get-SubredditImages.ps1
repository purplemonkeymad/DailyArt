<#
.SYNOPSIS
Download a subreddit's first page images to a folder.

.DESCRIPTION
This takes a subreddit and look at the posts on the first page. If the post has a resolution in the title (digitxdigit) and is a direct link, it will download the image.

.PARAMETER Subreddit
Subreddit Name to download images from.

.Parameter Path
Folder Path to save the images into.

.Parameter IncludeNSFW
By default the command will now download images that are marked as over 18, use this switch to include them as well.

.Parameter ClearTargetFolder
This will delete any image files in the target folder. Use this when you want to only have the current top in the folder.

.EXAMPLE
Get-SubredditImages -Subreddit wallpapers -Path $env:localappdata\Wallpapers\ -ClearTargetFolder

This will update the images in the target path with the top first page posts from r/wallpapers. It will remove the previous top when it does so.
.NOTES

This was made for keeping a folder up-to-date with new wallpapers for slideshows etc.
#>

function Get-SubredditImages {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]
        [ValidateScript({
            if (-not (
                # ref https://github.com/reddit-archive/reddit/blob/753b17407e9a9dca09558526805922de24133d53/r2/r2/models/subreddit.py#L114
                $_ -match '\A[A-Za-z0-9][A-Za-z0-9_]{2,20}\Z'
            )) {
                throw "Subreddits can only contains letters, numbers or underscores."
            }
            $true
        })]
        $Subreddit,
        [parameter(Mandatory)]
        $Path,
        [ValidateRange(1,[int32]::MaxValue)]
        [int]$PageCount = 1,
        [switch]$IncludeNSFW,
        [switch]$ClearTargetFolder,
        [switch]$IncludeAllTitles

    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        # accept filesystem items as well as strings.
        if ($Path.Fullname){
            $Path = $Path.Fullname
        }
        $PageCounter = $PageCount
        do {

            $uri = if ($LastItem){
                "https://api.reddit.com/r/$Subreddit/?count=25&after=$LastItem"
            } else {
                "https://api.reddit.com/r/$Subreddit/"
            }

            $SRFeed = Invoke-RestMethod -Uri $uri
            if (-not $SRFeed.data.children){
                Write-Error "Cannot read post data"
                return
            }
            $Posts = $SRFeed.data.children | Where-Object kind -eq 't3' | ForEach-Object data
            $MatchingPosts = $Posts.where({
                ([bool]$IncludeAllTitles -or # include all titles
                ($_.title -Match "\d+\s*(x|\*)\s*\d+")) -and # has number x number in title
                $_.url -match "(\.png|.jpg|.jpeg)(\?.+)?$" -and # is a direct link to image
                ([bool]$IncludeNSFW -or # accept nsfw
                (-not $_.over_18)) # ain't a nsfw post
            })

            if ($MatchingPosts.count -eq 0){
                Write-Error "No valid matching posts found."
                return
            }

            if ($ClearTargetFolder){
                Get-ChildItem -LiteralPath $Path | Where-Object Extension -in @('.jpg','.png','jpeg') | Remove-Item
            }

            $MatchingPosts | ForEach-Object {
                $outPath = (Join-Path $Path (Split-Path ($_.url -replace '\?.*$') -Leaf))
                if (-not (Test-Path $outPath -PathType Leaf)){
                    Invoke-WebRequest $_.url -OutFile $outPath -UseBasicParsing
                }
            }

            # setup info required to get next page.
            $LastItem = $SRFeed.data.children[-1].data.name
            $PageCounter--


        } until ($PageCounter -lt 1)
    }
}