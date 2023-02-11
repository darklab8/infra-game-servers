FROM ubuntu:22.04

# Create directories app_home and static directories
WORKDIR /code

RUN apt update
RUN apt-get install -y openjdk-8-jre
RUN apt-get install -y openjfx

COPY mods /code/mods
COPY server/* /code/

CMD java -jar minecraft_server.1.12.2.jar

