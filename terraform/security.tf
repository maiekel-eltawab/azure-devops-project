resource "azurerm_network_security_group" "database" {
  name                = "nsg-database-dev"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = "dev"
    project     = "azure-devops-project"
    managed_by  = "terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}

