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

locals {
  container_apps = [
    {
      name  = "simple-python"
      image = "docker.io/k8stpy/simple-python:latest"
      port  = 8080
    },
    {
      name  = "demo-container"
      image = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      port  = 80
    }
  ]
}

resource "azurerm_container_app" "app" {
  for_each = { for app in local.container_apps : app.name => app }

  name                         = "ca-${var.location_code}-${var.environment}-${var.project_name}-${each.value.name}"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = each.value.name
      image  = each.value.image
      cpu    = 0.5
      memory = "1.0Gi"
    }

    min_replicas = 1
    max_replicas = 2
  }

  ingress {
    external_enabled = true
    target_port      = each.value.port
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
