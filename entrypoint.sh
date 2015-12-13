#!/bin/bash

if [ -z "$TS_VERSION" ]; then
    TS_VERSION="$(wget -q -O - https://www.server-residenz.com/tools/ts3versions.json | jsawk -n 'out(this.latest)')"
fi

TSFILE="teamspeak3-server_linux-amd64-$TS_VERSION.tar.gz"

if [ ! -f "/data/.downloaded" ] || [ "$(cat /data/.downloaded)" != "$TS_VERSION" ]; then
    echo "TS3 Server downloading Version $TS_VERSION ..."
    wget -nv "http://dl.4players.de/ts/releases/$TS_VERSION/$TSFILE" -O "/data/teamspeak-server.tar.gz"
    tar xf "/data/teamspeak-server.tar.gz" --strip-components=1 -C /data
    rm -rf "/data/teamspeak-server.tar.gz"
    touch "/data/.downloaded"
    echo "$TS_VERSION" > "/data/.downloaded"
    echo "TS Server Version $TS_VERSION download complete"
    echo ""
fi

TSARGS="$*"
if [ -e "/data/ts3server.ini" ]; then
    TSARGS="$TSARGS inifile=/data/ts3server.ini"
else
    TSARGS="$TSARGS createinifile=1"
fi

echo "Starting TS Server Version $TS_VERSION ..."
echo "==="

cd /data || exit 1
./ts3server_linux_amd64 "$TSARGS"
