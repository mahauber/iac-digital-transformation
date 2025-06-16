terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "88155474-d55e-4910-9a6f-9ea5ccc6d281"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-neu-dev-demo-0"
  location = "North Europe"
}