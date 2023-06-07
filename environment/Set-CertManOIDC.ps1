# URL : https://cert-manager.io/docs/tutorials/getting-started-aks-letsencrypt/#part-2

param(
    [string]$aksName,
    [string]$aksRg,
    [string]$aksResourcesRg,
    [string]$miName,
    [string]$dnsZone
)

#Add OIDC + workload identity extensions
az extension add --name aks-preview
az extension update -n aks-preview
az feature register --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableWorkloadIdentityPreview')].{Name:name,State:properties.state}"
az aks update --name $aksName --resource-group $aksRg --enable-oidc-issuer --enable-workload-identity

#Installing cert manager
#helm upgrade cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true --install --values D:\_playground\_misc\cert-manager-values.yaml
#check changes:
#kubectl describe pod -n cert-manager -l app.kubernetes.io/component=controller
#create MI
#az identity create --name $miName --resource-group $aksResourcesRg
#get MI ID
$miClientId=$(az identity show --name $miName --resource-group  $aksResourcesRg --query 'clientId' -o tsv)

#!!!!! Replace miClientId in cluster_issuer.yaml clientID: property
#role assignment for DNS zone
az role assignment create --role "DNS Zone Contributor" --assignee $miClientId --scope $(az network dns zone show -g $aksRg --name $dnsZone -o tsv --query id)

#add federated identity
$saName="cert-manager"
$saNamespace="cert-manager"
$subject="system:serviceaccount:" + $saNamespace + ":" + $saName

$saIssuer=$(az aks show --resource-group $aksRg --name $aksName --query "oidcIssuerProfile.issuerUrl" -o tsv)
az identity federated-credential create --name "cert-manager" -g $aksResourcesRg --identity-name $miName --issuer $saIssuer --subject $subject