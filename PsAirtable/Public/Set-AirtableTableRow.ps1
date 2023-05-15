function Set-AirtableTableRow {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$BaseId,

        [Parameter(Mandatory)]
        [string]$TableName,

        [Parameter(Mandatory)]
        [string]$RowId,

        [Parameter(Mandatory)]
        [object]$Fields
    )

    begin {

        $Headers = @{
            Authorization = "Bearer $ApiKey"
        }
        Write-Debug "Headers: $Headers"
    
        $Uri = "https://api.airtable.com/v0/{0}/{1}" -f $BaseId, $TableName
        Write-Debug "Uri: $Uri"
    
        $Data = @{
            records = @()
        }
    
    }
    
    process {

        $Data.records += @{
            id = $RowId
            fields = $Fields
        }

    }

    end {

        $Body = $Data | ConvertTo-Json -Depth 5
        Write-Debug "Body: $Body"

        $Target = "{0}.{1}" -f $TableName, $ColumnName

        if ($PSCmdlet.ShouldProcess($Target, "Invoke-WebRequest")) {
            Invoke-WebRequest -Uri $Uri -Method Patch -Headers $Headers -ContentType 'application/json' -Body $Body
        }

    }

}