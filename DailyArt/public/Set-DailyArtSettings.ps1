function Set-DailyArtSettings {
    [CmdletBinding()]
    param (
        
    )
    DynamicParam {
        # Create Parameters from object
        $BaseObject = [DASettings]::new()

        # final parameters
        $ParameterCollection = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

        ## for each propertie add a paramter
        foreach ($Property in ($BaseObject.psobject.properties) ) {

            if ($Property.Name -in @('SettingsVersion')){
                continue
            }

            $AttibureList = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            #[parameter()]
            $AttibureList.Add([System.Management.Automation.ParameterAttribute]@{
                ValueFromPipeline = $true
                Mandatory = $false
            })

            $ParameterCollection.Add(
                $Property.Name,
                [System.Management.Automation.RuntimeDefinedParameter]::new(
                    $Property.Name,
                    [type]$Property.TypeNameOfValue,
                    $AttibureList
                )
            )
        }

        return $ParameterCollection
    }
    
    begin {
        $CurrentSettings = Get-DailyArtSettings
    }
    
    process {
        foreach ($Parameter in $PSBoundParameters.GetEnumerator()) {
            if ($CurrentSettings.psobject.properties.name -contains $Parameter.Key) {
                $CurrentSettings.($Parameter.key) = $Parameter.Value
            }
        }
    }
    
    end {
        if (-not (Test-Path $SettingsPath)){
            [void](New-Item -Path $SettingsFolder -ItemType Directory -Force)
        }

        $CurrentSettings | Export-Clixml $SettingsPath
    }
}