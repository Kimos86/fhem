#!/bin/bash
# short workaround script

if [ ! -d /var/run/fhem  ]; then
    mkdir /var/run/fhem
    chown -R fhem:root /var/run/fhem
fi
chown -R fhem:root /opt/fhem
#/etc/init.d/dbus restart
#service avahi-daemon start
/usr/bin/supervisord
