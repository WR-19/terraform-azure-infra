resource "azurerm_resource_group" "hub" {
  name     = "rg-${var.env}-network-hub"
  location = var.location

  tags = {
    env        = var.env
    managed_by = "terraform"
  }
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${var.env}-hub"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  address_space       = ["10.0.0.0/16"]

  tags = azurerm_resource_group.hub.tags
}

resource "azurerm_subnet" "mgmt" {
  name                 = "snet-mgmt"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "mgmt" {
  name                = "nsg-${var.env}-mgmt"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = azurerm_resource_group.hub.tags
}

resource "azurerm_subnet_network_security_group_association" "mgmt" {
  subnet_id                 = azurerm_subnet.mgmt.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}