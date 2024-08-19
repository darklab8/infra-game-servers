provider "docker" {
  alias = "minecraft"
  host  = "unix:///var/run/docker.sock"
}

locals {
  minecraft_folder = abspath("${path.module}/../../server_modded_1710")
}

resource "docker_image" "minecraft" {
  provider = docker.minecraft
  name = "darkwind8/minecraft:modded-1.7.10-develop"

  build {
    context    = local.minecraft_folder
    dockerfile = "Dockerfile"
    label = {
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

module "minecraft_init_data" {
  source = "../modules/ansible_init_data"
  is_local  = true
  data_path = local.data_path
  hostname  = "localhost"
  image_id = docker_image.minecraft.image_id
}

module "minecraft" {
  source = "../modules/minecraft"
  providers = {
    docker.minecraft : docker.minecraft,
  }
  image_id = docker_image.minecraft.image_id
  restart  = "no"

  data_path = local.data_path

  depends_on = [
    module.minecraft_init_data,
  ]
}

locals {
  data_path = abspath("${path.module}/data")
}

