resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-${var.location_code}-${var.environment}-${var.project_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "env" {
  name                       = "cae-${var.location_code}-${var.environment}-${var.project_name}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

resource "azurerm_container_app" "app" {
  name                         = "ca-${var.location_code}-${var.environment}-${var.project_name}-simple-python"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "simple-python"
      image  = "docker.io/k8stpy/simple-python:latest"
      cpu    = 0.5
      memory = "1.0Gi"
    }

    min_replicas = 1
    max_replicas = 2
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
