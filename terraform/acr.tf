resource "azurerm_container_registry" "main" {
  name                = "acrdevopsprojectdev"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku           = "Basic"
  admin_enabled = false

  tags = {
    environment = "dev"
    project     = "azure-devops-project"
    managed_by  = "terraform"
  }
}
