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
            if ($t3SingleData.gallery_data.items){
                $t3SingleData.gallery_data.items | Sort-Object id | ForEach-Object media_id | ForEach-Object {
                    [System.Web.HttpUtility]::HtmlDecode( # reddit api provides uris for galleries double escaped
                    $t3SingleData.media_metadata.$_.s.u # select the url from the "s" type in the metadata (this should be the original picture)
                    )
                }
            } else {
                Write-Verbose "Gallery appears to be missing order information, guessing."
                $t3SingleData.media_metadata.psobject.Properties.name | Sort-Object | ForEach-Object {
                    [System.Web.HttpUtility]::HtmlDecode( # reddit api provides uris for galleries double escaped
                    $t3SingleData.media_metadata.$_.s.u # select the url from the "s" type in the metadata (this should be the original picture)
                    )
                }
            }

        }
    }
    
    end {
        
    }
}