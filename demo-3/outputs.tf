output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

# output "container_app_fqdns" {
#   value = azurerm_container_app.app[*].latest_revision_fqdn
#   description = "The fully qualified domain name (FQDN) of the container app."
# }

# output "domain_name" {
#   value = cloudflare_dns_record.app[*].name
# }