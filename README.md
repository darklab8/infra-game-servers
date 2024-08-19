# Description

Infra mono repo with game server builds and deployments and bot augmentations for integration with Discord

list of game servers

- Avorion
- Minecraft from 1.7.10 to 1.12.2 (modded and vanilla)

### Description for minecraft server_modded_1710

- It is dockerized modded minecraft for 1.7.10 version, built in minimalistic in terms of dependencies to make it happen (not including into this evaluation amount of mods).
- The minecraft dockerization was made with attempt to follow best practices of docker where all dependencies are actually indeed frozen at a build time.
    - WIth disabled internet connection, it was tested to be still initializing server and working correctly :]
    - This is made in mind that this minecraft will be used in long term for game sessions lasting a year at least or longer
    - this also makes possible properly having iac/gitops stuff regarding it applied.

## Getting started with development

for docker-compose of a current minecraft server only (try this first and connect with client):

- `cd server_modded_1710`
- `task server:debug:rerun`

for terraform version for everything:

- Assuming u have right secrets in [pass](https://www.passwordstore.org/) storage
- Just `cd tf/dev` and `terragrunt apply` everything, it should raise modded minecraft server 1.7.10 and rest of infrastructure


## Deploying

WARNING: development locally is made in amd64, but final docker images are saved as arm64 (because arm64 servers are twice cheaper at Herzner where we host them)

terraform (assuming u have configured secrets in pass, which would be looking in json parsable format):

```sh
$ pass personal/terraform/hetzner/minecrafter/production
{
  "DISCORD_BOT_TOKEN": "1111111111111111111111.33333.222222222222222222222222"
}
```
- `cd tf/production && terragrunt apply`

## Connecting as client

[See README.connect.modded1.7.10.md](./README.connect.modded1.7.10.md) for client connecting instruction

## Releasing new versions

Check main [Taskfile.yml](./Taskfile.yml)
it has command like `task minecraft:docker:build && task minecraft:docker:push`

## Dependencies

- [Docker](https://docs.docker.com/engine/install/ubuntu/) for any app deployment. invoked from tofu
- [Opentofu](https://opentofu.org/) to keep remote server very clean and as main infra glue
- [Ansible](https://docs.ansible.com/ansible/latest/getting_started/index.html) is invoked from tofu to initlalize things
- [Taskfile.dev](https://taskfile.dev/) for dev env scripts
- [pass](https://www.passwordstore.org/) for keeping secrets out of this repo and injecting easily into tofu.
- [Golang](https://go.dev/) for bot writing, to intergrate game server into Discord
