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

$a = [IpComparer] '194.225.0.0'
[ipcomparer]::new