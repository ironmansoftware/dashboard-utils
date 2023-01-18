function Show-UDEventData {
    Show-UDModal -Content {
        New-UDElement -Tag 'pre' -Content {
            $EventData | ConvertTo-Json
        }
    }
}

function Reset-UDPage { 
    Invoke-UDJavaScript "window.location.reload()"
}

function Show-UDObject {
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process {
        Show-UDModal {
            $Data = @()
            $InputObject | Get-Member -MemberType Property | ForEach-Object {
                $Data += [PSCustomObject]@{
                    Key = $_.Name
                    Value = $InputObject."$($_.Name)"
                } 
            }

            New-UDTable -Data $Data
        } -MaxWidth 'xl' -FullWidth
    }
}

function Get-UDCache {
    [UniversalDashboard.Execution.GlobalCachedVariableProvider]::Cache
}