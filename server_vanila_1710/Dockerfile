FROM ubuntu:22.04

# Create directories app_home and static directories
WORKDIR /code

RUN apt update
RUN apt-get install -y openjdk-8-jre
RUN apt-get install -y openjfx

COPY server/* /code/

# taken from https://mcversions.net/download/1.12.2
CMD java -jar minecraft_server.1.7.10.jar

