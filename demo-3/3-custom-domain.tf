resource "cloudflare_dns_record" "domain_verification" {
  for_each = { for app in local.container_apps : app.name => app }

  zone_id = "bb6f8fe1622eef68d50a90eede65dffc" # k8st.cc
  comment = "Domain verification record"
  content = azurerm_container_app.app[each.value.name].custom_domain_verification_id
  name    = "asuid.${each.value.name}.k8st.cc"
  ttl     = 1
  type    = "TXT"
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [cloudflare_dns_record.domain_verification]

  create_duration = "30s"
}

resource "azurerm_container_app_custom_domain" "app" {
  for_each = { for app in local.container_apps : app.name => app }

  name             = "${each.value.name}.k8st.cc"
  container_app_id = azurerm_container_app.app[each.value.name].id

  depends_on = [time_sleep.wait_30_seconds]

  lifecycle {
    ignore_changes = [certificate_binding_type, container_app_environment_certificate_id]
  }
}

resource "cloudflare_dns_record" "app" {
  for_each = { for app in local.container_apps : app.name => app }

  zone_id = "bb6f8fe1622eef68d50a90eede65dffc" # k8st.cc
  comment = "Domain verification record"
  content = azurerm_container_app.app[each.value.name].ingress[0].fqdn
  name    = "${each.value.name}.k8st.cc"
  proxied = false
  ttl     = 1
  type    = "CNAME"
}

resource "null_resource" "custom_domain_and_managed_certificate" {
  for_each = { for app in local.container_apps : app.name => app }

  provisioner "local-exec" {
    command = "az containerapp hostname bind --hostname ${var.dns_name}.${var.dns_zone_name} -g ${var.resource_group_name} -n ${var.name} --environment ${var.container_app_environment_name} --validation-method CNAME"
  }
  triggers = {
    settings = module.composite_container_app_dns_records[0].dns_cname_record_id
  }
  depends_on = [module.composite_container_app_dns_records]
}
