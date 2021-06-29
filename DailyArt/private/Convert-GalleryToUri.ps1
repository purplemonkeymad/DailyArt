function Convert-GalleryToUri {
    [CmdletBinding()]
    param (
        [parameter(Mandatory,ValueFromPipeline)]
        $t3Data
    )
    
    begin {
        
    }
    
    process {
        foreach($t3SingleData in $t3Data) {

            # test gallery data exists
            if (-not ($t3SingleData.gallery_data -or [bool]($t3SingleData.url -like 'https://www.reddit.com/gallery/*'))) {
                Write-Error "Object does not appear to be a gallery, $($_.name)"
                return
            }

            # sort the gallery data by id to ensure the order is correct
            $GalleryItems = if ($t3SingleData.gallery_data.items){
                $t3SingleData.gallery_data.items | Sort-Object id | ForEach-Object media_id | ForEach-Object {
                    $t3SingleData.media_metadata.$_
                }
            } else {
                Write-Verbose "Gallery appears to be missing order information, guessing."
                $t3SingleData.media_metadata.psobject.Properties.name | Sort-Object | ForEach-Object {
                    $t3SingleData.media_metadata.$_
                }
            }

            $GalleryItems | ForEach-Object {
                $gi = $_
                switch ($_.e) { # item type
                    'Image' {
                        [uri]$uri = [System.Web.HttpUtility]::HtmlDecode( # reddit api provides uris for galleries double escaped
                            $gi.s.u # select the url from the "s" type in the metadata (this should be the original picture)
                        )
                        [PSCustomObject]@{
                            uri = $uri
                            filename = Split-Path $uri.LocalPath -Leaf
                        }
                    }
                    'AnimatedImage' {
                        if ($gi.s.mp4){ # mp4 first
                            [uri]$uri = [System.Web.HttpUtility]::HtmlDecode( # reddit api provides uris for galleries double escaped
                                $gi.s.mp4 # select the url from the "s" type in the metadata (this should be the original picture)
                            )
                            $filename = Split-Path $uri.LocalPath -Leaf
                            if ($filename -notlike '*.mp4') {
                                $filename = "$filename.mp4"
                            }
                            [PSCustomObject]@{
                                uri = $uri
                                filename = $filename
                            }
                        } elseif ($gi.s.gif) {
                            [uri]$uri = [System.Web.HttpUtility]::HtmlDecode( # reddit api provides uris for galleries double escaped
                                $gi.s.gif # select the url from the "s" type in the metadata (this should be the original picture)
                            )
                            $filename = Split-Path $uri.LocalPath -Leaf
                            [PSCustomObject]@{
                                uri = $uri
                                filename = $filename
                            }
                        }
                    }
                    Default {
                        Write-Error "Unknown gallery type $_, please add a converter."
                    }
                }
                
            }

        }
    }
    
    end {
        
    }
}