# FROM ubuntu:20.04 AS build
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# copy thirdparty independently
WORKDIR /build
COPY . .

RUN apt-get --assume-yes update && apt-get --assume-yes install librrds-perl rrdtool dma autoconf make curl libnet-ssleay-perl libcrypt-ssleay-perl libcgi-fast-perl build-essential man
RUN ./release-smokeping.sh
RUN rm -rf ./etc

RUN ls
RUN pwd

COPY root/ .

VOLUME /config /data

EXPOSE 80

RUN pwd && ls && ls ./etc && ls ./etc/smokeping

CMD ["./bin/smokeping --config /build/etc/smokeping/config"]


# # FINAL IMAGE
# FROM ghcr.io/linuxserver/baseimage-alpine:3.18 AS app

# WORKDIR /app
# COPY root/ .

# # include speedtest cli in build
# COPY --from=build /build/bin/smokeping /usr/bin/smokeping

# VOLUME /config /data

# EXPOSE 80

# CMD ["/usr/bin/smokeping"]
