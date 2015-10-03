FROM debian:jessie
MAINTAINER Alexander Trost <galexrt@googlemail.com>

ENV LD_LIBRARY_PATH="/data"

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install wget ca-certificates && \
    wget -q -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk && \
    chmod 755 /usr/bin/jsawk && \
    mkdir /data && \
    apt-get --purge autoremove -yq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data"]
EXPOSE 9987/udp 10011 30033

ENTRYPOINT ["/entrypoint.sh"]
