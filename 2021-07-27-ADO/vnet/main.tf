###########################
# DATA SOURCES 29.03.2024 13:16
###########################

locals {
  name = "${var.prefix}-${random_id.seed.hex}"
}

###########################
# RESOURCES
###########################

resource "random_id" "seed" {
  byte_length = 4
}

resource "azurerm_resource_group" "vnet" {
  name     = local.name
  location = var.region
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = local.name
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = azurerm_resource_group.vnet.name
}

# Subnet 1
resource "azurerm_subnet" "subnet_1" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Subnet 2
resource "azurerm_subnet" "subnet_2" {
  name                 = "subnet-2"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "allow_ssh" {
  name                = "allow_ssh"
  location            = var.region
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_subnet_1" {
  depends_on                = [azurerm_subnet.subnet_1]
  subnet_id                 = azurerm_subnet.subnet_1.id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_subnet_2" {
  depends_on                = [azurerm_subnet.subnet_2]
  subnet_id                 = azurerm_subnet.subnet_2.id
  network_security_group_id = azurerm_network_security_group.allow_ssh.id
}
