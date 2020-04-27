class DASettings {
    
    #increment if any changes are made to the settings class
    [decimal]$SettingsVersion = 2
    
    # user specified subreddit to use for the feed
    [string]$Subreddit

    # Sorttype
    [ValidateSet('hot','new','random','rising','top','controversial')]
    [string]$SortType = 'hot'

    # how long do we cache the daily art for. (20h)
    [timespan]$MaxAge = "20:00:00.0"

    # if you don't want results from a set poster add them to this list.
    [string[]]$IgnoreUsername = @()

}