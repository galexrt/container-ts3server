FROM debian:stretch
LABEL maintainer="Alexander Trost <galexrt@googlemail.com>"

ENV TS3_DIR="/data" TS3_USER="3000" TS3_GROUP="3000" TS3SERVER_LICENSE="accept" \
    TSDNS_ENABLE="False" \
    LD_LIBRARY_PATH="/data" ARCH="linux_amd64" JQ_ARCH="linux64"

RUN groupadd -g "$TS3_GROUP" teamspeak && \
    useradd -u "$TS3_USER" -g "$TS3_GROUP" -d "$TS3_DIR" teamspeak && \
    apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -q install -y wget ca-certificates bzip2 sudo && \
    wget -q -O /usr/bin/jq "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-$JQ_ARCH" && \
    chmod +x /usr/bin/jq && \
    mkdir -p "$TS3_DIR" && \
    TS_VERSION="$(wget -q -O - https://www.server-residenz.com/tools/ts3versions.json | jq -r '.latest')" && \
    wget -nv "https://files.teamspeak-services.com/releases/server/$TS_VERSION/teamspeak3-server_linux_amd64-$TS_VERSION.tar.bz2" -O "/data/teamspeak-server.tar.bz2" && \
    echo "$TS_VERSION" > /data/.downloaded && \
    cd "$TS3_DIR" && \
    bzip2 -d "$TS3_DIR/teamspeak-server.tar.bz2" && \
    chown teamspeak:teamspeak -R "$TS3_DIR" && \
    apt-get -qq autoremove -y --purge && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER teamspeak

VOLUME ["$TS3_DIR"]
EXPOSE 9987/udp 10011/tcp 30033/tcp 41144/tcp

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
