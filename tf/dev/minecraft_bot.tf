
data "external" "secrets_minecrafter" {
  program = ["pass", "personal/terraform/hetzner/minecrafter/staging"]
}

locals {
  minecrafter_secrets = nonsensitive(data.external.secrets_minecrafter.result)
}

resource "docker_image" "bot" {
  name = "darkwind8/minecrafter:develop"

  build {
    context    = abspath("${path.module}/../..")
    dockerfile = "Dockerfile"
    target     = "minecrafter-runner"
    label = {
      hash : module.folder_hash.hash
    }
  }
  keep_locally = true
}

module "minecrafter" {
  source         = "../modules/gamebot"
  image_id       = docker_image.bot.image_id
  container_name = "minecrafter"
  env_list = [
    "DISCORD_BOT_TOKEN=${local.minecrafter_secrets["DISCORD_BOT_TOKEN"]}",
    "DISCORD_CHANNEL_ID=1175586231145467935",
    "DARKBOT_LOG_LEVEL=WARN"
  ]
}
