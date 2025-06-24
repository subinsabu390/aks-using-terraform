module "aks_cluster" {
  source = "./module/aks_cluster"
  resource_group_name =var.resource_group_name
  aks_name = var.aks_name
  location = var.location
  sku_tier = var.sku_tier
  kubernetes_version = var.kubernetes_version
  node_name = var.node_name
  node_count = var.node_count
  vm_size = var.vm_size
  dns_prefix = var.dns_prefix
  log_analytics_workspace_name = var.log_analytics_workspace_name
  acr_name = var.acr_name
}

module "create_ip" {
  source = "./module/create_ip"
  resource_group_name = var.resource_group_name
  aks_name = var.aks_name
  location = var.location
  public_ip_name = var.public_ip_name
  
  depends_on = [ module.aks_cluster ]
}


module "install_resources" {
  source    = "./module/install_resources"
  resource_group_name = var.resource_group_name
  aks_name = var.aks_name
  location = var.location
  dns_label = var.dns_label
  namespace = var.namespace
  cert_manager_tag = var.cert_manager_tag
  acr_url = var.acr_url
  registry_name = var.registry_name
  static_ip = module.create_ip.static_ip_address

  depends_on = [ module.create_ip ]
}