Function Get-AdRolesPermissions {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, HelpMessage = "Input of group objects to be processed.")]
        $group,
        [Parameter(HelpMessage = "Choose if the data will be exportet or displayed.")]
        $export = $True,
        [Parameter(HelpMessage = "Define the path where the data will be exported to.")]
        $path = ".\RolesPermissions.csv"
    )

    Begin {
        $output = @()
    }

    Process {
        $obj = @{}
        $grouplist = @()

        $memGroup = (Get-ADGroup –Identity $group –Properties Memberof).Memberof
        $memGroup | ForEach-Object { $groupList += ($_ -split ",*..=")[1] }
        $group = ($group -split ",*..=")[1]

        $obj[$group] = $grouplist

        $output += $obj
    }

    End {
        $data = $output | Select-Object @{n = 'Roles'; e = { $_.Keys } }, @{n = 'Permissions'; e = { $_.Values } }
            
        if ($export) {
            $data | Export-Csv -Delimiter ";" -Path $path
        }
        else {
            $data
        }
    }
}