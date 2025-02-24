# data "external" "secrets_minecrafter" {
#   program = ["pass", "personal/terraform/hetzner/minecrafter/production"]
# }

# locals {
#   minecrafter_secrets = nonsensitive(data.external.secrets_minecrafter.result)
# }

# resource "docker_image" "bot" {
#   provider = docker.minecraft
#   name         = "darkwind8/minecrafter:v0.22"
#   keep_locally = true
# }

# module "minecrafter" {
#   providers = {
#     docker = docker.minecraft
#   }
#   source      = "../modules/gamebot"
#   image_id       = docker_image.bot.image_id
#   container_name = "minecrafter"
#   env_list = [
#     "DISCORD_BOT_TOKEN=${local.minecrafter_secrets["DISCORD_BOT_TOKEN"]}",
#     "DISCORD_CHANNEL_ID=869888658033999873,1276328321054937148,1277293572277801095",
#     "DARKBOT_LOG_LEVEL=WARN"
#   ]
# }
