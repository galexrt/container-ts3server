#!/bin/bash

if [ ! -z "$TS3_VERSION" ]; then
    TS_VERSION="$TS3_VERSION"
fi

if [ -z "$TS_VERSION" ]; then
    TS_VERSION="$(wget -q -O - https://www.server-residenz.com/tools/ts3versions.json | jsawk -n 'out(this.latest)')"
fi

TSFILE="teamspeak3-server_$ARCHITECTURE-$TS_VERSION.tar.bz2"

if [ ! -f "/data/.downloaded" ] || [ "$(cat /data/.downloaded)" != "$TS_VERSION" ]; then
    echo "TS3 Server downloading Version $TS_VERSION ..."
    wget -nv "http://dl.4players.de/ts/releases/$TS_VERSION/$TSFILE" -O "/data/teamspeak-server.tar.bz2"
    bzip2 -d "/data/teamspeak-server.tar.bz2"
    tar xf "/data/teamspeak-server.tar" --strip-components=1 -C /data
    rm -rf "/data/teamspeak-server.tar"
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
echo "+ Running './ts3server_minimal_runscript.sh $TSARGS'"
exec ./ts3server_minimal_runscript.sh "$TSARGS"
