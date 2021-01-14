#
# Module manifest for module 'DailyArt'
#
# Generated by: David Brettle
#
# Generated on: 2021-01-14
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '0.3.7'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'c3a9eae9-613f-433d-9f5c-7cefa4895bc5'

# Author of this module
Author = 'David Brettle'

# Company or vendor of this module
CompanyName = 'david @ brettle.org.uk'

# Copyright statement for this module
Copyright = '(c) 2019 David. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Get daily art in your shell from reddit.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('OutConsolePicture')

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('.\classes\DAItem.ps1', 
               '.\classes\DASettings.ps1', 
               '.\private\00.Variables.ps1', 
               '.\private\Update-DailyArt.ps1', 
               '.\public\Clear-DailyArt.ps1', 
               '.\public\Get-DailyArtInfo.ps1', 
               '.\public\Get-DailyArtSettings.ps1', 
               '.\public\Get-SubredditImages.ps1', 
               '.\public\Open-DailyArt.ps1', 
               '.\public\Open-DailyArtComments.ps1', 
               '.\public\Set-DailyArtSettings.ps1', 
               '.\public\Show-DailyArt.ps1')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Clear-DailyArt', 'Get-DailyArtInfo', 'Get-DailyArtSettings', 
               'Get-SubredditImages', 'Open-DailyArt', 'Open-DailyArtComments', 
               'Set-DailyArtSettings', 'Show-DailyArt'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = ' '

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = 'DailyArt-Help.xml', 'DailyArt.psd1', 'puild.json', 
               'classes\DAItem.ps1', 'classes\DASettings.ps1', 
               'private\00.Variables.ps1', 'private\Update-DailyArt.ps1', 
               'public\Clear-DailyArt.ps1', 'public\Get-DailyArtInfo.ps1', 
               'public\Get-DailyArtSettings.ps1', 'public\Get-SubredditImages.ps1', 
               'public\Open-DailyArt.ps1', 'public\Open-DailyArtComments.ps1', 
               'public\Set-DailyArtSettings.ps1', 'public\Show-DailyArt.ps1'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'OutConsolePicture','DailyArt','MOTD','reddit'

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        ExternalModuleDependencies = @('OutConsolePicture')

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

