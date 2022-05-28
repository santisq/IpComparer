# IpComparer Class

## Description

Simple [__PowerShell Class__](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes) that implements the [`IComparable` Interface](https://docs.microsoft.com/en-us/dotnet/api/system.icomparable?view=net-6.0) and holds an instance of [`IpAddress`](https://docs.microsoft.com/en-us/dotnet/api/system.net.ipaddress?view=net-6.0). Allows for comparison and sorting of IP Addresses

## Constructors

|---|---|
|OverloadDefinitions|Description|
|`IpComparer new(string IpAddress)`|Initializes a new instance of the `IpComparer` class with the address specified as a string.


```
   TypeName: IpComparer

Name        MemberType Definition
----        ---------- ----------
CompareTo   Method     int CompareTo(System.Object Ip), int CompareTo(IpComparer Ip), int IComparable.CompareTo(System.Object obj)
Equals      Method     bool Equals(System.Object obj)
GetHashCode Method     int GetHashCode()
GetType     Method     type GetType()
ToString    Method     string ToString()
IPAddress   Property   ipaddress IPAddress {get;set;}
```

