FROM ubuntu:22.04

# Create directories app_home and static directories.
WORKDIR /code

RUN apt update
RUN apt-get install -y openjdk-8-jre
RUN apt-get install -y openjfx

COPY plugins plugins
COPY mods mods
RUN rm mods/tlskincape*.jar mods/OptiFine*.jar | true
RUN ls mods
COPY server/forge-1.7.10-10.13.4.1614-1.7.10-universal.jar server/minecraft_server.1.7.10.jar server/eula.txt /code/

COPY config /code/config

COPY configs/usercache.json \
    configs/banned-ips.json \ 
    configs/banned-players.json \
    configs/ops.json \
    configs/whitelist.json \
    configs/server.properties \
    ./

COPY scripts /code/scripts
COPY libraries /code/libraries
COPY plugins/RecipeManager/recipes /code/plugins/RecipeManager/recipes
COPY plugins/RecipeManager/books /code/plugins/RecipeManager/book

# taken from 
# https://github.com/MohistMC/Mohist/tree/1.7.10
# https://mohistmc.com/
# https://mohistmc.com/download
# https://mohistmc.com/builds/1.7.10/Mohist-1.7.10-46-server.jar
CMD java -Dfml.readTimeout=120 -Dfile.encoding=UTF-8 -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar
