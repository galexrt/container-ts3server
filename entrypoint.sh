#!/bin/bash

if [ "$DEBUG" == "True" ] || [ "$DEBUG" == "true" ]; then
    set -xe
fi

DOWNLOAD_TS="${DOWNLOAD_TS:-True}"
TS_VERSION="${TS_VERSION:-}"
ARCH="${ARCH:-linux_amd64}"
TSDNS_ENABLE="${TSDNS_ENABLE:-False}"
ONLY_TSDNS="${ONLY_TSDNS:-False}"
TSDNS_PORT="${TSDNS_PORT:-41144}"

startTSDNS() {
    cd /data/tsdns
    echo "=> Starting TSDNS server .."
    exec /data/tsdns/tsdnsserver "$TSDNS_PORT"
}

cd /data || { echo "Can't access the data directory"; exit 1; }

if [ "$DOWNLOAD_TS" = "True" ] || [ "$DOWNLOAD_TS" = "true" ]; then
    rm -rf "/data/teamspeak-server.tar"

    if [ ! -f "/data/.downloaded" ] || [ "$(cat /data/.downloaded)" != "$TS_VERSION" ]; then
        echo "->TS3 Server downloading Version $TS_VERSION ..."
        wget -nv "https://files.teamspeak-services.com/releases/server/$TS_VERSION/teamspeak3-server_$ARCH-$TS_VERSION.tar.bz2" -O "/data/teamspeak-server.tar.bz2"
        bzip2 -d "/data/teamspeak-server.tar.bz2"
        tar xf "/data/teamspeak-server.tar" --strip-components=1 -C /data
        rm -rf "/data/teamspeak-server.tar"
        echo "$TS_VERSION" > "/data/.downloaded"
        echo "=> TS Server Version $TS_VERSION download complete"
    fi
fi

[ ! -x "/data/ts3server_minimal_runscript.sh" ] && { echo "Couldn't find ts3server_minimal_runscript.sh. Exiting.."; exit 1; }

if [ ! -z "$TS3_WHITELIST" ]; then
    echo "" > /data/query_ip_whitelist.txt
    for entry in $(echo "$TS3_WHITELIST" | tr ',' ' '); do
        echo "$entry" >> /data/query_ip_whitelist.txt
    done
fi
if [ ! -z "$TS3_BLACKLIST" ]; then
    echo "" > /data/query_ip_blacklist.txt
    for entry in $(echo "$TS3_BLACKLIST" | tr ',' ' '); do
        echo "$entry" >> /data/query_ip_blacklist.txt.txt
    done
fi

TSARGS="$*"
if [ -e "/data/ts3server.ini" ]; then
    TSARGS="$TSARGS inifile=/data/ts3server.ini"
else
    TSARGS="$TSARGS createinifile=1"
fi

if [ "$TSDNS_ENABLE" = "True" ] || [ "$TSDNS_ENABLE" = "true" ]; then
    if [ "$ONLY_TSDNS" = "True" ] || [ "$ONLY_TSDNS" = "true" ]; then
        startTSDNS
    else
        startTSDNS &
    fi
fi

echo "=> Starting TS Server Version $TS_VERSION ..."
exec ./ts3server_minimal_runscript.sh "$TSARGS"
