#!/bin/bash

if [ -z "$TS_VERSION" ]; then
    TS_VERSION=`wget -q -O - https://www.server-residenz.com/tools/ts3versions.json | jsawk -n 'out(this.latest)'`
fi

TSFILE="teamspeak3-server_linux-amd64-$TS_VERSION.tar.gz"

if [ ! -f "/data/.ts3-downloaded" ]; then
    echo "TS3 Server downloading Version $TS_VERSION ..."
    wget -nv "http://dl.4players.de/ts/releases/$TS_VERSION/$TSFILE" -P /data
    tar xf "/data/$TSFILE" --strip-components=1 -C /data
    rm -rf "/data/$TSFILE"
    touch "/data/.ts3-downloaded"
    echo "$TS_VERSION" > /data/.ts3-downloaded
    echo -e "TS3 Server Version $TS_VERSION download complete\n\n"
fi

TSARGS="$@"
if [ -e /data/ts3server.ini ]; then
    TSARGS="$TSARGS inifile=/data/ts3server.ini"
else
    TSARGS="$TSARGS createinifile=1"
fi

echo "Starting TS3 Server Version $(cat /data/.ts3-downloaded) ...\n\n"
cd /data
exec ./ts3server_linux_amd64 "$TSARGS"
