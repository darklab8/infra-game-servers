resource "docker_image" "minecraft_crontab" {
  provider     = docker.minecraft
  name         = "darkwind8/minecraft:modded-1.7.10-crontab-v0.1.0"
  keep_locally = true
}

resource "docker_container" "minecraft_crontab" {
  provider = docker.minecraft

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