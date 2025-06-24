data "azurerm_log_analytics_workspace" "log_workspace" {
    name = var.log_analytics_workspace_name
    resource_group_name = var.resource_group_name
}

resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  sku                       = "Basic"
  admin_enabled            = false
}

resource "azurerm_kubernetes_cluster" "aks" {
    name                       = var.aks_name
    resource_group_name        = var.resource_group_name
    location                   = var.location
    sku_tier                   = var.sku_tier
    kubernetes_version         = var.kubernetes_version
    dns_prefix                 = var.dns_prefix
    node_os_upgrade_channel    = "None"

    default_node_pool {
        name       = var.node_name
        node_count = var.node_count
        vm_size    = var.vm_size
    }

    network_profile {
        network_plugin    = "azure"
        load_balancer_sku = "standard"
    }


    identity {
        type = "SystemAssigned"
    }

    oms_agent {
        log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_workspace.id
    }

    depends_on = [ azurerm_container_registry.acr ]
}

resource "azurerm_role_assignment" "aks_to_acr_role" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true

  depends_on = [ azurerm_kubernetes_cluster.aks ]
}