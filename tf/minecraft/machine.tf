module "ssh_key" {
  source = "../../../infra/tf/modules/hetzner_ssh_key/data"
}

module "node_minecraft" {
  source     = "../../../infra/tf/modules/hetzner_server"
  name       = "minecraft"
  hardware   = "cax21"
  backups    = true
  ssh_key_id = module.ssh_key.id
  datacenter = "hel1-dc2"

  firewall_rules = [{
    direction  = "in"
    protocol   = "tcp"
    port       = "25575"
    source_ips = ["0.0.0.0/0", "::/0"]
    }, {
    direction  = "in"
    protocol   = "udp"
    port       = "25575"
    source_ips = ["0.0.0.0/0", "::/0"]
    }
  ]
}
