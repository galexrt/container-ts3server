FROM debian:jessie
MAINTAINER Alexander Trost <galexrt@googlemail.com>

ENV LD_LIBRARY_PATH="/data" ARCHITECTURE="linux_amd64"

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -q install -y mozjs24 libnspr4 wget ca-certificates bzip2 && \
    wget -q -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk && \
    chmod 755 /usr/bin/jsawk && \
    mkdir -p /data

RUN apt-get -qq autoremove -y --purge && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD entrypoint.sh /entrypoint.sh

VOLUME ["/data"]
EXPOSE 9987/udp 10011 30033

ENTRYPOINT ["/entrypoint.sh"]
