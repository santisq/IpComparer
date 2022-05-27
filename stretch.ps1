function Beep {
param(
    [parameter(Mandatory=$true)]
    [ValidateRange(0,[int]::MaxValue)][int]$Time,
    [parameter(mandatory=$false)]
    [ValidateRange(1,[int]::MaxValue)][int]$Times = 1,
    [int]$Index = 1
)

    $attempts = $times
    $attempts--

    Start-Sleep $time

    foreach($i in 1..3)
    {
        [console]::Beep(2000,600)
    }

    "$index. => SWAP <="
    $index++

    if($attempts -gt 0)
    {
        Beep -Time $time -Times $attempts -Index $Index
    }

    return $Index
}

Beep -Time 60 -Times 10
Beep -Time 120
Beep -Time 45 -Times 3