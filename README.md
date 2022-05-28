# DailyArt

PS module that shows daily art from a subreddit.

## About

This module will download the top post (that contains an image) from a configured subreddit. It will then display that image inside the console.

Thanks to the OutConsolePicture module the image will be displayed using coloured console characters. This tends to give the images a blocky look. It is recommended to not choose a subreddit with high detail images (such as r/pixelart) as they scaling usually destroys the details.

The images are cached so that it should not cause the profile to be tool slow all the time. However since updates are delayed you might get yesterday's image the first time you boot a console that day.

## Requirements

This module depends on the OutConsolePicture module by /u/NotNotWrongUsually.  You can install this module using the PSGallery:

    Install-Module OutConsolePicture

I have no intention of signing the code so an Execution Policy of RemoteSigned or lower is needed.

## Install

Not currently on the PSGallery so download and extract the code, then copy the DailyArt folder to a location in `$env:PSModulePath`. Doing so will allow module will auto load or import without needing the full path.

## Usage

First step is to configure a source subreddit to use as a feed. To use r/EarthPorn you would do the following:

    Set-DailyArtSettings -Subreddit earthporn

Now you only need to show the art with one command.

    Show-DailyArt

Next I add the following into my `$profile` file so that it appears every time I start a shell:

    Show-DailyArt -IncludeDescription

If you want new images more frequently you can modify the cache time in the settings:

    Set-DailyArtSettings -MaxAge '6:00:00' # 6 hours

Keep in mind you might get the same image if the top post has not changed on your selected subreddit.

## Known Issues

* There is a rare race condition with the delayed download, when reading and writing the cached details happens at the same time.  
* On rare occasions the BITS progress overlaps the displayed image, this causes the characters under it to lose their ansi codes.  