FROM ubuntu:22.04

# Create directories app_home and static directories
WORKDIR /code

RUN apt update
RUN apt-get install -y openjdk-8-jre
RUN apt-get install -y openjfx

COPY plugins plugins
COPY mods mods
RUN rm mods/tlskincape*.jar mods/OptiFine*.jar | true
RUN ls mods
COPY server/Mohist-1.7.10-46-server.jar server/eula.txt /code/

# taken from 
# https://github.com/MohistMC/Mohist/tree/1.7.10
# https://mohistmc.com/
# https://mohistmc.com/download
# https://mohistmc.com/builds/1.7.10/Mohist-1.7.10-46-server.jar
CMD java -noverify -jar Mohist-1.7.10-46-server.jar

