
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">=3.0.2"
    }
  }
}
