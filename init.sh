#!/bin/sh
set -e

service apache2 start
service apache2 status
/etc/init.d/apache2 reload

/usr/local/smokeping/bin/smokeping --config /usr/local/smokeping/etc/config --nodaemon

# /docker-entrypoint-initdb.d