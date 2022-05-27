$ips = @"
194.225.0.0 - 194.225.15.255
194.225.24.0 - 194.225.31.255
62.193.0.0 - 62.193.31.255
195.146.53.128 - 195.146.53.225
217.218.0.0 - 217.219.255.255
195.146.40.0 - 195.146.40.255
85.185.240.128 - 85.185.240.159
notanip
78.39.194.0 - 78.39.194.255
78.39.193.192 - 78.39.193.207
"@ -split '\r?\n'

$iptable = @{}
foreach($line in $ips) {
    if($ip = $line -replace ' -.+' -as [ipaddress]) {
        $iptable[$line] = $ip.GetAddressBytes()
    }
}

$expressions = foreach($i in 0..3) {
    { $iptable[$_] | Select-Object -Index $i }.GetNewClosure()
}

$ips | Sort-Object $expressions -Descending