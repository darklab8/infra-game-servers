
locals {
  chart_path = "${path.module}/../../charts/minecraft"
  # This hash forces Terraform to redeploy if a new template file is added or changed, or values are updated
  chart_hash  = sha1(join("", [for f in fileset(local.chart_path, "**/*ml") : filesha1("${local.chart_path}/${f}")]))
  environment = var.environment
}

resource "helm_release" "minecraft" {
  name             = "minecraft"
  chart            = "../charts/minecraft"
  create_namespace = true
  namespace        = "minecraft"
  force_update     = false
  reset_values     = true
  recreate_pods    = true

  values = [
    <<-EOT
    hard_memory_limit: "${var.limit.hard_memory}"
    hard_cpu_limit: "${var.limit.hard_cpu}"
    hostname: "${var.environment}-cluster"
    image_version: "${var.image_version}"
    ENVIRONMENT: "${var.environment}"
    EOT
  ]
  set {
    name  = "chartHash"
    value = local.chart_hash
  }
}
