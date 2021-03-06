FROM debian:bullseye

LABEL maintainer="Philipp Giebel <public@ambnet.biz>"

ENV LINK_NAME="unconfigured"
ENV LINK_DOMAIN="unconfigured"
ENV YOUR_NAME="John Doe"
ENV YOUR_AKA="0:0/0.0"
ENV YOUR_SYSTEM="Fidian"
ENV YOUR_LOCATION="Trancentral"
ENV YOUR_HOSTNAME="Fidian"
ENV UPLINK_HOST="example.com"
ENV UPLINK_PORT=""
ENV UPLINK_AKA="0:0/0"
ENV SESSION_PASSWORD="SECRET123"
ENV PACKET_PASSWORD=""
ENV AREAFIX_PASSWORD=""
ENV FILEFIX_PASSWORD=""
ENV WEB_PASSWORD="fidian"
ENV TZ="UTC"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install apt-utils \
    && apt-get -y install wget cron locales libterm-readline-perl-perl supervisor tzdata patch logrotate

COPY /extras/fidoconfig.txt .
COPY /extras/docker.patch .

RUN wget --quiet https://kuehlbox.wtf/fidosetup.sh \
    && chmod 755 fidosetup.sh \
		&& patch -s fidosetup.sh docker.patch \
    && ./fidosetup.sh

RUN mkdir -p /run/ftn \
    && chown ftn:ftn /run/ftn \
    && chmod 750 /run/ftn
		
RUN rm -f /etc/logrotate.d/binkd

COPY /extras/docker-entrypoint.sh /
COPY /extras/docker-entrypoint.d/settimezone.sh /docker-entrypoint.d/10-settimezone.sh
COPY /extras/docker-entrypoint.d/fidianconfig.sh /docker-entrypoint.d/20-fidianconfig.sh
COPY /extras/etc/supervisor/conf.d/binkd.conf /etc/supervisor/conf.d/
COPY /extras/etc/supervisor/conf.d/cron.conf /etc/supervisor/conf.d/
COPY /extras/etc/supervisor/conf.d/ttyd.conf /etc/supervisor/conf.d/
COPY /extras/etc/logrotate.d/binkd /etc/logrotate.d/
COPY /extras/etc/logrotate.d/husky /etc/logrotate.d/
COPY /extras/usr/local/sbin/dockerrun.sh /usr/local/sbin/
COPY /extras/usr/local/sbin/ttydrun.sh /usr/local/sbin/

RUN chmod 755 /docker-entrypoint.sh \
    && chmod 755 /usr/local/sbin/dockerrun.sh \
		&& chmod 755 /usr/local/sbin/ttydrun.sh \
    && chmod 755 /docker-entrypoint.d/10-settimezone.sh \
    && chmod 755 /docker-entrypoint.d/20-fidianconfig.sh

RUN rm -f /fidosetup.sh \
    && rm -f /fidoconfig.txt \
		&& rm -f /docker.patch \
		&& rm -rf /var/log/husky \
		&& rm -rf /var/log/binkd

RUN echo "" >>/home/fido/.bashrc \
    && echo ". /usr/local/sbin/dockerrun.sh" >>/home/fido/.bashrc \
    && echo "cd ~" >>/home/fido/.bashrc

RUN wget --quiet -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 \
	&& chown root:fido /usr/local/bin/ttyd \
	&& chmod 750 /usr/local/bin/ttyd

RUN echo "fido:fidian" |chpasswd

RUN apt-get clean

VOLUME /var/spool/ftn
VOLUME /etc/binkd
VOLUME /etc/husky
VOLUME /var/log/fidian

WORKDIR /

EXPOSE 24554
EXPOSE 24580

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-j", "/run/supervisord.pid", "-c", "/etc/supervisor/supervisord.conf"]
