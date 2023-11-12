# Create a docker image resource
# -> docker pull nginx:latest
resource "docker_image" "minecrafter" {
  name         = "darkwind8/minecrafter:${var.tag_version}"
  keep_locally = true
}

variable "tag_version" {
  type = string
}

variable "debug" {
  type    = bool
  default = false
}

variable "secrets" {
  type = map(string)
}

resource "docker_container" "minecrafter" {
  name  = "minecrafter"
  image = docker_image.minecrafter.image_id

  env = [
    "DISCORD_BOT_TOKEN=${var.secrets["DISCORD_BOT_TOKEN"]}",
    "MINECRAFTER_CHANNEL_ID=869888658033999873",
    "DARKBOT_LOG_LEVEL=${var.debug ? "DEBUG" : "WARN"}"
  ]

  restart = "always"
  volumes {
    container_path = "/var/run/docker.sock"
    read_only      = true
    host_path      = "/var/run/docker.sock"
  }

  memory = 1000 # MBs

  lifecycle {
    ignore_changes = [
      memory_swap,
    ]
  }
}
