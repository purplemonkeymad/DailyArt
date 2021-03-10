function Convert-UriToFilename {
    [CmdletBinding()]
    param (
        [parameter(Mandatory,ValueFromPipeline)]
        [uri]$uri
    )
    
    begin {
        
    }
    
    process {
        [PSCustomObject]@{
            uri = $uri
            filename = Split-Path $uri.LocalPath -Leaf
        }
    }
    
    end {
        
    }
}