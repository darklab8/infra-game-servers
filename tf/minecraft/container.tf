module "dns" {
  source = "../../../infra/tf/modules/cloudflare_dns"
  zone   = local.zone
  dns_records = [
    {
      type    = "A"
      value   = module.node_minecraft.ipv4_address
      name    = "minecraft"
      proxied = false
    },
  ]
}

provider "docker" {
  host     = "ssh://root@${module.node_minecraft.ipv4_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

resource "docker_image" "minecraft" {
  name     = "darkwind8/modded-1.7.10-v0.6.1"
  # keep_locally = true
}

locals {
  data_path = "/var/lib/darklab/minecraft_data"
}

# module "minecraft_init_data" {
#   source = "../modules/minecraft_ctr/init_data"
#   is_local = false
#   data_path = local.data_path
#   hostname  = "minecraft"
#   image_id = docker_image.minecraft.image_id
# }

module "minecraft_ctr" {
  source = "../modules/minecraft_ctr"
  image_id  = docker_image.minecraft.image_id
  restart   = "on-failure"
  data_path = local.data_path

  # depends_on = [
  #   module.minecraft_init_data,
  # ]
  # authlib_auth_server = "http://drasl.dd84ai.com:25585"
}
