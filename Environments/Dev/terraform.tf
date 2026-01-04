terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "state-storage"
    storage_account_name = "tfpipestatestorage"
    container_name       = "state"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}


provider "azurerm" {
  features {}
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID for KV auth"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_public_ip" "example" {
  count               = 5
  name                = "adam-example-pip-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}