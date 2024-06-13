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


## Enable writes to influxDB
- To enable smokeping to write generated metrics to an InfluxDB instance, add the following block to your smokeping `config` file. Update values to map to your InfluxDB instance
```
*** InfluxDB ***
host = influxdb:8086
database = smokeping
timeout = 10
port = 8086
username = admin
password = password
```

## Enable the smokeping Grafana dashboard
- To enable the smokeping Grafana dashboard, run your Grafana instance and enable it to communicate with your running . There are many ways to approach this. Below is an example of how to configure Grafana with Smokeping using `docker compose`.
  - `GF_SECURITY_ADMIN_PASSWORD` is your default Grafana user password. Unless you've configured it explicitly, the default Grafana username will be `admin`. See Grafana docs for more info.
  - The `/etc/grafana/provisioning/dashboards` volume mount is where your Grafana dashboard configuration will live (`dashboard.yml`, `smokeping.json`). You can roll your own dashboard, or use our recommended default, found [here]().
  - The `/etc/grafana/provisioning/datasources` volume mount is where your Grafana datasource for InfluxDB will live (i.e; `influxdb.yml`). You can roll youe own datasource configuration, or use our recommended default, found [here]().
- If you use our recommended defaults, be sure to update values for your InfluxDB instance where applicable in the provided files.
```
grafana:
    image: grafana/grafana:10.1.2
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_AUTH_ANONYMOUS_ENABLED=true
    volumes:
      - ./grafana/dashboards:/etc/grafana/provisioning/dashboards
      - ./grafana/datasources:/etc/grafana/provisioning/datasources
    ports:
      - 3000:3000
    restart: always
    depends_on:
      - "influxdb"

```