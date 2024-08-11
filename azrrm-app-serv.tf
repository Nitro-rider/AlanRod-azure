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

resource "azurerm_resource_group" "app_grp" {
    name        = local.resource_group
    location    = local.location
}

resource "azurerm_app_service_plan" "app_plan1001" {
  name                = "app-plan1001"
  location            = local.location
  resource_group_name = local.resource_group

  sku {
    tier = "free"
    size = "F1"
  }
}

resource "azurerm_app_service" "app_serv1001" {
  name                = "app-service1001"
  location            = local.location
  resource_group_name = local.resource_group
  app_service_plan_id = azurerm_app_service_plan.app_plan1001.id

}