provider "helm" {
  kubernetes {
    config_path = "~/.kube/prod_minecraft_config"
  }
}

module "minecraft" {
  source = "../modules/minecraft"

  environment = "prod"
  limit = {
    hard_memory = 14000
    hard_cpu    = 3500
  }
  image_version = "modded-12.2-v0.1.2"
}
