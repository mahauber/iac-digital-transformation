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

variable "environment" {
  type        = string
  description = "The environment for the resources, e.g., dev, test, prod."
  default     = "dev"  
}

variable "cloudflare_api_token" {
  type        = string
  description = "The Cloudflare API token to use for managing resources."
}