FROM debian:jessie
MAINTAINER Alexander Trost <galexrt@googlemail.com>

ENV LD_LIBRARY_PATH="/data" ARCH="linux_amd64" JQ_ARCH="linux64"

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -q install -y wget ca-certificates bzip2 && \
    wget -q -O /usr/bin/jq "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-$JQ_ARCH" && \
    chmod +x /usr/bin/jq && \
    mkdir -p /data && \
    ts_version="$(wget -q -O - https://www.server-residenz.com/tools/ts3versions.json | jq -r '.latest')" && \
    wget -nv "http://dl.4players.de/ts/releases/$ts_version/teamspeak3-server_$ARCH-$ts_version.tar.bz2" -O "/data/teamspeak-server.tar.bz2" && \
    bzip2 -d "/data/teamspeak-server.tar.bz2" && \
    apt-get -qq autoremove -y --purge && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/data"]
EXPOSE 9987/udp 10011/tcp 30033/tcp 41144/tcp

ENTRYPOINT ["/entrypoint.sh"]
