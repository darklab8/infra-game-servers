# Create a docker image resource
# -> docker pull nginx:latest
resource "docker_image" "bot" {
  name         = "darkwind8/${var.image}:${var.tag_version}"
  keep_locally = true
}

variable "image" {
  type = string
}

variable "tag_version" {
  type = string
}

variable "debug" {
  type    = bool
  default = false
}

variable "env_list" {
  type = list(string)
}

resource "docker_container" "minecrafter" {
  name  = var.image
  image = docker_image.bot.image_id

  env = var.env_list

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
