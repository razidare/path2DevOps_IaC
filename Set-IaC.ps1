<#
.Synopsis
   Script used to run terraform layers in order + to destroy them in order
.EXAMPLE
   ./Set-IaC.ps1 -action create
   ./Set-IaC.ps1 -action destroy
#>

param (
    [Parameter(Mandatory=$true)][ValidateSet("create", "destroy")][string]$action
)

$globalFolder = "$PSScriptRoot/global"
$envFolder = "$PSScriptRoot/environment"
$k8sFolder = "$PSScriptRoot/kubernetes"

switch ($action) {
    "create" {
        # move to global folder and run tf commands
        Push-Location $globalFolder
        Write-Verbose "Running Inside $globalFolder - Command is APPLY" -vb
        terraform init
        terraform apply -auto-approve

        Pop-Location

        # move to env folder and run tf commands
        Push-Location $envFolder
        Write-Verbose "Running Inside $envFolder - Command is APPLY" -vb
        terraform init
        terraform apply -auto-approve

        Pop-Location

        # move to k8s folder and run tf commands
        Push-Location $k8sFolder
        Write-Verbose "Running Inside $k8sFolder - Command is APPLY" -vb
        terraform init
        terraform apply -auto-approve

        Pop-Location
    }
    "destroy" {

        # move to k8s folder and run tf commands
        Push-Location $k8sFolder
        Write-Verbose "Running Inside $k8sFolder - Command is DESTROY" -vb
        terraform init
        terraform destroy -auto-approve

        Pop-Location

        # move to env folder and run tf commands
        Push-Location $envFolder
        Write-Verbose "Running Inside $envFolder - Command is DESTROY" -vb
        terraform init
        terraform destroy -auto-approve

        Pop-Location

        move to global folder and run tf commands
        Push-Location $globalFolder
        Write-Verbose "Running Inside $globalFolder - Command is DESTROY" -vb
        terraform init
        terraform destroy -auto-approve

        Pop-Location
    }
}

