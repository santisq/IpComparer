function CompareTo ([ipaddress] $Ip1, [ipaddress] $Ip2) {
    $lhs = $Ip1.GetAddressBytes()
    $rhs = $Ip2.GetAddressBytes()

    for($i = 0; $i -lt 4; $i++) {
        if($lhs[$i] -eq $rhs[$i]) {
            continue
        }
        if($lhs[$i] -lt $rhs[$i]) {
            return -1
        }

        return 1
    }
}

CompareTo '85.185.240.128' '195.146.40.0'
CompareTo '195.146.40.0' '85.185.240.128'