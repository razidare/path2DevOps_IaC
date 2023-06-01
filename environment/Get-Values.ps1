param(
    [Parameter(Mandatory=$true)][string]$pip,
    [Parameter(Mandatory=$true)][string]$rg
)

$values = Get-Content "$PSScriptRoot/../kubernetes/tpl.yaml"

$values.replace("#{pip}#", $pip).replace("#{rg}#", $rg) | Out-File "$PSScriptRoot/../kubernetes/values.yaml" -Force -Encoding utf8