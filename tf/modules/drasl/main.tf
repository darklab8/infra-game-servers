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

resource "docker_container" "drasl" {
  name  = "drasl"
  image = "unmojang/drasl"

  volumes {
    host_path      = "/srv/drasl/data"
    container_path = "/var/lib/drasl"
    read_only      = false
  }

  lifecycle {
    ignore_changes = [
      memory_swap,
    ]
  }
}
