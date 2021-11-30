FROM debian:bullseye

LABEL maintainer="Philipp Giebel <public@ambnet.biz>"

ARG LINK_NAME
ARG LINK_DOMAIN
ARG YOUR_NAME
ARG YOUR_AKA
ARG YOUR_SYSTEM
ARG YOUR_LOCATION
ARG YOUR_HOSTNAME
ARG UPLINK_HOST
ARG UPLINK_PORT
ARG UPLINK_AKA
ARG SESSION_PASSWORD
ARG PACKET_PASSWORD
ARG AREAFIX_PASSWORD
ARG FILEFIX_PASSWORD

RUN echo "LINK_NAME ${LINK_NAME:-FidoNet}" >fidoconfig.txt \
    && echo "LINK_DOMAIN ${LINK_DOMAIN:-fidonet}" >>fidoconfig.txt \
    && echo "YOUR_NAME ${YOUR_NAME:-John Doe}" >>fidoconfig.txt \
    && echo "YOUR_AKA ${YOUR_AKA:-0:0/0.0}" >>fidoconfig.txt \
    && echo "YOUR_SYSTEM ${YOUR_SYSTEM:-Fidian}" >>fidoconfig.txt \
    && echo "YOUR_LOCATION ${YOUR_LOCATION:-Trancentral}" >>fidoconfig.txt \
    && echo "YOUR_HOSTNAME ${YOUR_HOSTNAME:-fidian}" >>fidoconfig.txt \
    && echo "UPLINK_HOST ${UPLINK_HOST:-example.com}" >>fidoconfig.txt \
    && echo "UPLINK_PORT ${UPLINK_PORT}" >>fidoconfig.txt \
    && echo "UPLINK_AKA ${UPLINK_AKA:-0:0/0}" >>fidoconfig.txt \
    && echo "SESSION_PASSWORD ${SESSION_PASSWORD:-SECRET123}" >>fidoconfig.txt \
    && echo "PACKET_PASSWORD ${PACKET_PASSWORD}" >>fidoconfig.txt \
    && echo "AREAFIX_PASSWORD ${AREAFIX_PASSWORD}" >>fidoconfig.txt \
    && echo "FILEFIX_PASSWORD ${FILEFIX_PASSWORD}" >>fidoconfig.txt

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install apt-utils \
    && apt-get -y install wget cron locales libterm-readline-perl-perl supervisor
    
RUN wget --quiet https://kuehlbox.wtf/fidosetup.sh \
    && chmod 755 fidosetup.sh \
    && ./fidosetup.sh

RUN mkdir -p /run/ftn \
    && chown ftn:ftn /run/ftn \
    && chmod 750 /run/ftn

COPY /extras/docker-entrypoint.sh /
COPY /extras/etc/supervisor/conf.d/binkd.conf /etc/supervisor/conf.d/
COPY /extras/etc/supervisor/conf.d/cron.conf /etc/supervisor/conf.d/

RUN mkdir -p /docker-entrypoint.d \
    && chmod 755 /docker-entrypoint.sh

RUN rm -f /fidosetup.sh \
    && rm -f /fidoconfig.txt

RUN echo "cd ~" >>/home/fido/.bashrc \
    && cp /home/fido/.bashrc /home/fido/.bashrc.bak \
    && chown 1000:1000 /home/fido/.bashrc.bak \
    && echo "" >>/home/fido/.bashrc \
    && echo "if [ $(grep -c '0:0/0' ) -gt 0 ]; then" >>/home/fido/.bashrc \
    && echo "/usr/local/sbin/fidoconfig.sh" >>/home/fido/.bashrc \
    && echo "fi" >>/home/fido/.bashrc \
    && echo "mv /home/fido/.bashrc.bak /home/fido/.bashrc" >>/home/fido/.bashrc

RUN apt-get clean

VOLUME /var/spool/ftn
VOLUME /etc/binkd
VOLUME /etc/husky

WORKDIR /

EXPOSE 24554
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-j", "/run/supervisord.pid", "-c", "/etc/supervisor/supervisord.conf"]
