FROM golang:1.21-bullseye as build

RUN apt update
RUN apt install -y build-essential
RUN apt-get install ca-certificates -y
RUN gcc --version

WORKDIR /code

COPY go.mod go.sum ./
RUN go mod download -x

COPY bot bot

FROM build as minecrafter-build
RUN CGO_ENABLED=0 go build -v -o main bot/minecrafter/main.go

FROM build as avorioner-build
RUN CGO_ENABLED=0 go build -v -o main bot/avorioner/main.go

FROM docker:24.0.7-cli as runner
WORKDIR /code
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
CMD ./main run

FROM runner as minecrafter-runner
COPY --from=minecrafter-build /code/main main

FROM runner as avorioner-runner
COPY --from=avorioner-build /code/main main