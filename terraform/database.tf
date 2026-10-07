resource "azurerm_virtual_network" "database" {
  name                = "vnet-database-dev"
  address_space       = ["10.20.0.0/16"]
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = "dev"
    project     = "azure-devops-project"
    managed_by  = "terraform"
  }
}

resource "azurerm_subnet" "database_northeurope" {
  name                 = "snet-database-ne-dev"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.database.name
  address_prefixes     = ["10.20.1.0/24"]

  delegation {
    name = "postgresql-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_virtual_network_peering" "main_to_database" {
  name                      = "peer-main-to-database"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = azurerm_virtual_network.database.id
}

resource "azurerm_virtual_network_peering" "database_to_main" {
  name                      = "peer-database-to-main"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.database.name
  remote_virtual_network_id = azurerm_virtual_network.main.id
}


resource "azurerm_private_dns_zone" "postgresql" {
  name                = "devops-project.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = "dev"
    project     = "azure-devops-project"
    managed_by  = "terraform"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                  = "postgresql-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = azurerm_virtual_network.main.id
  resource_group_name   = azurerm_resource_group.main.name

  registration_enabled = false
}
resource "azurerm_postgresql_flexible_server" "main" {
  name                = "psql-devops-project-dev"
  resource_group_name = azurerm_resource_group.main.name
  location            = "North Europe"

  version = "16"

  delegated_subnet_id           = azurerm_subnet.database_northeurope.id
  private_dns_zone_id           = azurerm_private_dns_zone.postgresql.id
  public_network_access_enabled = false

  administrator_login    = "devopsadmin"
  administrator_password = var.postgresql_admin_password

  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  backup_retention_days = 7

  tags = {
    environment = "dev"
    project     = "azure-devops-project"
    managed_by  = "terraform"
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgresql
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_database" {
  name                  = "postgresql-database-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = azurerm_virtual_network.database.id
  resource_group_name   = azurerm_resource_group.main.name

  registration_enabled = false
}
