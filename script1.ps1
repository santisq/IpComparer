while($true) {
    $value = Read-host "Specify a value between 10 and 90"
    $parsed = 0
    if(-not [int]::TryParse($value, $parsed)) {
        Write-Host "You must enter a numeric value"
    }
    if($parsed.Value -gt 10 -and $value -lt 90)
}

[int]'0x40'

Read-Host 'asd' -zxc -asd -asd