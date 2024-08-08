provider "docker" {
  alias = "minecraft"
  host  = "unix:///var/run/docker.sock"
}

locals {
  minecraft_folder = abspath("${path.module}/../../server_modded_1710")
}

resource "docker_image" "minecraft" {
  provider = docker.minecraft
  # name         = "darkwind8/minecraft:modded-1.7.10-v0.3.1"
  name = "darkwind8/minecraft:modded-1.7.10-develop"

  build {
    context    = local.minecraft_folder
    dockerfile = "Dockerfile"
    label = {
      author : "andrei.novoselov"
      hash : module.folder_hash.hash
    }
  }
  keep_locally = true
}

module "folder_hash" {
  source    = "../modules/folder_hash"
  directory = "${path.module}/../../server_modded_1710"
  exclusions = [
    for path in sort(fileset("${path.module}/../../server_modded_1710/crontab", "**")) :
    "crontab/${path}"
  ]
}

# output folder_hash_paths {
#   value = module.folder_hash.paths
# }

module "minecraft" {
  source = "../modules/minecraft"
  providers = {
    docker.minecraft : docker.minecraft,
  }
  image_id = docker_image.minecraft.image_id
  restart  = "no"

  data_path = local.data_path
}

locals {
  data_path = abspath("${path.module}/data_prod/data")
}
# mkdir tf/dev/data && cp -r server_modded_1710/configs tf/dev/data
# before first launch

# data "external" "secrets_minecrafter" {
#   program = ["pass", "personal/terraform/hetzner/minecrafter/production"]
# }

# locals {
#   minecrafter_secrets = nonsensitive(data.external.secrets_minecrafter.result)
# }

# module "minecrafter" {
#   providers = {
#     docker = docker.minecraft
#   }
#   source      = "../modules/gamebot"
#   image       = "minecrafter"
#   tag_version = "v0.21"
#   env_list = [
#     "DISCORD_BOT_TOKEN=${local.minecrafter_secrets["DISCORD_BOT_TOKEN"]}",
#     "DISCORD_CHANNEL_ID=869888658033999873",
#     "DARKBOT_LOG_LEVEL=WARN"
#   ]
# }

