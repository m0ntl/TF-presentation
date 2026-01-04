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

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

//Adding comment
//Adding comment 2
