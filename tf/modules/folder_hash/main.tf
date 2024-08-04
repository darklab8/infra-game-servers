variable "directory" {
  description = "Build files directory"
  type        = string
}

locals {
  templates_directory = var.directory
  template_hashes = {
    for path in sort(fileset(local.templates_directory, "**")) :
    path => filebase64sha512("${local.templates_directory}/${path}")
  }
  hash = base64sha512(jsonencode(local.template_hashes))
}

output "hash" {
  value = local.hash
}
