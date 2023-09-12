# NOTES
# datadir  = /var/lib/smokeping
# - let's map a volume to this container /data:/var/lib/smokeping

# document how configuration works. map/overlay a directory locally to container

# FROM ubuntu:20.04 AS build
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive


# RUN cat /etc/hostname
RUN echo "**** install packages ****"
RUN apt update && apt upgrade -y
RUN apt-get install -y --no-install-recommends gcc make libwww-perl libcgi-fast-perl libtext-soundex-perl libio-pty-perl libcrypt-ssleay-perl rrdtool librrds-perl libssl-dev libc6-dev wget automake autoconf libtool fping pkg-config
RUN apt install -y apache2 libapache2-mod-fcgid

# copy thirdparty independently
# COPY . .
RUN echo "**** download Smokeping source ****"
RUN wget https://oss.oetiker.ch/smokeping/pub/smokeping-2.8.2.tar.gz
RUN tar zxf smokeping-2.8.2.tar.gz
RUN mv smokeping-2.8.2 ./build


RUN echo "**** install Smokeping from source ****"
WORKDIR /build
RUN LC_ALL=C ./configure --prefix=/usr/local/smokeping
RUN make install

RUN echo "**** configure Smokeping ****"
RUN mkdir /usr/local/smokeping/cache
RUN mkdir /usr/local/smokeping/data
# VOLUME /data
RUN mkdir /usr/local/smokeping/var
COPY config/config /usr/local/smokeping/etc/config
# VOLUME /config /data

RUN echo "**** configure Smokeping GUI ****"
RUN chown www-data:www-data -R /usr/local/smokeping
RUN chmod 777 /usr/local/smokeping
COPY ./config/smokeping.conf /etc/apache2/conf-available/smokeping.conf

RUN /usr/local/smokeping/bin/smokeping --config /usr/local/smokeping/etc/config

# RUN service apache2 start
RUN a2enconf smokeping
RUN a2enmod cgi
# RUN service apache2 start
# RUN /etc/init.d/apache2 start
# RUN /etc/init.d/apache2 reload
# RUN apache2ctl start
# RUN apachectl start
# RUN service apache2 reload
# RUN service apache2 restart



# RUN echo "**** configure systemd ****"
# COPY config/smokeping.service /etc/systemd/system/smokeping.service

# RUN systemctl enable smokeping

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
# RUN /usr/local/smokeping/bin/smokeping --config /usr/local/smokeping/etc/config
# CMD ["apache2ctl", "-D", "FOREGROUND"]


# CMD ["systemctl", "start", "smokeping"]
# CMD ["/usr/local/smokeping/bin/smokeping", "--config", "/usr/local/smokeping/etc/config", "--nodaemon"]
# CMD ["/usr/local/smokeping/bin/smokeping", "--config", "/usr/local/smokeping/etc/config", "--nodaemon", "--debug-daemon"]

# RUN /usr/local/smokeping/bin/smokeping --version
# RUN chown www-data:www-data -R /usr/local/smokeping
# COPY ./config/smokeping.conf /etc/apache2/conf-available/smokeping.conf
# RUN a2enconf smokeping
# RUN a2enmod cgi
# RUN service apache2 restart

# EXPOSE 80

# CMD ["./bin/smokeping", "--config", "/usr/local/smokeping/etc/config", "--nodaemon", "--debug-daemon"]
# CMD ["apachectl", "-D", "FOREGROUND"]
# CMD ["/usr/local/smokeping/bin/smokeping", "--version"]

# ENTRYPOINT ["tail", "-f", "/dev/null"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]

# RUN apt-get --assume-yes update && apt-get --assume-yes install librrds-perl rrdtool autoconf make curl libnet-ssleay-perl libcrypt-ssleay-perl libcgi-fast-perl build-essential man ssmtp
# RUN ./release-smokeping.sh
# RUN rm -rf ./etc

# RUN ls
# RUN pwd

# # Create the cache directory
# RUN mkdir -p /var/cache/smokeping
# RUN mkdir -p /var/run/smokeping
# # RUN mkdir -p /etc/smokeping/smokemail
# RUN mkdir -p /etc/smokeping/tmail
# RUN ls /etc/smokeping

# COPY root/ .
# COPY config/ /config/

# VOLUME /config /data

# EXPOSE 80

# RUN pwd && ls && ls ./etc && ls ./etc/smokeping

# CMD ["./bin/smokeping", "--config=/build/etc/smokeping/config"]


# # # FINAL IMAGE
# # FROM ghcr.io/linuxserver/baseimage-alpine:3.18 AS app

# # WORKDIR /app
# # COPY root/ .

# # # include speedtest cli in build
# # COPY --from=build /build/bin/smokeping /usr/bin/smokeping

# # VOLUME /config /data

# # EXPOSE 80

# # CMD ["/usr/bin/smokeping"]




# 
# 
# 


# FROM ghcr.io/linuxserver/baseimage-alpine:3.18

# RUN echo "**** install packages ****" && \
#     apk add --no-cache --virtual=build-dependencies \
#         build-base \
#         perl-app-cpanminus \
#         perl-dev && \
#     apk add --no-cache \
#         apache2 \
#         apache2-ctl \
#         apache2-utils \
#         apache-mod-fcgid \
#         bc \
#         bind-tools \
#         font-noto-cjk \
#         openssh-client \
#         perl-authen-radius \
#         perl-lwp-protocol-https \
#         smokeping \
#         ssmtp \
#         sudo \
#         tcptraceroute

# RUN echo "**** Build perl TacacsPlus module ****" && \
#     cpanm Authen::TacacsPlus

# RUN echo "**** give setuid access to traceroute & tcptraceroute ****" && \
#     chmod a+s /usr/bin/traceroute && \
#     chmod a+s /usr/bin/tcptraceroute

# RUN echo "**** fix path to cropper.js ****" && \
#     sed -i 's#src="/cropper/#/src="cropper/#' /etc/smokeping/basepage.html

# RUN echo "**** Cleanup ****" && \
#     apk del --purge \
#         build-dependencies && \
#     rm -rf \
#         /tmp/* \
#         /etc/apache2/httpd.conf

# COPY docker/root/ /

# EXPOSE 80

# VOLUME /config /data