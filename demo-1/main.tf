terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID to use for the resources."
  default     = "88155474-d55e-4910-9a6f-9ea5ccc6d281"
}

variable "location" {
  type        = string
  description = "The Azure location to use for the resources."
  default     = "North Europe"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-neu-dev-demo-1"
  location = var.location
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}