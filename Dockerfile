FROM debian:buster
LABEL maintainer="Alexander Trost <galexrt@googlemail.com>"

ARG TS_VERSION="3.12.1"
ARG TS3_USER="3000"
ARG TS3_GROUP="3000"
ARG ARCH="linux_amd64"

ENV TS3_DIR="/data" TS3SERVER_LICENSE="accept" \
    TSDNS_ENABLE="False" LD_LIBRARY_PATH="/data"
RUN groupadd -g "$TS3_GROUP" teamspeak && \
    useradd -u "$TS3_USER" -g "$TS3_GROUP" -d "$TS3_DIR" teamspeak && \
    apt-get -qq update && \
    apt-get -q upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -q install -y wget ca-certificates bzip2 sudo && \
    mkdir -p "$TS3_DIR" && \
    wget -nv "https://files.teamspeak-services.com/releases/server/$TS_VERSION/teamspeak3-server_$ARCH-$TS_VERSION.tar.bz2" -O "/data/teamspeak-server.tar.bz2" && \
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
