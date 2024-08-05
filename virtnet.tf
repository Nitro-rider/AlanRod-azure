resource "azurerm_virtual_network" "app_network" {
  name                = "app-network"
  location            = local.location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnetA"
    address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_network_interface" "app_interface" {
  name                = "app-interface"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.app_public_ip.id
  }

  depends_on = [ 
    azurerm_virtual_network.app_network, 
    azurerm_public_ip.app_public_ip ]
}

resource "azurerm_public_ip" "app_public_ip" {
  name                = "app-public-ip"
  resource_group_name = local.resource_group
  location            = local.location
  allocation_method   = "Static"
}