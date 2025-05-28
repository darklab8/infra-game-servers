variable "image_id" {
  type = string

}

variable "restart" {
  type        = string
  description = "always or no"
}

variable "data_path" {
  type        = string
  description = "path to"
}

variable authlib_auth_server {
  type = string
  default = ""
}

resource "docker_container" "minecraft" {
  name  = "minecraft"
  image = var.image_id

  tty        = true
  stdin_open = true

  # env = toset([
  #   "AUTHLIB_AUTH_SERVER=${var.authlib_auth_server}",
  # ])

  log_opts = {
    "mode" : "non-blocking"
    "max-buffer-size" : "500m"
  }
  volumes {
    container_path = "/code/logs"
    host_path      = "${var.data_path}/logs"
  }
  volumes {
    container_path = "/code/world"
    host_path      = "${var.data_path}/world"
  }
  volumes {
    container_path = "/code/plugins/LoginSecurity"
    host_path      = "${var.data_path}/plugins/LoginSecurity"

  }
  volumes {
    container_path = "/code/plugins/WorldGuard"
    host_path      = "${var.data_path}/plugins/WorldGuard"

  }
  volumes {
    container_path = "/code/plugins/WorldEdit"
    host_path      = "${var.data_path}/plugins/WorldEdit"
  }

  volumes {
    container_path = "/code/asm"
    host_path      = "${var.data_path}/asm"

  }
  volumes {
    container_path = "/code/mohist-config"
    host_path      = "${var.data_path}/mohist-config"
  }

  mounts {
    read_only = false
    source    = "${var.data_path}/configs/banned-ips.json"
    target    = "/code/banned-ips.json"
    type      = "bind"
  }
  mounts {
    read_only = false
    source    = "${var.data_path}/configs/banned-players.json"
    target    = "/code/banned-players.json"
    type      = "bind"
  }
  mounts {
    read_only = false
    source    = "${var.data_path}/configs/ops.json"
    target    = "/code/ops.json"
    type      = "bind"
  }

  mounts {
    read_only = false
    source    = "${var.data_path}/configs/whitelist.json"
    target    = "/code/whitelist.json"
    type      = "bind"
  }
  mounts {
    read_only = false
    source    = "${var.data_path}/configs/usercache.json"
    target    = "/code/usercache.json"
    type      = "bind"
  }

  ports {
    external = 25575
    internal = 25565
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  ports {
    external = 25861
    internal = 25861
    ip       = "127.0.0.1"
  }

  lifecycle {
    ignore_changes = [
      memory_swap,
    ]
  }
}

locals {
  project_folder = abspath("${path.module}/../../../server_modded_1710")
}