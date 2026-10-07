resource "azurerm_resource_group" "main" {
  name     = "rg-devops-project-dev"
  location = "West Europe"

  tags = {
    environment = "dev"
    project     = "azure-devops-project"
    managed_by  = "terraform"
  }
}
