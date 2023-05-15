function New-AirtableTableRowAttachment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$BaseId,

        [Parameter(Mandatory)]
        [string]$TableName,

        [Parameter(Mandatory)]
        [string]$ColumnName,

        [Parameter(Mandatory)]
        [string]$RowId,

        [Parameter(Mandatory)]
        [string]$FileUri,

        [Parameter(Mandatory)]
        [string]$FileName
    )
    
    begin {

        $Headers = @{
            Authorization = "Bearer $ApiKey"
        }
    
        $Uri = "https://api.airtable.com/v0/{0}/{1}" -f $BaseId, $TableName
        Write-Debug "Uri: $Uri"

        $Data = @{
            records = @(
                @{
                    id = $RowId
                    fields = @{
                        $ColumnName = @()
                    }
                }
            )
        }
    
    }
    process {

        $Data.records[0].fields.$ColumnName += @{
            url = $FileUri
            filename = $FileName
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