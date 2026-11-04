#!/bin/sh
set -e

# The config Smokeping and its web UI run with: the image's (or a mounted one),
# adjusted by the environment below. Built before Apache starts, so the UI
# never reads anything else.
CONFIG=/tmp/smokeping.config
cp /usr/local/smokeping/etc/config "$CONFIG"

# TARGETS set (hosts separated by spaces): ping those instead of the config's own targets
if [ -n "$TARGETS" ]; then
    sed -i '/^\*\*\* Targets \*\*\*/,$d' "$CONFIG"
    cat >> "$CONFIG" <<EOF
*** Targets ***
probe = FPing
menu = Top
title = Network Latency
EOF
    for host in $TARGETS; do
        # section names allow only letters, digits, - and _
        printf '\n+ %s\nmenu = %s\ntitle = %s\nhost = %s\n' "$(printf %s "$host" | tr -c 'A-Za-z0-9-' '_')" "$host" "$host" "$host" >> "$CONFIG"
    done
fi

# INFLUXDB_HOST set: also push every measurement as InfluxDB line protocol, e.g. to
# Monitoring's ingest endpoint (VictoriaMetrics accepts InfluxDB writes)
if [ -n "$INFLUXDB_HOST" ]; then
    cat >> "$CONFIG" <<EOF

*** InfluxDB ***
host = $INFLUXDB_HOST
port = ${INFLUXDB_PORT:-8086}
database = ${INFLUXDB_DATABASE:-smokeping}
timeout = ${INFLUXDB_TIMEOUT:-5}
EOF
fi

# the web UI reads the same config
sed -i "s#^exec \([^ ]*smokeping_cgi\) .*#exec \1 $CONFIG#" /usr/local/smokeping/htdocs/smokeping.fcgi.dist

service apache2 start
service apache2 status
/etc/init.d/apache2 reload

/usr/local/smokeping/bin/smokeping --config "$CONFIG" --nodaemon
