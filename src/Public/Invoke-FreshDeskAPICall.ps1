<#
API Docs: https://developers.freshdesk.com/api
Github repo: https://github.com/ThePoShWolf/PSFreshDesk

Just because I've done this before, doesn't mean I'm perfect or even everything
according to best practice. So if you see something, say something.

Apparently my office neighbors are noisy today, sorry about that.

#>
Function Invoke-FreshDeskAPICall {
    Param(
        [ValidateSet('Get','Post')]
        [string]$method,
        [string]$resource,
        [string]$Domain = 'howellit',
        [string]$apikey = (get-content C:\tmp\fdapikey.txt)
    )
    $baseuri = "https://$Domain.freshdesk.com/api/v2"

    $encodedapikey = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$apikey`:dummy"))

    $headers = @{
        Authorization = "Basic $encodedapikey"
    }

    Invoke-RestMethod -uri $baseuri/$resource -Method $method -Headers $headers
}