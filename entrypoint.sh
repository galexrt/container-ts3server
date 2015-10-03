#!/bin/bash

TS_VERSION=`wget -O - https://www.server-residenz.com/tools/ts3versions.json | jsawk -n 'out(this.latest)'`
TS3FILE="teamspeak3-server_linux-amd64-$TS_VERSION.tar.gz"

if [ ! -f "/data/.ts3-installed" ]; then
    wget -q "http://dl.4players.de/ts/releases/$TS_VERSION/$TS3FILE" -C /data
    tar xf "/data/$TS3FILE" --strip-components=1 -C /data
    touch "/data/.ts3-installed"
fi

TS3ARGS="$@"
if [ -e /data/ts3server.ini ]; then
  TS3ARGS="$TS3ARGS inifile=/data/ts3server.ini"
else
  TS3ARGS="$TS3ARGS createinifile=1"
fi

cd /data
exec /data/ts3server_linux_amd64 "$TS3ARGS"
