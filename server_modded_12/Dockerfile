FROM ubuntu:22.04
# FROM library/eclipse-temurin:21.0.10_7-jdk-noble

# Create directories app_home and static directories
WORKDIR /code

RUN apt update
RUN apt-get install -y openjdk-8-jre
RUN apt-get install -y openjfx

COPY libraries /code/libraries
COPY mods /code/mods
COPY plugins /code/plugins
COPY server/* /code/

COPY permissions.yml ./

# searcg engine list here: https://github.com/itzg/docker-minecraft-server
# discussions: https://www.spigotmc.org/threads/i-need-server-software-that-lets-me-use-forge-mods-spigot-plugins.252711/
# chosen: https://github.com/MohistMC/Mohist
# CMD java -jar forge-1.12.2-14.23.5.2859.jar
CMD java -jar mohist-1.12.2-319-server.jar
