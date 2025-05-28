variable "container_name" {
  type = string
}

variable "image_id" {
  type = string
}

variable "debug" {
  type    = bool
  default = false
}

variable "env_list" {
  type = list(string)
}

resource "docker_container" "gamebot" {
  name  = var.container_name
  image = var.image_id

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
