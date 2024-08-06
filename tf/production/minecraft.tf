
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
  alias    = "minecraft"
  host     = "ssh://root@${module.server.ipv4_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

data "external" "secrets_minecrafter" {
  program = ["pass", "personal/terraform/hetzner/minecrafter/production"]
}

locals {
  minecrafter_secrets = nonsensitive(data.external.secrets_minecrafter.result)
}

module "minecrafter" {
  providers = {
    docker = docker.minecraft
  }
  source      = "../modules/gamebot"
  image       = "minecrafter"
  tag_version = "v0.21"
  env_list = [
    "DISCORD_BOT_TOKEN=${local.minecrafter_secrets["DISCORD_BOT_TOKEN"]}",
    "DISCORD_CHANNEL_ID=869888658033999873",
    "DARKBOT_LOG_LEVEL=WARN"
  ]
}

resource "docker_image" "minecraft" {
  provider     = docker.minecraft
  name         = "darkwind8/minecraft:modded-1.7.10-v0.4.0"
  # keep_locally = true
}

module "minecraft" {
  source = "../modules/minecraft"
  providers = {
    docker.minecraft : docker.minecraft,
  }
  image_id = docker_image.minecraft.image_id
  restart  = "on-failure"
  data_path = "/var/lib/darklab/darklab_minecraft/server_modded_1710/data"
}