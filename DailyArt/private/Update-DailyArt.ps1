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

            [uri]$FeedUri = "https://api.reddit.com/r/{0}/hot?raw_json=1" -f $Settings.Subreddit
            if ($FeedUri) {
                $Value = Invoke-RestMethod $FeedUri -Method Get
                if (-not $Value) {
                    Write-Error "Unable to get art feed."
                    return
                }

                $PostList = $Value.Data.Children.Data | 
                    Where-Object is_self -eq $false | 
                    Where-Object stickied -eq $false | 
                    Where-Object media -eq $null | 
                    Where-Object {
                        ([uri]$_.url | Split-Path -Leaf) -like '*.*'
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