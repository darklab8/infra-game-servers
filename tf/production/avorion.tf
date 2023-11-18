module "avorion_server" {
  source       = "../modules/hetzner_server"
  environment  = "production"
  server_power = "cpx31"
  name         = "avorion"
  ssh_keys = [
    module.key.darklab_id
  ]
}

module "avorion_dns" {
  source = "../modules/cloudflare_dns"
  zone   = local.zone
  dns_records = [
    {
      type    = "A"
      value   = module.avorion_server.ipv4_address
      name    = "production.avorion.${local.zone}"
      proxied = false
    },
  ]
}

provider "docker" {
  alias = "avorion"
  host     = "ssh://root@${module.avorion_server.ipv4_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

resource "docker_image" "avorion" {
  provider = docker.avorion
  name         = "rfvgyhn/avorion:2.3.1.40236"
  keep_locally = true
}

# docker run -d -it --name avorion -p 27000:27000 -p 27000:27000/udp -p 27003:27003/udp -p 27020:27020/udp -p 27021:27021/udp -v /var/lib/avorion:/home/steam/.avorion/galaxies/avorion_galaxy rfvgyhn/avorion:2.3.1.40236
resource "docker_container" "avorion" {
  provider = docker.avorion
  name  = "avorion"
  image = docker_image.avorion.image_id

  tty = true
  stdin_open = true

  volumes {
    container_path = "/home/steam/.avorion/galaxies/avorion_galaxy"
    read_only      = false
    host_path      = "/var/lib/avorion"
  }

  ports {
    internal = "27000"
    external = "27000"
  }

  ports {
    internal = "27000"
    external = "27000"
    protocol = "udp"
  }

  ports {
    internal = "27003"
    external = "27003"
    protocol = "udp"
  }

  ports {
    internal = "27020"
    external = "27020"
    protocol = "udp"
  }

  ports {
    internal = "27021"
    external = "27021"
    protocol = "udp"
  }

  lifecycle {
    ignore_changes = [
      memory_swap,
    ]
  }
}
