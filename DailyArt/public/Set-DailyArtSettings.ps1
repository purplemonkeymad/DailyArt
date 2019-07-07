function Set-DailyArtSettings {
    [CmdletBinding()]
    param (
        
    )
    DynamicParam {
        # Create Parameters from object

        # final parameters
        $ParameterCollection = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

        ## for each property add a paramter
        foreach ($Property in ([DASettings].Getproperties()) ) {

            if (-not $property.CanWrite) {
                continue
            }

            if ($Property.Name -in @('SettingsVersion')){
                continue
            }

            $AttibuteList = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            #[parameter()]
            $AttibuteList.Add([System.Management.Automation.ParameterAttribute]@{
                ValueFromPipeline = $true
                Mandatory = $false
            })

            # add any existing attributes for item
            foreach ($_ in $Property.CustomAttributes.GetEnumerator() ) {
                # wish there was a way to just clone the existing attributes.
                if ($_.AttributeType -eq [System.Management.Automation.ValidateSetAttribute]){
                    $AttibuteList.Add(
                        [System.Management.Automation.ValidateSetAttribute]::new(
                            [string[]]$_.ConstructorArguments.Value.Value
                        )
                    )
                }
            }

            $ParameterCollection.Add(
                $Property.Name,
                [System.Management.Automation.RuntimeDefinedParameter]::new(
                    $Property.Name,
                    $Property.PropertyType,
                    $AttibuteList
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