#Requires -Modules psake
[cmdletbinding()]
param(
    [string[]]$Task = 'manual'
)

$DependentModules = @('Pester','Psake','PlatyPS')
Foreach ($Module in $DependentModules){
    If (-not (Get-Module $module -ListAvailable)){
        Install-Module -name $Module -Scope CurrentUser
    }
    Import-Module $module -ErrorAction Stop
}
$env:ModuleTempDir = "$PSScriptRoot\src" #$env:TEMP
$env:ModuleName = "PSFreshDesk"
$env:Author = "Anthony Howell"
$env:ModuleVersion = "0.0.1"
# Builds the module by invoking psake on the build.psake.ps1 script.
Invoke-PSake $PSScriptRoot\psake.ps1 -taskList $Task
