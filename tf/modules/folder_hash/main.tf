variable "directory" {
  description = "Build files directory"
  type        = string
}

variable "exclusions" {
  type    = list(string)
  default = []
}

locals {
  templates_directory = var.directory
  template_hashes = {
    for path in sort(fileset(local.templates_directory, "**")) :
    path => filebase64sha512("${local.templates_directory}/${path}")
    if !contains(var.exclusions, path)
  }
  hash = base64sha512(jsonencode(local.template_hashes))
}

output "paths" {
  value = {
    for path in sort(fileset(local.templates_directory, "**")) :
    path => path
    if !contains(var.exclusions, path)
  }
}

output "hash" {
  value = local.hash
}
