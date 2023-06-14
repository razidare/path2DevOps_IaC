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

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  namespace  = "networking"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = [
    "${file("values_ingress_controller.yaml")}"
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

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  values = [
    "${file("values_cert_manager.yaml")}"
  ]

  set {
    name  = "installCRDs"
    value = "true"
  }
  
  depends_on = [
    null_resource.update_helm,
    kubernetes_namespace.cert_manager
  ]
}

resource "null_resource" "cluster_issuer" {
  provisioner "local-exec" {
    command = "kubectl apply -f cluster_issuer.yaml"
  }

  depends_on = [ 
    helm_release.cert_manager
  ]
}