module "folder_hash_crontab" {
  source    = "../modules/folder_hash"
  directory = "${path.module}/../../server_modded_1710/crontab"
}

resource "docker_image" "minecraft_crontab" {
  name     = "darkwind8/minecraft:modded-1.7.10-crontab-v0.0.1"

  build {
    context    = "${local.minecraft_folder}/crontab"
    dockerfile = "Dockerfile"
    label = {
      hash : module.folder_hash_crontab.hash
    }
  }
  keep_locally = true
}

resource "docker_container" "minecraft_crontab" {
  name  = "minecraft_crontab"
  image = docker_image.minecraft_crontab.image_id

  tty        = true
  stdin_open = true

  # Data.

  mounts {
    read_only = false
    source    = "/var/run/docker.sock"
    target    = "/var/run/docker.sock"
    type      = "bind"
  }

  lifecycle {
    ignore_changes = [
      memory_swap,
    ]
  }
}