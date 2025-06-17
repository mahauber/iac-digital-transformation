output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "container_app_fqdns" {
  value = [
    for app in local.container_apps : azurerm_container_app.app[app.name].ingress[0].fqdn
  ]
  description = "The fully qualified domain name (FQDN) of the container app."
}