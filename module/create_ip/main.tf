data "azurerm_kubernetes_cluster" "node_rg" {
    name = var.aks_name
    resource_group_name = var.resource_group_name
}

resource "azurerm_public_ip" "ingress_ip" {
    name = var.public_ip_name
    location = var.location
    resource_group_name = data.azurerm_kubernetes_cluster.node_rg.node_resource_group
    allocation_method = "Static"
}