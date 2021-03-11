function Save-ImageTo {
    [CmdletBinding()]
    param (
        [parameter(Mandatory,ValueFromPipelineByPropertyName,
            HelpMessage="Full uri of image to download.")]
        [ValidateNotNullOrEmpty()]
        [uri]$uri,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,
            HelpMessage="Literal Path to save image to.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )
    
    begin {
        
    }
    
    process {
        Invoke-WebRequest $uri -OutFile $Path -UseBasicParsing
        $OutputFile = Get-Item $Path -ErrorAction SilentlyContinue

        #imgur does not 404 missing images but replaces them with the same image
        # we check if the size and has match the removed image.

        # the removed image is 503 bytes and has a sha 256 hash of
        # 9B5936F4006146E4E1E9025B474C02863C0B5614132AD40DB4B925A10E8BFBB9
        $BadHash = '9B5936F4006146E4E1E9025B474C02863C0B5614132AD40DB4B925A10E8BFBB9'

        if ($OutputFile.Length -eq 503) {
            # only do a hash if the length matches
            $FileHash = Get-FileHash $OutputFile.FullName | ForEach-Object Hash
            if ($BadHash -eq $FileHash){
                Remove-Item $OutputFile.FullName -ErrorAction SilentlyContinue
                # clear variable containing file so that further tests fail.
                $OutputFile = $null
            }
        }

        [PSCustomObject]@{
            File = $OutputFile
            Success = [bool]$OutputFile
        }
    }
    
    end {
        
    }
}