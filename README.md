```
____                  _        ____  _             
/ ___| _ __ ___   ___ | | _____|  _ \(_)_ __   __ _ 
\___ \| '_ ` _ \ / _ \| |/ / _ \ |_) | | '_ \ / _` |
 ___) | | | | | | (_) |   <  __/  __/| | | | | (_| |
|____/|_| |_| |_|\___/|_|\_\___|_|   |_|_| |_|\__, |
                                              |___/ 
```

Original Authors:  Tobias Oetiker <tobi of oetiker.ch> and Niko Tyni <ntyni with iki.fi>

[![Build Test](https://github.com/oetiker/SmokePing/actions/workflows/build-test.yaml/badge.svg)](https://github.com/oetiker/SmokePing/actions/workflows/build-test.yaml)

SmokePing is a latency logging and graphing and
alerting system. It consists of a daemon process which
organizes the latency measurements and a CGI which
presents the graphs.

SmokePing is ...
================

 * extensible through plug-in modules

 * easy to customize through a webtemplate and an extensive
   configuration file.

 * written in perl and should readily port to any unix system

 * an RRDtool frontend

 * able to deal with DYNAMIC IP addresses as used with
   Cable and ADSL internet.


cheers
tobi

# Smokeping changes

A live version of Smokeping hosted by sjultra can be found here

## smokepingkube.vzxy.net

## TODO
- enable our docker image to accept volume mounts for `config/config` so users of our image can provide their own configuration file or customise the default configuration file
- redirect / to /smokeping/smokeping.fcgi.dist

## NOTES
- followed https://atetux.com/how-to-build-and-install-latest-smokeping-on-ubuntu-20-04 as a base to creating this docker image
- and https://www.digitalocean.com/community/tutorials/how-to-track-network-latency-with-smokeping-on-freebsd-11

## Smokeping configuration defaults
A default smokeping configuration can be found in `config/config`.

The Smokeping UI is enabled by default and is configured with `config/smokeping.conf`


## Choose the hosts to ping
Set `TARGETS` (host names or IPv4 addresses, separated by spaces) and `init.sh` replaces the config's Targets section with one entry per host, for both the probes and the web UI. The Helm chart sets it from `smokeping.targets`.

## Push measurements to InfluxDB or VictoriaMetrics
Set `INFLUXDB_HOST` and every measurement is also written as InfluxDB line protocol (`init.sh` adds the `*** InfluxDB ***` section to the config). Optional: `INFLUXDB_PORT` (8086), `INFLUXDB_DATABASE` (smokeping), `INFLUXDB_TIMEOUT` (5 seconds).

The Helm chart does this by default, pushing to Monitoring's ingest endpoint (`smokeping.metrics`), and ships a Grafana dashboard (`helm/service/files/smokeping.json`) as a ConfigMap labeled `grafana_dashboard: "1"`.
