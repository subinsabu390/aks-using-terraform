output "static_ip_address" {
    value = azurerm_public_ip.ingress_ip.ip_address
}