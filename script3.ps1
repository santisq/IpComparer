cls
Import-Module activedirectory
$count = 0
$include_department = @("Sales & Admin - All ","Field - Support", "HKLM - All", "SOD - 1", "Home - 1080")
$include_title = @("Client Manager", "Local Sales", "Outside Sales", "Region Manager", "Deployment Manager")
$exclude_title = @("- ")
$users = Get-ADUser -filter * -properties Department, Title, SamAccountName |
    Where-Object {
        ($_.Department -match ('(' + [string]::Join(')|(', $include_department) + ')')) -and
        ($_.Title -match ('(' + [string]::Join(')|(', $include_title) + ')')) -and
        ($_.Department -notcontains "- ")
    }
$users | Out-File -FilePath C:\it\file.txt