class IpComparer : System.IComparable {
    [ipaddress] $IPAddress

    IpComparer ([string] $IpAddress) {
        $this.IPAddress = $IpAddress
    }

    [int] CompareTo ([object] $Ip) {
        return $this.CompareTo([IpComparer] $Ip)
    }
    [int] CompareTo ([IpComparer] $Ip) {
        $lhs = $this.IPAddress.GetAddressBytes()
        $rhs = $Ip.IPAddress.GetAddressBytes()

        for($i = 0; $i -lt 4; $i++) {
            if($ne = $lhs[$i].CompareTo($rhs[$i])) {
                return $ne
            }
        }
        return 0
    }
}

@'
194.225.0.0 - 194.225.15.255
194.225.24.0 - 194.225.31.255
62.193.0.0 - 62.193.31.255
195.146.53.128 - 195.146.53.225
217.218.0.0 - 217.219.255.255
195.146.40.0 - 195.146.40.255
85.185.240.128 - 85.185.240.159
78.39.194.0 - 78.39.194.255
78.39.193.192 - 78.39.193.207
not an ip
'@ -split '\r?\n' | Sort-Object { $_ -replace ' -.+' -as [IpComparer] } -Descending