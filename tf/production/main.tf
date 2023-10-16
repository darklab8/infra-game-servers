module "key" {
  source = "../modules/hetzner_sshkey"
}

module "server" {
  source       = "../modules/hetzner_server"
  environment  = "production"
  server_power = "cpx21"
  name         = "minecraft"
  ssh_keys = [
    module.key.darklab_id
  ]
}

locals {
  zone = "dd84ai.com"
}

module "dns" {
  source = "../modules/cloudflare_dns"
  zone   = local.zone
  dns_records = [
    {
      type    = "A"
      value   = module.server.ipv4_address
      name    = "production.minecraft.${local.zone}"
      proxied = false
    },
  ]
}
