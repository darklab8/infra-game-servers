locals {
  datacenter  = "ash-dc1" # USA
  server_type = var.server_power
  task_name   = "cluster"
}

data "hcloud_image" "default" {
  name = "docker-ce"
}

resource "hcloud_server" "cluster" {
  name        = "${var.environment}-${var.name}"
  image       = data.hcloud_image.default.id
  datacenter  = local.datacenter
  server_type = local.server_type
  ssh_keys    = var.ssh_keys
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  lifecycle {
    ignore_changes = [
      image,
    ]
  }
}

output "ipv4_address" {
  value = hcloud_server.cluster.ipv4_address
}
