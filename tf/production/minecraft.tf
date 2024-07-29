
module "server" {
  source = "../../../infra/tf/modules/hetzner_server/data"
  name   = "node-arm"
}

module "dns" {
  source = "../../../infra/tf/modules/cloudflare_dns"
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

provider "docker" {
  host     = "ssh://root@${module.server.ipv4_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

data "external" "secrets_minecrafter" {
  program = ["pass", "api/personal/terraform/hetzner/minecrafter/production"]
}

locals {
  minecrafter_secrets = nonsensitive(data.external.secrets_minecrafter.result)
}

module "minecrafter" {
  source      = "../modules/gamebot"
  image       = "minecrafter"
  tag_version = "v0.21"
  env_list = [
    "DISCORD_BOT_TOKEN=${local.minecrafter_secrets["DISCORD_BOT_TOKEN"]}",
    "DISCORD_CHANNEL_ID=869888658033999873",
    "DARKBOT_LOG_LEVEL=WARN"
  ]
}
