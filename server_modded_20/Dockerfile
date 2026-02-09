# FROM ubuntu:22.04
FROM library/eclipse-temurin:21.0.10_7-jdk-noble

# Create directories app_home and static directories
WORKDIR /code

COPY libraries /code/libraries
COPY mods /code/mods
COPY plugins /code/plugins
COPY server/* /code/
COPY server/forge_1201_files /code/forge_1201_files

# searcg engine list here: https://github.com/itzg/docker-minecraft-server
# discussions: https://www.spigotmc.org/threads/i-need-server-software-that-lets-me-use-forge-mods-spigot-plugins.252711/
# chosen: https://github.com/MohistMC/Mohist
CMD java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.20.1-47.4.10/unix_args.txt -jar server.jar
