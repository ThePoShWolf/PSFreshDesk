Function Get-FreshDeskAgent {
    [cmdletbinding()]
    Param (
        [Parameter(
            ParameterSetName = 'ById'
        )]
        $Id
    )
    If($PSCmdlet.ParameterSetName -eq 'ById'){
        $resource = "agents/$Id"
    }else{
        $resource = 'agents'
    }
    Invoke-FreshDeskAPICall -method Get -resource $resource
}