# data "external" "secrets_avorioner" {
#   program = ["pass", "personal/terraform/hetzner/avorioner/production"]
# }

# locals {
#   avorioner_secrets = nonsensitive(data.external.secrets_avorioner.result)
# }

# module "avorioner" {
#   providers = {
#     docker = docker.avorion
#   }
#   source      = "../modules/gamebot"
#   image       = "avorioner"
#   tag_version = "v0.21"
#   env_list = [
#     "DISCORD_BOT_TOKEN=${local.avorioner_secrets["DISCORD_BOT_TOKEN"]}",
#     "DISCORD_CHANNEL_ID=1099023902887399474",
#     "DARKBOT_LOG_LEVEL=WARN",
#     "AVORIONER_DARKWIND_CHANNEL_ID=1175841486718373939",
#     "AVORIONER_OTHERS_CHANNEL_ID=1175845824035569764",
#   ]
# }