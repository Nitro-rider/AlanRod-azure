terraform {
  required_providers {
    azurerm     = {
      source    = "hashicorp/azurerm"
      version   = "=3.0.0"
    }
  }
}

provider "azurerm" {
  subscription_id   = ""
  client_id         = ""
  client_secret     = ""
  tenant_id         = ""
  features {}
}

locals {
  resource_group  = "app-grp"
  location        = "North Europe"
}

data "azurerm_subnet" "SubnetA" {
  name = "SubnetA"
  virtual_network_name = "app-networt"
  resource_group_name = local.resource_group
}

resource "azurerm_resource_group" "app_grp" {
    name        = local.resource_group
    location    = local.location
}

resource "azurerm_storage_account" "store_account" {
  name                     = var.storage_account_name
  resource_group_name      = local.resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [ 
     azurerm_resource_group.app_grp
   ]
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = var.storage_account_name
  container_access_type = "blob"
  depends_on = [ 
    azurerm_storage_account.store_account ]
}

# Upload a local file onto the storage container
resource "azurerm_storage_blob" "sample" {
  name                   = "sample.txt"
  storage_account_name   = var.storage_account_name
  storage_container_name = "data"
  type                   = "Block"
  source                 = "sample.txt"
  depends_on = [ 
    azurerm_storage_container.data
   ]
}

