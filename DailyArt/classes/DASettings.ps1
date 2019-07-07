class DASettings {
    
    #increment if any changes are made to the settings class
    [decimal]$SettingsVersion = 1
    
    # user specified subreddit to use for the feed
    [string]$Subreddit

    # how long do we cache the daily art for. (20h)
    [timespan]$MaxAge = "20:00:00.0"

}