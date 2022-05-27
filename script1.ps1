$output = "@description('Name of the resource')
output resourceName array = [for (item, i) in databases: db[i].name]
@description('ID of the resource')
output resourceID array = [for (item, i) in databases: db[i].id]"

$value = "[for (item, i) in databases: db[i].id]"

$value = [Regex]::Escape($value)
$output -match "(?<==\s)$value(?=`"|$)"