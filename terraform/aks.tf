resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-devops-project-dev"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-devops-dev"

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "Standard_B2s_v2"
    vnet_subnet_id = azurerm_subnet.aks.id

    upgrade_settings {
      max_surge                     = "10%"
      drain_timeout_in_minutes      = 0
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"

    service_cidr   = "10.10.0.0/16"
    dns_service_ip = "10.10.0.10"
  }

  tags = {
    environment = "dev"
    project     = "azure-devops-project"
    managed_by  = "terraform"
  }
}
