#!/bin/bash

if [ -z "$TS_VERSION" ]; then
    TS_VERSION=`wget -O - https://www.server-residenz.com/tools/ts3versions.json | jsawk -n 'out(this.latest)'`
fi

TSFILE="teamspeak3-server_linux-amd64-$TS_VERSION.tar.gz"

if [ ! -f "/data/.ts3-installed" ]; then
    wget -q "http://dl.4players.de/ts/releases/$TS_VERSION/$TSFILE" -C /data
    tar xf "/data/$TSFILE" --strip-components=1 -C /data
    touch "/data/.ts3-installed"
fi

TSARGS="$@"
if [ -e /data/ts3server.ini ]; then
  TSARGS="$TSARGS inifile=/data/ts3server.ini"
else
  TSARGS="$TSARGS createinifile=1"
fi

exec /data/ts3server_linux_amd64 "$TSARGS"
