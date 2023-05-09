
<#
    .SYNOPSIS
    This PowerShell script will disable NetBIOS on all network interfaces.

    .DESCRIPTION

    .Parameter -Local
    This parameter will run the script against the local system.

    .Parameter -Remote
    This parameter will run the script against a remoted directory and the computer objects returned in the query.

    .Parameter -SearchRoot
    This parameter is the SearchBase used when running against a remote directory.

    .EXAMPLE

    .NOTES
    ###############################################################################################
    # Author: Michael Nye - https://github.com/mnyethecyberguy                                    #
    # Project: Disable-NetBios - Michael Nye - https://github.com/mnyethecyberguy/disable-netbios #
    # Module Dependencies: ActiveDirectory                                                        #
    # Permission level: Local Admin                                                               #
    # Powershell v5 or greater                                                                    #
    ###############################################################################################
#>

param (
    [Parameter()]
    [switch]$Local,

    [Parameter()]
    [switch]$Remote,

    [Parameter()]
    [string]$SearchRoot
)

if ($Remote.IsPresent) {
    $computer = Get-ADComputer -SearchBase $SearchRoot -Filter * | Select-Object -ExpandProperty Name
    Invoke-Command -ComputerName $computer -ScriptBlock {
        $adapters = (gwmi win32_networkadapterconfiguration)
        foreach ($adapter in $adapters){
            Write-Host $adapter
            $adapter.settcpipnetbios(2) # 1 is enable 2 is disable
        }
    }
}

if ($Local.IsPresent) {
    $localadapters = (gwmi win32_networkadapterconfiguration)
    foreach ($localadapter in $localadapters){
        Write-Host $localadapter
        $localadapter.settcpipnetbios(2) # 1 is enable 2 is disable
    }
}
