resource "cloudflare_dns_record" "domain_verification" {
  for_each = { for app in local.container_apps : app.name => app }

  zone_id = "bb6f8fe1622eef68d50a90eede65dffc" # k8st.cc
  comment = "Domain verification record"
  content = azurerm_container_app.app[each.value.name].custom_domain_verification_id
  name    = "asuid.${each.value.name}.k8st.cc"
  ttl     = 1
  type    = "TXT"
}

resource "cloudflare_dns_record" "app" {
  for_each = { for app in local.container_apps : app.name => app }

  zone_id = "bb6f8fe1622eef68d50a90eede65dffc" # k8st.cc
  comment = "Application DNS record"
  content = azurerm_container_app.app[each.value.name].ingress[0].fqdn
  name    = "${each.value.name}.k8st.cc"
  proxied = false
  ttl     = 1
  type    = "CNAME"
}

resource "time_sleep" "wait_20_seconds" {
  depends_on = [cloudflare_dns_record.domain_verification, cloudflare_dns_record.app]

  create_duration = "20s"
}

resource "azurerm_container_app_custom_domain" "app" {
  for_each = { for app in local.container_apps : app.name => app }

  name             = "${each.value.name}.k8st.cc"
  container_app_id = azurerm_container_app.app[each.value.name].id

  depends_on = [time_sleep.wait_20_seconds]

  lifecycle {
    ignore_changes = [certificate_binding_type, container_app_environment_certificate_id]
  }
}

# Add or update the hostname and binding with a certificate.
resource "terraform_data" "custom_domain_and_managed_certificate" {
  for_each = { for app in local.container_apps : app.name => app }

  provisioner "local-exec" {
    command = "az containerapp hostname bind --hostname ${each.value.name}.k8st.cc -g ${azurerm_resource_group.main.name} -n ${azurerm_container_app.app[each.value.name].name} --environment ${azurerm_container_app_environment.env.name} --subscription ${var.subscription_id} --validation-method CNAME"
  }
  triggers_replace = [azurerm_container_app_custom_domain.app[each.value.name].id]
  depends_on       = [azurerm_container_app_custom_domain.app]
}
