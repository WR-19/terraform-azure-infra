resource "azurerm_resource_group" "spoke" {
  name     = "rg-${var.env}-${var.name}"
  location = var.location

  tags = {
    env        = var.env
    managed_by = "terraform"
    workload   = var.name
  }
}

resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-${var.env}-${var.name}"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  address_space       = [var.cidr]

  tags = azurerm_resource_group.spoke.tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.app_subnet]
}

resource "azurerm_subnet" "data" {
  name                 = "snet-data"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.data_subnet]
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${var.name}-to-hub"
  resource_group_name       = azurerm_resource_group.spoke.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = var.hub_vnet_id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-${var.name}"
  resource_group_name       = var.hub_rg_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-${var.env}-${var.name}-app"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  security_rule {
    name                       = "allow-https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = azurerm_resource_group.spoke.tags
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_network_security_group" "data" {
  name                = "nsg-${var.env}-${var.name}-data"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  security_rule {
    name                       = "allow-from-app"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.app_subnet
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-all"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = azurerm_resource_group.spoke.tags
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}