output "app_url" {
  value = "http://${azurerm_public_ip.main.fqdn}:${var.app_port_number}"
}