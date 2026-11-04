#!/bin/sh
set -e

service apache2 start
service apache2 status
/etc/init.d/apache2 reload

CONFIG=/usr/local/smokeping/etc/config

# INFLUXDB_HOST set: also push every measurement as InfluxDB line protocol, e.g. to
# Monitoring's ingest endpoint (VictoriaMetrics accepts InfluxDB writes)
if [ -n "$INFLUXDB_HOST" ]; then
    cp "$CONFIG" /tmp/smokeping.config
    cat >> /tmp/smokeping.config <<EOF

*** InfluxDB ***
host = $INFLUXDB_HOST
port = ${INFLUXDB_PORT:-8086}
database = ${INFLUXDB_DATABASE:-smokeping}
timeout = ${INFLUXDB_TIMEOUT:-5}
EOF
    CONFIG=/tmp/smokeping.config
fi

/usr/local/smokeping/bin/smokeping --config "$CONFIG" --nodaemon

# /docker-entrypoint-initdb.d