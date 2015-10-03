FROM debian:jessie
MAINTAINER Alexander Trost <galexrt@googlemail.com>

ENV LD_LIBRARY_PATH="/data"

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install -y libnspr4 wget ca-certificates && \
    wget http://ftp.us.debian.org/debian/pool/main/x/xulrunner/spidermonkey-bin_24.8.1esr-2~deb7u1_amd64.deb -O spidermonkey-bin.deb -P /tmp && \
    deb -i /tmp/spidermonkey-bin.deb && \
    rm -rf /tmp/spidermonkey-bin.deb && \
    wget -q -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk && \
    chmod 755 /usr/bin/jsawk && \
    mkdir /data && \
    apt-get -qq autoremove -y --purge && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data"]
EXPOSE 9987/udp 10011 30033

ENTRYPOINT ["/entrypoint.sh"]
