resource "cloudflare_dns_record" "example_dns_record" {
  zone_id = "bb6f8fe1622eef68d50a90eede65dffc" # k8st.cc
  comment = "Domain verification record"
  content = "8.8.8.8"
  name = "k8st.cc"
  proxied = true
  ttl = 1
  type = "A"
}