resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  for_each = {
    "sub1" = "10.0.1.0/24"
    "sub2" = "10.0.2.0/24"
  }
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name

  name             = each.key
  address_prefixes = [each.value]
}