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
