# module "avorion_server" {
#   source      = "../../../infra/tf/modules/hetzner_server"
#   name        = "node-amd64-avorion"
#   hardware    = "cx32"
#   datacenter  = "fsn1-dc14"
#   ssh_key_id  = "123"
#   environment = "production"
# }

# locals {
#     avorion_ip = "37.27.42.32"
# }

# module "avorion_dns" {
#   source = "../../../infra/tf/modules/cloudflare_dns"
#   zone   = local.zone
#   dns_records = [
#     {
#       type    = "A"
#       value   = local.avorion_ip
#       name    = "production.avorion.${local.zone}"
#       proxied = false
#     },
#   ]
# }

# provider "docker" {
#   alias    = "avorion"
#   host     = "ssh://root@${local.avorion_ip}:22"
#   ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
# }

# resource "docker_image" "avorion" {
#   provider     = docker.avorion
#   name         = "rfvgyhn/avorion:2.5.7.42203"
#   keep_locally = true
# }

# docker run --restart always -d -it --name avorion -p 27000:27000 -p 27000:27000/udp -p 27003:27003/udp -p 27020:27020/udp -p 27021:27021/udp -v /var/lib/avorion:/home/steam/.avorion/galaxies/avorion_galaxy rfvgyhn/avorion:2.5.5.42018
# resource "docker_container" "avorion" {
#   provider = docker.avorion
#   name     = "avorion"
#   image    = docker_image.avorion.image_id

#   tty        = true
#   stdin_open = true

#   volumes {
#     container_path = "/home/steam/.avorion/galaxies/avorion_galaxy"
#     read_only      = false
#     host_path      = "/var/lib/avorion"
#   }

#   ports {
#     internal = "27000"
#     external = "27000"
#   }

#   ports {
#     internal = "27000"
#     external = "27000"
#     protocol = "udp"
#   }

#   ports {
#     internal = "27003"
#     external = "27003"
#     protocol = "udp"
#   }

#   ports {
#     internal = "27020"
#     external = "27020"
#     protocol = "udp"
#   }

#   ports {
#     internal = "27021"
#     external = "27021"
#     protocol = "udp"
#   }

#   lifecycle {
#     ignore_changes = [
#       memory_swap,
#     ]
#   }
# }
