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

COPY configs configs_template

COPY scripts /code/scripts
COPY libraries /code/libraries
COPY plugins/RecipeManager/recipes /code/plugins/RecipeManager/recipes
COPY plugins/RecipeManager/books /code/plugins/RecipeManager/book

# Optional auth server. 
COPY server/authlib-injector-snapshot.jar .
# - Turn on javaagent line then in CMD
# - requires running drasl https://github.com/unmojang/drasl#installation
#   - or any other authlib-injector based auth server https://github.com/fn2006/PollyMC/wiki/Alternative-Auth-Servers
# - Requires in server properties to turn on online mode as true
# other info for auth https://drasl.unmojang.org/
# https://github.com/yushijinhun/authlib-injector/blob/develop/README.en.md#deploy

CMD java \
    -Xmx10G \
    -Dfml.readTimeout=120 \
    -Dfile.encoding=UTF-8 \
    -javaagent:/code/authlib-injector-snapshot.jar=http://drasl.dd84ai.com:25585 \
    -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar

