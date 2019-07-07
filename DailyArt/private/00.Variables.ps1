## internal variables for the module

## settings

$SettingsFolder = "$env:APPDATA/david@brettle.org.uk/DailyArt/"
if ($islinux) {
    $SettingsFolder = "~/.config/david@brettle.org.uk/DailyArt/"
}

$SettingsPath = Join-Path $SettingsFolder "Settings.xml"

## cache etc

$FileCacheFolder = "$env:LOCALAPPDATA/david@brettle.org.uk/DailyArt/"
if ($islinux) {
    $FileCacheFolder = "~/.cache/david@brettle.org.uk/DailyArt/"
}

$CacheFiles = @{
    Info = (Join-Path $FileCacheFolder "Info.json")
}