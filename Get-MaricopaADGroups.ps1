Import-Module ActiveDirectory

Clear-Host

do {

    Write-Host "-----------Menu-----------"
    Write-Host "1 - MCCCD-ORG MEID Groups"
    Write-Host "2 - SCC MEID Groups"
    Write-Host "3 - SCC Local User Groups`n"

    $choice = Read-Host "Select group ('x' to exit)"

    if ($choice -ne 'x') {

        switch ($choice) {

            1 { $user = read-host "Enter account name"
                $forest = (Get-ADForest -Current LoggedOnUser | select -ExpandProperty Name)         
                (Get-ADUser –Identity $user –Properties MemberOf -server $forest).memberof |
                Get-ADGroup -Server $forest | select Name | ft    
            }

            2 { $user = read-host "Enter account name"
                $sid = (Get-ADUser $user -Server mcccd.org | select -expand SID | select -expand value)
                (Get-ADObject -Filter { (ObjectClass -eq "foreignSecurityPrincipal") -and (Name -eq $sid) } -Properties memberof).memberof |
                Get-ADGroup | select Name | ft    
            }

            3 { $user = read-host "Enter account name"
                (Get-ADUser $user -Properties memberof).memberof | 
                Get-ADGroup -Server scc.maricopa.edu | select Name | ft    
            }

            default {Write-Host "Not a valid group selection"}
        }
        Read-Host "Press enter to continue"
    }
} until ($choice -eq 'x')