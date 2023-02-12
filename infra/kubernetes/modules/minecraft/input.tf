variable "environment" {
  type = string
}

variable "image_version" {
  type        = string
  description = "minecraft image version"
}

variable "limit" {
  type = object({
    hard_memory = string
    hard_cpu    = string
  })
}
