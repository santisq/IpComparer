class IpComparer : IComparable {
    [ipaddress] $IpAddress

    IpComparer ([string] $IpAddress) {
        $this.IPAddress = $IpAddress
    }

    [int] GetHashCode() {
        return $this.IpAddress.GetHashCode()
    }

    [string] ToString() {
        return $this.IpAddress.ToString()
    }

    hidden static [bool] Equals ([object] $LHS, [object] $RHS) {
        return $LHS.IpAddress -eq $RHS.IpAddress
    }
    [bool] Equals ([object] $Ip) {
        return [IpComparer]::Equals([IpComparer] $this, [IpComparer] $Ip)
    }

    hidden static [int] CompareTo ([IpComparer] $LHS, [IpComparer] $RHS) {
        $x = $LHS.IpAddress.GetAddressBytes()
        $y = $RHS.IpAddress.GetAddressBytes()

        for($i = 0; $i -lt 4; $i++) {
            if($ne = $x[$i].CompareTo($y[$i])) {
                return $ne
            }
        }
        return 0
    }
    [int] CompareTo ([object] $Ip) {
        if($null -eq $Ip) {
            return 1
        }
        return [IpComparer]::CompareTo([IpComparer] $this, [IpComparer] $Ip)
    }
}