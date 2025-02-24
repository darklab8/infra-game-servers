
# module "server" {
#   source = "../../../infra/tf/modules/hetzner_server/data"
#   name   = "node-arm"
# }

# module "dns" {
#   source = "../../../infra/tf/modules/cloudflare_dns"
#   zone   = local.zone
#   dns_records = [
#     {
#       type    = "A"
#       value   = module.server.ipv4_address
#       name    = "production.minecraft.${local.zone}"
#       proxied = false
#     },
#   ]
# }

# provider "docker" {
#   alias    = "minecraft"
#   host     = "ssh://root@${module.server.ipv4_address}:22"
#   ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
# }

# resource "docker_image" "minecraft" {
#   provider = docker.minecraft
#   name     = "darkwind8/minecraft:modded-1.7.10-v0.5.4"
#   # keep_locally = true
# }

locals {
  data_path = "/var/lib/darklab/darklab_minecraft/server_modded_1710/data"
}

# module "minecraft_init_data" {
#   source = "../modules/minecraft/init_data"
#   is_local = false
#   data_path = local.data_path
#   hostname  = "darklab"
#   image_id = docker_image.minecraft.image_id
# }

# module "minecraft" {
#   source = "../modules/minecraft"
#   providers = {
#     docker.minecraft : docker.minecraft,
#   }
#   image_id  = docker_image.minecraft.image_id
#   restart   = "on-failure"
#   data_path = local.data_path

#   depends_on = [
#     module.minecraft_init_data,
#   ]
#   authlib_auth_server = "http://drasl.dd84ai.com:25585"
# }
