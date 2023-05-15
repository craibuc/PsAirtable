function Get-AirtableTableRow {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$BaseId,

        [Parameter(Mandatory)]
        [string]$TableName,

        [Parameter()]
        [string]$View = 'Grid view',

        [Parameter()]
        [int]$MaximumRows
    )
            
    $Headers = @{
        Authorization = "Bearer $ApiKey"
    }
    Write-Debug "Headers: $Headers"

    # $Query = @{}
    # $Query.view ??= $View
    # $MaximumRows -ne 0 ? $Query.maxRecords : $null

    $Uri = "https://api.airtable.com/v0/{0}/{1}?view=Grid%20view" -f $BaseId, $TableName
    Write-Debug "Uri: $Uri"

    do {

        $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers -Verbose:$false
        $Content = $Response.Content | ConvertFrom-Json

        # $Content.offset ? $Query.offsets : $null
        
        $Uri = "https://api.airtable.com/v0/{0}/{1}?view=Grid%20view&offset={2}" -f $BaseId, $TableName, $Content.offset
        Write-Verbose "Uri: $Uri"

        $Content.records
            
    } while ( $null -ne $Content.offset )

}