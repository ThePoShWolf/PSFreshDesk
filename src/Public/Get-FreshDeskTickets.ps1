# https://developers.freshdesk.com/api/#tickets
Function Get-FreshDeskTickets {
    [cmdletbinding()]
    Param(
        [Parameter(
            ParameterSetName = 'ById'
        )]
        [int]$id
    )
    If($PSCmdlet.ParameterSetName -eq 'ById'){
        $resource = "tickets/$id"
    }Else{
        $resource = 'tickets'
    }

    Invoke-FreshDeskAPICall -method Get -resource $resource
}