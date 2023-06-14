param(
    [Parameter(Mandatory=$true)][string]$pip,
    [Parameter(Mandatory=$true)][string]$rg,
    [Parameter(Mandatory=$false)][string]$email="radu.m.zidarescu@hotmail.com",
    [Parameter(Mandatory=$true)][string]$subID,
    [Parameter(Mandatory=$true)][string]$dns,
    [Parameter(Mandatory=$true)][string]$miID
)

$ingressValues = Get-Content "$PSScriptRoot/../kubernetes/tpl_ingress_values.yaml"
$clusterIssuer = Get-Content "$PSScriptRoot/../kubernetes/tpl_cluster_issuer.yaml"

$ingressValues.replace("#{pip}#", $pip).replace("#{rg}#", $rg) | Out-File "$PSScriptRoot/../kubernetes/values_ingress_controller.yaml" -Force -Encoding utf8
$clusterIssuer.replace("#{email}#", $email).replace("#{rg}#", $rg).replace("#{subID}#", $subID).replace("#{dns}#", $dns).replace("#{miID}#", $miID)| Out-File "$PSScriptRoot/../kubernetes/cluster_issuer.yaml" -Force -Encoding utf8