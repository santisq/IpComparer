class IpComparer : IComparable, IEquatable[object] {
    [ipaddress] $IpAddress

    IpComparer([ipaddress] $IpAddress) {
        $this.IpAddress = $IpAddress
    }

    [string] ToString() {
        return $this.IpAddress.ToString()
    }

    [int] GetHashCode() {
        return $this.IpAddress.GetHashCode()
    }

    [bool] Equals([object] $IpAddress) {
        return [IpComparer]::Equals($this, [IpComparer] $IpAddress)
    }

    hidden static [bool] Equals([IpComparer] $LHS, [IpComparer] $RHS) {
        return $LHS.IpAddress.Equals($RHS.IpAddress)
    }

    [int] CompareTo([object] $IpAddress) {
        return [IpComparer]::CompareTo($this, [IpComparer] $IpAddress)
    }

    hidden static [int] CompareTo([IpComparer] $LHS, [IpComparer] $RHS) {
        $x = $LHS.IpAddress.GetAddressBytes()
        $y = $RHS.IpAddress.GetAddressBytes()

        for($i = 0; $i -lt 4; $i++) {
            if($ne = $x[$i].CompareTo($y[$i])) {
                return $ne
            }
        }
        return 0
    }

    hidden static [IpComparer] op_Explicit([string] $IpAddress) {
        return [IpComparer]::new([ipaddress] $IpAddress)
    }
}