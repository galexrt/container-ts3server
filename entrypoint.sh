#!/bin/bash

if [ "$DEBUG" == "True" ] || [ "$DEBUG" == "true" ]; then
    set -xe
fi

DOWNLOAD_TS="${DOWNLOAD_TS:-True}"
TS_VERSION="${TS3_VERSION:-}"
TSDNS_ENABLE="${TSDNS_ENABLE:-False}"
ONLY_TSDNS="${ONLY_TSDNS:-False}"
TSDNS_PORT="${TSDNS_PORT:-41144}"

startTSDNS() {
    cd /data/tsdns
    echo "Starting TSDNS server .."
    exec ./tsdns/tsdnsserver "$TSDNS_PORT"
}

cd /data || { echo "Can't access the data directory"; exit 1; }

if [ "$DOWNLOAD_TS" = "True" ] || [ "$DOWNLOAD_TS" = "true" ]; then
    rm -rf "/data/teamspeak-server.tar"
    if [ -z "$TS_VERSION" ]; then
        TS_VERSION="$(wget -q -O - https://www.server-residenz.com/tools/ts3versions.json | jq -r '.latest')"
    fi

    TSFILE="teamspeak3-server_$ARCH-$TS_VERSION.tar.bz2"

    if [ ! -f "/data/.downloaded" ] || [ "$(cat /data/.downloaded)" != "$TS_VERSION" ]; then
        echo "->TS3 Server downloading Version $TS_VERSION ..."
        wget -nv "http://dl.4players.de/ts/releases/$TS_VERSION/$TSFILE" -O "/data/teamspeak-server.tar.bz2"
        bzip2 -d "/data/teamspeak-server.tar.bz2"
        tar xf "/data/teamspeak-server.tar" --strip-components=1 -C /data
        rm -rf "/data/teamspeak-server.tar"
        echo "$TS_VERSION" > "/data/.downloaded"
        echo "=> TS Server Version $TS_VERSION download complete"
    fi
fi

[ ! -x "/data/ts3server_minimal_runscript.sh" ] && { echo "Couldn't find ts3server_minimal_runscript.sh. Exiting.."; exit 1;}

TSARGS="$*"
if [ -e "/data/ts3server.ini" ]; then
    TSARGS="$TSARGS inifile=/data/ts3server.ini"
else
    TSARGS="$TSARGS createinifile=1"
fi

if [ -f "/data/tsdns/tsdns_settings.ini" ] || ([ "$TSDNS_ENABLE" = "True" ] || [ "$TSDNS_ENABLE" = "true" ]); then
    if [ "$ONLY_TSDNS" = "True" ] || [ "$ONLY_TSDNS" = "true" ]; then
        startTSDNS
    else
        startTSDNS &
    fi
fi

echo "=> Starting TS Server Version $TS_VERSION ..."
exec ./ts3server_minimal_runscript.sh "$TSARGS"
