variable "environment" {
  type = string
}

variable "server_power" {
  type = string
}

variable "ssh_keys" {
  type = list(any)
}

variable "name" {
  default = "cluster"
  type    = string
}