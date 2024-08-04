terraform {
  required_providers {
    docker = {
      source                = "kreuzwerker/docker"
      version               = ">=3.0.2"
      configuration_aliases = [docker.minecraft]
    }
  }
}