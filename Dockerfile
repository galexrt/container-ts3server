FROM debian:buster
LABEL maintainer="Alexander Trost <galexrt@googlemail.com>"

ARG TS_VERSION="3.13.2"
ARG TS3_USER="3000"
ARG TS3_GROUP="3000"
ARG ARCH="linux_amd64"

ENV DATA_DIR="/data" TS3SERVER_LICENSE="accept" TSDNS_ENABLE="False" LD_LIBRARY_PATH="/data" \
    TS_VERSION="$TS_VERSION" TS3_USER="$TS3_USER" TS3_GROUP="$TS3_GROUP" ARCH="$ARCH"

RUN groupadd -g "$TS3_GROUP" teamspeak && \
    useradd -u "$TS3_USER" -g "$TS3_GROUP" -d "$DATA_DIR" teamspeak && \
    apt-get -qq update && \
    apt-get -q upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -q install -y wget ca-certificates bzip2 sudo && \
    mkdir -p "$DATA_DIR" && \
    wget -nv "https://files.teamspeak-services.com/releases/server/$TS_VERSION/teamspeak3-server_$ARCH-$TS_VERSION.tar.bz2" -O "$DATA_DIR/teamspeak-server.tar.bz2" && \
    cd "$DATA_DIR" && \
    bzip2 -d "$DATA_DIR/teamspeak-server.tar.bz2" && \
    tar xfv "$DATA_DIR/teamspeak-server.tar" -C "$DATA_DIR" --strip-components 1 && \
    rm "$DATA_DIR/teamspeak-server.tar" && \
    echo "$TS_VERSION" > "$DATA_DIR/.downloaded" && \
    chown teamspeak:teamspeak -R "$DATA_DIR" && \
    apt-get -qq autoremove -y --purge && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER teamspeak

WORKDIR "$DATA_DIR"
VOLUME ["$DATA_DIR"]
EXPOSE 9987/udp 10011/tcp 30033/tcp 41144/tcp

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
