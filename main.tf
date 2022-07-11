locals {
  base_name = "${var.prefix}${var.environment}app"
  common_tags = merge(var.common_tags, {
    BusinessUnit = var.business_unit_tag
    Organization = var.organization_tag
    Environment = var.environment
  })
}

resource "azurerm_resource_group" "main" {
  name     = local.base_name
  location = var.location
}

module "network" {
  source = "api.env0.com/e02c6435-0492-493d-96bc-55fd7f5a8570/network/azurerm"
  version = "v1.0.0"

  resource_group_name = azurerm_resource_group.main.name

  vnet_name          = local.base_name
  vnet_address_space = var.vnet_address_space
  subnets = var.subnets
  common_tags = local.common_tags

  depends_on = [
    azurerm_resource_group.main
  ]
}

resource "azurerm_public_ip" "main" {
  name                = local.base_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${lower(local.base_name)}"
}

resource "azurerm_network_security_group" "main" {
  name                = local.base_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_security_rule" "app" {
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  name                        = "App"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "${var.app_port_number}"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_interface" "main" {
  name                      = local.base_name
  location                  = var.location
  resource_group_name       = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.prefix}NICConfg"
    subnet_id                     = module.network.subnet_ids[var.app_subnet]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                  = local.base_name
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size               = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = local.base_name
  custom_data = templatefile("${path.module}/templates/custom_data.tpl", {
    admin_username = var.admin_username
    port = var.app_port_number
  })

  tags = local.common_tags
}