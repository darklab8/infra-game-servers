module "dns_drasl" {
  source = "../../../infra/tf/modules/cloudflare_dns"
  zone   = local.zone
  dns_records = [
    {
      type    = "A"
      value   = module.server.ipv4_address
      name    = "drasl.${local.zone}"
      proxied = false
    },
  ]
}

# TODO add DRASL it here.