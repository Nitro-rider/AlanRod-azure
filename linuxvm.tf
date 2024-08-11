resource "azurerm_linux_virtual_machine" "example" {
  name                = "linuxvm"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_F2"
  admin_username      = "linuxuser"
  network_interface_ids = [
    azurerm_virtual_network.app_network.id,
  ]
  
  
  admin_ssh_key {
    username   = "linuxusr"
    public_key = tls_public_key.linux_key.openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.app_interface,
    tls_private_key.linux_key
    ]
}

resource "tls_private_key" "linux_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "linuxkey" {
  filename = "linuxkey.pem"
  content = tls_private_key.linux_key.private_key_pem
}

resource "azurerm_public_ip" "app_public_ip" {
  name                = "app-public-ip"
  resource_group_name = local.resource_group
  location            = local.location
  allocation_method   = "Static"
  depends_on = [ 
    azurerm_resource_group.app_grp ]
}