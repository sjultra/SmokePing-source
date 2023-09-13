# NOTES
# datadir  = /var/lib/smokeping
# - let's map a volume to this container /data:/var/lib/smokeping

# document how configuration works. map/overlay a directory locally to container

# FROM ubuntu:20.04 AS build
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive


RUN echo "**** install packages ****"
RUN apt update && apt upgrade -y
RUN apt-get install -y --no-install-recommends gcc make libwww-perl libcgi-fast-perl libtext-soundex-perl libio-pty-perl libcrypt-ssleay-perl rrdtool librrds-perl libssl-dev libc6-dev wget automake autoconf libtool fping pkg-config dma shtool
RUN apt install -y apache2 libapache2-mod-fcgid

RUN echo "**** download Smokeping source ****"
COPY . /build

RUN echo "**** install Smokeping from source ****"
WORKDIR /build
RUN autoreconf -i
RUN ./bootstrap

RUN ./configure --prefix=/usr/local/smokeping
RUN make install

RUN echo "**** configure Smokeping ****"
RUN mkdir /usr/local/smokeping/cache
# RUN mkdir /usr/local/smokeping/data
VOLUME /data
RUN mkdir /usr/local/smokeping/var
COPY config/config /usr/local/smokeping/etc/config
# VOLUME /config /data

RUN echo "**** configure Smokeping GUI ****"
RUN chown www-data:www-data -R /usr/local/smokeping
RUN chmod 777 /usr/local/smokeping
COPY ./config/smokeping.conf /etc/apache2/conf-available/smokeping.conf

RUN a2enconf smokeping
RUN a2enmod cgi

EXPOSE 80

COPY init.sh .
RUN chmod +x init.sh
ENTRYPOINT ["./init.sh"]




# # # FINAL IMAGE
# # FROM ghcr.io/linuxserver/baseimage-alpine:3.18 AS app

# # WORKDIR /app
# # COPY root/ .

# # # include speedtest cli in build
# # COPY --from=build /build/bin/smokeping /usr/bin/smokeping

# # VOLUME /config /data

# # EXPOSE 80

# # CMD ["/usr/bin/smokeping"]