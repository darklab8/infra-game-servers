module "ssh_key" {
  source = "../../../infra/tf/modules/hetzner_ssh_key/data"
}

module "node_minecraft" {
  source      = "../../../infra/tf/modules/hetzner_server"
  name        = "minecraft"
  hardware    = "cax21"
  backups     = true
  ssh_key_id  = module.ssh_key.id
  datacenter  = "hel1-dc2"
}
