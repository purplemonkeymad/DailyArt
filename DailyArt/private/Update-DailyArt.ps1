function Update-DailyArt {
    [CmdletBinding()]
    param (
        [switch]$Refresh
    )
    
    begin {
    }
    
    process {
    }
    
    end {
        Write-Verbose "Starting Update Check"
        $Settings = Get-DailyArtSettings
        if (-not $settings.Subreddit) {
            # required settings value
            $PSCmdlet.ThrowTerminatingError(
                ( New-Object System.Management.Automation.ErrorRecord -ArgumentList @(
                    [System.Management.Automation.RuntimeException]'No subreddit for the feed specified.',
                    'DailyArt.NoSubreddit',
                    [System.Management.Automation.ErrorCategory]::InvalidData,
                    $null
                    )
                )
            )
        }

        if  ( $Refresh -or
              (-not (Test-Path -LiteralPath $CacheFiles.Info) ) -or
              ( (Get-Item -LiteralPath $CacheFiles.Info).LastWriteTime -lt ( (Get-Date) - $Settings.MaxAge ) )
            ) {
            # If we are forced, the cache file is missing, or the cache file is too old.
            # do update

            [uri]$FeedUri = "https://api.reddit.com/r/{0}/{1}?raw_json=1" -f $Settings.Subreddit,$Settings.SortType
            if ($FeedUri) {
                $Value = Invoke-RestMethod $FeedUri -Method Get
                if (-not $Value) {
                    Write-Error "Unable to get art feed."
                    return
                }

                # remove posts that we don't want from results

                $PostList = $Value.Data.Children.Data | 
                    Where-Object is_self -eq $false | # self text is not an image
                    Where-Object stickied -eq $false | # if we don't remove them will will always get them.
                    Where-Object media -eq $null | # is a card 
                    Where-Object author -NotIn $settings.IgnoreUsername |
                    Where-Object {
                        ([uri]$_.url | Split-Path -Leaf) -like '*.*' # url must have an extention in it.
                    }
                if ($PostList.Count -eq 0){
                    Write-Warning "No link posts in feed, nothing to update."
                    return
                }

                $Post = $PostList | Select-Object -First 1

                $newPostInfo = [DaItem]@{
                    URI = $Post.url
                    FileName = Split-Path ([uri]$Post.url).LocalPath -Leaf
                    Poster = $Post.author
                    CommentsUri = "https://www.reddit.com{0}" -f $Post.permalink
                    Description = $Post.title
                }

                # create cahce folder
                if (-not (Test-Path -LiteralPath $FileCacheFolder)) {
                    [void] ( New-Item -Path $FileCacheFolder -ItemType Directory -Force)
                }

                $CurrentInfo = Get-DailyArtInfo -WarningAction SilentlyContinue
                if ($CurrentInfo){
                    Remove-Item -LiteralPath (Join-Path $FileCacheFolder $CurrentInfo.FileName) -ErrorAction Ignore
                }
                try {
                    Start-BitsTransfer -Source $newPostInfo.uri -Destination (Join-Path $FileCacheFolder $newPostInfo.FileName) -Description "Downloading new art file." -ErrorAction Stop
                    $newPostInfo | ConvertTo-Json | Set-Content -LiteralPath $CacheFiles.Info -Force 
                } catch {
                    throw $_
                }

            }
        }
    }
}