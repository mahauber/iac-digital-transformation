resource "azurerm_resource_group" "main" {
  name     = "rg-${var.location_code}-${var.environment}-${var.project_name}"
  location = var.location
}