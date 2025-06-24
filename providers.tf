terraform {
    required_version = ">= 0.13"
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "4.10.0"
      }
      kubernetes = {
        source = "hashicorp/kubernetes"
        version = "~>2.0"
      }
      helm = {
        source = "hashicorp/helm"
        version = "~>2.0"
      }
    }
}

provider "azurerm" {
    features {}

    subscription_id = ""
}

provider "kubernetes" {
    host = module.aks_cluster.kube_config.host
    client_certificate = base64decode(module.aks_cluster.kube_config.client_certificate)
    client_key = base64decode(module.aks_cluster.kube_config.client_key)
    cluster_ca_certificate = base64decode(module.aks_cluster.kube_config.cluster_ca_certificate)
}

provider "helm"{
    kubernetes {
      host                   = module.aks_cluster.kube_config.host
      client_certificate     = base64decode(module.aks_cluster.kube_config.client_certificate)
      client_key             = base64decode(module.aks_cluster.kube_config.client_key)
      cluster_ca_certificate = base64decode(module.aks_cluster.kube_config.cluster_ca_certificate)
    }
}