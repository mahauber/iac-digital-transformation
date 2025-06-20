terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.33.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "time" {}