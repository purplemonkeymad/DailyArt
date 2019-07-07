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
        foreach ($Property in ($BaseObject.getType().Getproperties()) ) {

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
            $Property.CustomAttributes.GetEnumerator() | ForEach-Object {
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