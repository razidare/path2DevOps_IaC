resource "null_resource" "update_helm" {
  provisioner "local-exec" {
    command = "helm repo update"
  }
}

resource "kubernetes_namespace" "networking" {
  metadata {
    name = "networking"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  namespace  = "networking"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = [
    "${file("values.yaml")}"
  ]

  # set {
  #   name  = "service.type"
  #   value = "ClusterIP"
  # }
  
  depends_on = [
    null_resource.update_helm,
    kubernetes_namespace.networking
  ]
}