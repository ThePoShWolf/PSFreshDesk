Properties{
    $env:ProjectRoot = $PSScriptRoot
    $ErrorActionPreference = "Stop"
}

Task Manual -depends Build

Task Build -depends Clean {
    #build module file
    $scriptFiles = Get-ChildItem $env:ProjectRoot\src -Filter *.ps1 -Recurse -Exclude *.ps1xml
    $functionsToExport = Get-ChildItem $env:ProjectRoot\src\public |  %{$_.name.replace(".ps1","")}
    #$formatsToExport = Get-ChildItem $env:ProjectRoot\src\classes -Filter *format.ps1xml
    If(-not(Test-Path $env:ModuleTempDir\$env:ModuleName)){
        New-Item $env:ModuleTempDir\$env:ModuleName -ItemType Directory | Out-Null
    }
    ForEach($file in $scriptFiles) {
        Get-Content $file.FullName | Out-File $env:ModuleTempDir\$env:ModuleName\$env:ModuleName.psm1 -Append -Encoding ascii
    }
    Copy-Item $env:ProjectRoot\src\$env:ModuleName.psd1 $env:ModuleTempDir\$env:ModuleName\$env:ModuleName.psd1
    <#ForEach($format in $formatsToExport){
        Copy-Item $format.FullName -Destination $env:ModuleTempDir\$env:ModuleName\$format
        'Update-FormatData $PSScriptRoot\' + $($format.name) | Out-File $env:ModuleTempDir\$env:ModuleName\$env:ModuleName.psm1 -Append
    }#>
    $moduleManifestData = @{
        Author = $env:Author
        Copyright = "(c) $((get-date).Year) $env:Author. All rights reserved."
        Path = "$env:ModuleTempDir\$env:ModuleName\$env:ModuleName.psd1"
        FunctionsToExport = $FunctionstoExport
        RootModule = "$env:ModuleName.psm1"
        ModuleVersion = $env:ModuleVersion
        #FormatsToProcess = $formatsToExport
    }
    Update-ModuleManifest @moduleManifestData
    Import-Module $env:ModuleTempDir\$env:ModuleName -RequiredVersion $env:ModuleVersion
    New-ExternalHelp -Path $env:ProjectRoot\docs\ -OutputPath $env:ModuleTempDir\$env:ModuleName\en-us
}
Task Test -depends Build {
    #still need to create pester tests
}
Task Analyze -depends Build {
    #still need to get my PSScriptANalyzer going
}
Task Deploy -depends Test,Analyze {
    #eventually
}
Task Clean {
    If(Test-Path $env:ModuleTempDir\$env:ModuleName){
    Remove-Item $env:ModuleTempDir\$env:ModuleName -Recurse -Force
    }
}