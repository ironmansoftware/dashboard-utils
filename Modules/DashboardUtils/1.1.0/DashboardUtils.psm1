function New-UDLineBreak {
    <#
    .SYNOPSIS
    Adds a line break to the dashboard.
    #>
    New-UDElement -Tag 'div' -Content {
        New-UDElement -Tag 'br'
    }
}


function Show-UDEventData {
    <#
    .SYNOPSIS
    Shows the $EventData object as JSON in a modal.
    
    .DESCRIPTION
    Shows the $EventData object as JSON in a modal.
    #>
    Show-UDModal -Content {
        New-UDElement -Tag 'pre' -Content {
            $EventData | ConvertTo-Json
        }
    }
}

function Reset-UDPage { 
    <#
    .SYNOPSIS
    Reloads the current page.
    
    .DESCRIPTION
    Reloads the current page. This uses JavaScript directly.
    #>
    Invoke-UDJavaScript "window.location.reload()"
}

function Show-UDObject {
    <#
    .SYNOPSIS
    Shows an object's properties in a modal.
    
    .DESCRIPTION
    Shows an object's properties in a modal.
    
    .PARAMETER InputObject
    The object to show.
    
    .EXAMPLE
    $EventData | Show-UDObject
    #>
    param(
        [Parameter(ValueFromPipeline, Mandatory)]
        $InputObject
    )

    process {
        Show-UDModal {
            $Data = @()
            $InputObject | Get-Member -MemberType Property | ForEach-Object {
                $Data += [PSCustomObject]@{
                    Key   = $_.Name
                    Value = $InputObject."$($_.Name)"
                } 
            }

            New-UDTable -Data $Data
        } -MaxWidth 'xl' -FullWidth
    }
}

function Get-UDCache {
    <#
    .SYNOPSIS
    Returns all items in the $Cache: scope.
    
    .DESCRIPTION
    Returns all items in the $Cache: scope.
    #>
    [UniversalDashboard.Execution.GlobalCachedVariableProvider]::Cache
}

function Show-UDVariable {
    <#
    .SYNOPSIS
    Shows variables and their values in a modal.
    
    .DESCRIPTION
    Shows variables and their values in a modal.
    
    .PARAMETER Name
    A name. If not specified, all variables are returned.
    
    .EXAMPLE
    Show-UDVariable -Name 'EventData'
    #>
    param($Name)

    Show-UDModal -Content {
        New-UDDynamic -Content {
            $Variables = Get-Variable -Name "*$Name"  

            New-UDTable -Title 'Variables' -Icon (New-UDIcon -Icon 'SquareRootVariable') -Data $Variables -Columns @(
                New-UDTableColumn -Property Name -ShowFilter
                New-UDTableColumn -Property Value -Render {
                    [string]$EventData.Value
                } -ShowFilter
            ) -ShowPagination -ShowFilter
        } -LoadingComponent {
            New-UDSkeleton
        }

    } -Footer {
        New-UDButton -Text 'Close' -OnClick {
            Hide-UDModal
        }
    } -FullScreen
}

function Show-UDThemeColorViewer {
    <#
    .SYNOPSIS
    Shows all the theme colors in a modal.
    
    .DESCRIPTION
    Shows all the theme colors in a modal.
    #>
    Show-UDModal -Header {
        New-UDTypography -Variant h3 -Content {
            New-UDIcon -Icon  Images
            "Themes"
        }
    } -Content {
        New-UDDynamic -Content {
            New-UDRow -Columns {
                Get-UDTheme | ForEach-Object {
                    New-UDColumn -SmallSize 4 -Content {
                        $Theme = Get-UDTheme -Name $_

                        New-UDStack -Direction row -Content {
                            New-UDCard -Title "$_ - Light" -Content {
                                New-UDElement -Content {
                                    "Background"
                                } -Attributes @{
                                    style = @{
                                        color           = $Theme.light.palette.text.primary
                                        backgroundColor = $Theme.light.palette.background.default
                                    }
                                }  -Tag 'div'

                                New-UDElement -Content {
                                    "Primary"
                                } -Attributes @{
                                    style = @{
                                        color           = $Theme.light.palette.text.primary
                                        backgroundColor = $Theme.light.palette.primary.main
                                    }
                                }  -Tag 'div'

                                New-UDElement -Content {
                                    "Secondary"
                                } -Attributes @{
                                    style = @{
                                        color           = $Theme.light.palette.text.primary
                                        backgroundColor = $Theme.light.palette.secondary.main
                                    }
                                } -Tag 'div'
                            }

                            New-UDCard -Title "$_ - Dark" -Content {
                                New-UDElement -Content {
                                    "Background"
                                } -Attributes @{
                                    style = @{
                                        color           = $Theme.dark.palette.text.primary
                                        backgroundColor = $Theme.dark.palette.background.default
                                    }
                                }  -Tag 'div'

                                New-UDElement -Content {
                                    "Primary"
                                } -Attributes @{
                                    style = @{
                                        color           = $Theme.dark.palette.text.primary
                                        backgroundColor = $Theme.dark.palette.primary.main
                                    }
                                }  -Tag 'div'

                                New-UDElement -Content {
                                    "Secondary"
                                } -Attributes @{
                                    style = @{
                                        color           = $Theme.dark.palette.text.primary
                                        backgroundColor = $Theme.dark.palette.secondary.main
                                    }
                                } -Tag 'div'
                            }
                        }



                        # $Theme.light.palette.background.default
                        # $Theme.light.palette.text.primary
                        # $Theme.light.palette.primary.main
                        # $Theme.light.palette.secondary.main

                        # $Theme.dark.palette.background.default
                        # $Theme.dark.palette.text.primary
                        # $Theme.dark.palette.primary.main
                        # $Theme.dark.palette.secondary.main
                    }
                }
            }
        } -LoadingComponent {
            New-UDSkeleton 
        }

    } -FullWidth -MaxWidth xl
}
