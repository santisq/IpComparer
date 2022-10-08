# IpComparer Class

## Description

Simple [__PowerShell Class__](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes) that implements the [`IComparable`](https://docs.microsoft.com/en-us/dotnet/api/system.icomparable?view=net-6.0) and [`IEquatable<T>`](https://learn.microsoft.com/en-us/dotnet/api/system.iequatable-1?view=net-7.0). Allows for comparison and sorting of IP Addresses.

## Compatibility

Compatible with Windows PowerShell 5.1 and PowerShell Core.

## Constructors

| OverloadDefinitions | Description |
| ---- | ---- |
| `IpComparer new(ipaddress IpAddress)` &nbsp; &nbsp; &nbsp; | Initializes a new instance of the `IpComparer` class with the address specified as a string.

## Properties

| Name | Description |
| ---- | ----------- |
| `IpAddress` | Instance of [`IpAddress`](https://docs.microsoft.com/en-us/dotnet/api/system.net.ipaddress?view=net-6.0) to be compared.

## Examples

- Comparing

```powershell
[IpComparer] '194.225.0.0' -lt '194.225.15.255' # => True
[IpComparer] '194.225.15.255' -lt '194.225.0.0' # => False
[IpComparer] '194.225.0.0' -gt '194.225.15.255' # => False
[IpComparer] '194.225.15.255' -gt '194.225.0.0' # => True
```

- Testing for Equality

```powershell
[IpComparer] '194.225.15.25' -ge '194.225.15.25' # => True
'194.225.15.25' -le [IpComparer] '194.225.15.25' # => True

$hs = [Collections.Generic.HashSet[IpComparer]]::new()
$hs.Add('194.225.0.0') # => True
$hs.Add('194.225.0.0') # => False

([IpComparer] '194.225.15.255').Equals('194.225.15.255') # => True
```

- Sorting

```powershell
@'
194.225.0.0
194.225.24.0
62.193.0.0
195.146.53.128
217.218.0.0
195.146.40.0
85.185.240.128
78.39.194.0
78.39.193.192
'@ -split '\r?\n' | Sort-Object { $_ -as [IpComparer] }
```