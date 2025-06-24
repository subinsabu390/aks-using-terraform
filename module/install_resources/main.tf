resource "helm_release" "nginx_ingress_controller" {
    name = "ingress-nginx"
    repository = "https://kubernetes.github.io/ingress-nginx"
    chart = "ingress-nginx"
    namespace = var.namespace


    set {
        name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
        value = "/healthz"
    }

    set {
        name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
        value = var.dns_label
    }

    set {
        name  = "controller.service.loadBalancerIP"
        value = var.static_ip
    }
}

resource "null_resource" "import_cert_manager_images" {
    provisioner "local-exec" {
        command = "az acr import --name ${var.registry_name} --source quay.io/jetstack/cert-manager-controller:${var.cert_manager_tag} --image jetstack/cert-manager-controller:${var.cert_manager_tag} && az acr import --name ${var.registry_name} --source quay.io/jetstack/cert-manager-webhook:${var.cert_manager_tag} --image jetstack/cert-manager-webhook:${var.cert_manager_tag} && az acr import --name ${var.registry_name} --source quay.io/jetstack/cert-manager-cainjector:${var.cert_manager_tag} --image jetstack/cert-manager-cainjector:${var.cert_manager_tag}"
    }

    depends_on = [ helm_release.nginx_ingress_controller ]
}

resource "helm_release" "cert_manager" {
    name = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart = "cert-manager"
    namespace = var.namespace
    version = var.cert_manager_tag

    set {
        name  = "installCRDs"
        value = "true"
    }

    set {
        name  = "nodeSelector.kubernetes\\.io/os"
        value = "linux"
    }

    set {
        name  = "image.repository"
        value = "${var.acr_url}/jetstack/cert-manager-controller"
    }

    set {
        name  = "image.tag"
        value = var.cert_manager_tag
    }

    set {
        name  = "webhook.image.repository"
        value = "${var.acr_url}/jetstack/cert-manager-webhook"
    }

    set {
        name  = "webhook.image.tag"
        value = var.cert_manager_tag
    }

    set {
        name  = "cainjector.image.repository"
        value = "${var.acr_url}/jetstack/cert-manager-cainjector"
    }

    set {
        name  = "cainjector.image.tag"
        value = var.cert_manager_tag
    }

    depends_on = [ null_resource.import_cert_manager_images ]
}