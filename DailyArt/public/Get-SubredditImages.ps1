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
    [CmdletBinding(SupportsShouldProcess)]
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
        [switch]$IncludeAllTitles,
        [switch]$SaveMetaData,
        [switch]$UseRedditName

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
        $Settings = Get-DailyArtSettings
        $PageCounter = $PageCount
        $seenCount = 0
        $MatchingPosts = do {

            # assigning outside of the do loop allows pagnation to be coded inside
            # and allow PS to auto complie the results we output.

            $uri = if ($LastItem){
                "https://api.reddit.com/r/$Subreddit/?count=$seenCount&after=$LastItem"
            } else {
                "https://api.reddit.com/r/$Subreddit/"
            }

            $SRFeed = Invoke-RestMethod -Uri $uri
            if (-not $SRFeed.data.children){
                Write-Error "Cannot read post data"
                return
            }
            $Posts = $SRFeed.data.children | Where-Object kind -eq 't3' | ForEach-Object data -WhatIf:$false
            $Posts.where({
                ([bool]$IncludeAllTitles -or # include all titles
                ($_.title -Match "\d+\s*[x*\u00D7]\s*\d+")) -and # has number x number in title
                ([bool]$_.gallery_data -or # is a gallery
                [bool]($_.url -like 'https://www.reddit.com/gallery/*') -or # alt gallery detection.
                $_.url -match "(\.png|.jpg|.jpeg)(\?.+)?$") -and # is a direct link to image
                ([bool]$IncludeNSFW -or # accept nsfw
                (-not $_.over_18)) -and # ain't a nsfw post
                ($_.author -NotIn $settings.IgnoreUsername) # user blacklist
            }) # let valid posts fall into variable

            # setup info required to get next page.
            $LastItem = $SRFeed.data.after
            $PageCounter--
            $seenCount += $SRFeed.data.dist


        } until ($PageCounter -lt 1)

        if ($MatchingPosts.count -eq 0){
            Write-Error "No valid matching posts found."
            return
        }

        if ($ClearTargetFolder){
            Get-ChildItem -LiteralPath $Path | Where-Object Extension -in @('.jpg','.png','jpeg') | Remove-Item
            if ($SaveMetaData){
                Get-ChildItem -LiteralPath $Path | Where-Object Extension -in @('.json') | Remove-Item
            }
        }

        $MatchingPosts | ForEach-Object {
            # the replace regex '\?.*$' removes the first question mark to the end of the string
            # this is to remove any query strings from the uri, this is just for the cheap determining of the name

            if ($_.gallery_data -or [bool]($_.url -like 'https://www.reddit.com/gallery/*')) {
                # gallery link
                Write-Verbose "Found a gallery post $($_.url)"

                $gallery = $_

                $outImages = Convert-GalleryToUri $_ | Convert-UriToFilename
                $OutputFile = $outImages | ForEach-Object {
                    $filename = if ($UseRedditName) { 
                        '{0}_{1}' -f $gallery.name,$_.filename # we prefix the name here so a json will match the prefix.
                    } else {
                        (Split-Path ($_.url -replace '\?.*$') -Leaf)
                    }
                    $outPath = Join-Path $Path $filename
                    if (-not (Test-Path $outPath -PathType Leaf)){
                        if ($PSCmdlet.ShouldProcess($_.uri , "Download Gallery Image $($gallery.name), with title $($gallery.title), and image name $($_.filename) to $outPath")){
                            Save-ImageTo -Uri $_.uri -Path $outPath #  the object here should fall to Outputfile
                        }
                    }
                }
                # we use contains in the check as OutputFile is probably more than one file, if any are true we want to continue.
                if ($SaveMetaData -and ($OutputFile.Success -contains $true)){
                    # this should save the info with the same name but different extension.
                    $jsonout =  if ($UseRedditName) {
                        ( Join-path $Path $gallery.name ) +'.json'
                    } else {
                        ( Join-path $Path ( Split-Path $gallery.url -Leaf) ) +'.json'
                    }
                    $gallery | ConvertTo-Json -Depth 20 | Set-Content $jsonout
                }
            } else {
                Write-Verbose "Downloading single link $($_.url)"
                $outPath = if ($UseRedditName) { 
                    $ext = ($_.url -replace '\?.*$') -split '\.' | Select-Object -Last 1
                    if (-not $ext) { $ext = 'jpg'} # default guess
                    (Join-Path $Path (Split-Path ($_.name) -Leaf)) + '.' + $ext
                } else {
                    (Join-Path $Path (Split-Path ($_.url -replace '\?.*$') -Leaf))
                }
                if (-not (Test-Path $outPath -PathType Leaf)){
                    if ($PSCmdlet.ShouldProcess($_.url , "Download $($_.name), with title $($_.title) to $outPath")){
                        $OutputFile = Save-ImageTo -Uri $_.url -Path $outPath
                        if ($SaveMetaData -and $OutputFile.Success){
                            # this should save the info with the same name but different extension.
                            $jsonout =  ( Join-path $OutputFile.File.Directory $OutputFile.File.basename ) +'.json'
                            $_ | ConvertTo-Json -Depth 20 | Set-Content $jsonout
                        }
                    }
                } else {
                    Write-Verbose "File already exists, skipping."
                }
            }
        }
    }
}