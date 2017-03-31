FROM debian:jessie

MAINTAINER dominikauer <dobsiin@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install dependencies
RUN apt-get update
RUN apt-get -y --force-yes install wget git nano make gcc g++ apt-transport-https libavahi-compat-libdnssd-dev sudo nodejs etherwake

# Fix for FHEM 5.8
RUN apt-get -y --force-yes install sqlite3 libdbd-sqlite3-perl libtext-diff-perl  && apt-get clean

# Install perl packages kimos86
RUN apt-get -y --force-yes install libalgorithm-merge-perl \
libclass-isa-perl \
libcommon-sense-perl \
libdpkg-perl \
liberror-perl \
libfile-copy-recursive-perl \
libfile-fcntllock-perl \
libio-socket-ip-perl \
libjson-perl \
libjson-xs-perl \
libmail-sendmail-perl \
libsocket-perl \
libswitch-perl \
libsys-hostname-long-perl \
libterm-readkey-perl \
libterm-readline-perl-perl \
libsnmp-perl \
libnet-telnet-perl \
libmime-lite-perl \
libxml-simple-perl \
libdigest-crc-perl \
libcrypt-cbc-perl \
libio-socket-timeout-perl \
libmime-lite-perl \
libdevice-serialport-perl && apt-get clean

WORKDIR /opt
# Install fhem kimos86
RUN wget http://fhem.de/fhem-5.8.deb
RUN dpkg -i fhem-5.8.deb || true
# RUN rm fhem.deb
RUN echo 'fhem    ALL = NOPASSWD:ALL' >>/etc/sudoers
RUN echo 'attr global pidfilename /var/run/fhem/fhem.pid' >> /opt/fhem/fhem.cfg
#RUN echo 'define Wetter_Villach Weather 540859 1800 de'   >> /opt/fhem/fhem.cfg

RUN chown -R /opt/fhem/fhem.cfg

#Install supervisord
RUN apt-get -y --force-yes install supervisor && apt-get clean
RUN mkdir -p /var/log/supervisor

RUN echo Europe/Berlin > /etc/timezone && dpkg-reconfigure tzdata

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/opt/fhem"]

# Ports
EXPOSE 8083
EXPOSE 51826


COPY start.sh ./
RUN chmod +x ./start.sh
CMD ["./start.sh"]

