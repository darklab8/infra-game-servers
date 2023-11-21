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
  alias    = "avorion"
  host     = "ssh://root@${module.avorion_server.ipv4_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

resource "docker_image" "avorion" {
  provider     = docker.avorion
  name         = "rfvgyhn/avorion:2.3.1.40236"
  keep_locally = true
}

# docker run -d -it --name avorion -p 27000:27000 -p 27000:27000/udp -p 27003:27003/udp -p 27020:27020/udp -p 27021:27021/udp -v /var/lib/avorion:/home/steam/.avorion/galaxies/avorion_galaxy rfvgyhn/avorion:2.3.1.40236
resource "docker_container" "avorion" {
  provider = docker.avorion
  name     = "avorion"
  image    = docker_image.avorion.image_id

  tty        = true
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

data "aws_ssm_parameter" "avorioner" {
  name = "/terraform/hetzner/avorioner/production"
}

locals {
  avorioner_secrets = nonsensitive(jsondecode(data.aws_ssm_parameter.avorioner.value))
}

module "avorioner" {
  providers = {
    docker = docker.avorion
  }
  source      = "../modules/gamebot"
  image       = "avorioner"
  tag_version = "v0.13"
  env_list = [
    "DISCORD_BOT_TOKEN=${local.avorioner_secrets["DISCORD_BOT_TOKEN"]}",
    "DISCORD_CHANNEL_ID=1099023902887399474",
    "DARKBOT_LOG_LEVEL=WARN",
    "AVORIONER_DARKWIND_CHANNEL_ID=1175841486718373939",
    "AVORIONER_OTHERS_CHANNEL_ID=1175845824035569764",
  ]
}
