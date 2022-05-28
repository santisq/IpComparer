class IpComparer : IComparable, IComparable[object] {
    [ipaddress] $IPAddress

    IpComparer ([string] $IpAddress) {
        $this.IPAddress = $IpAddress
    }

    [int] CompareTo ([object] $Ip) {
        if($null -eq $Ip) {
            return 1
        }
        return [IpComparer]::CompareTo([IpComparer] $this, [IpComparer] $Ip)
    }
    hidden static [int] CompareTo ([IpComparer] $LHS, [IpComparer] $RHS) {
        $x = $LHS.IPAddress.GetAddressBytes()
        $y = $RHS.IPAddress.GetAddressBytes()

        for($i = 0; $i -lt 4; $i++) {
            if($ne = $x[$i].CompareTo($y[$i])) {
                return $ne
            }
        }
        return 0
    }
}