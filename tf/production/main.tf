module "ssh_key" {
   source       = "../../../infra/tf/modules/hetzner_ssh_key/data"
}

locals {
  zone = "dd84ai.com"
}
