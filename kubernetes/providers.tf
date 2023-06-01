# Configure the HELM provider
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Configure the K9s provider
provider "kubernetes" {
  config_path    = "~/.kube/config"
}