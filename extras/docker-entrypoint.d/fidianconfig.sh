#!/bin/bash
r=0
if [ $(grep -c '/var/log/supervisor/supervisord.log' /etc/supervisor/supervisord.conf) -gt 0 ]; then
  r=$((r+1))
  sed -i 's|/var/log/supervisor/supervisord.log|/dev/null|g' /etc/supervisor/supervisord.conf
fi
if [ $(grep -c "${WEB_PASSWORD:-fidian}" /etc/supervisor/conf.d/ttyd.conf) -eq 0 ]; then
  r=$((r+1))
  sed -i "s/command=\(.*\) -cfido:\(.*\) \/bin\/bash\(.*\)/command=\1 -cfido:${WEB_PASSWORD:-fidian} \/bin\/bash\3/" /etc/supervisor/conf.d/ttyd.conf
fi

if [ $r -gt 0 ]; then
  /usr/bin/supervisorctl reload
fi

if [ -n ${YOUR_AKA} ]; then
  if [ $(grep -c "${YOUR_AKA}" /home/fido/.fidoconfig) -eq 0 ]; then
    echo "LINK_NAME ${LINK_NAME:-unconfigured}" >/home/fido/.fidoconfig
    echo "LINK_DOMAIN ${LINK_DOMAIN:-unconfigured}" >>/home/fido/.fidoconfig
    echo "YOUR_NAME ${YOUR_NAME:-John Doe}" >>/home/fido/.fidoconfig
    echo "YOUR_AKA ${YOUR_AKA:-0:0/0.0}" >>/home/fido/.fidoconfig
    echo "YOUR_SYSTEM ${YOUR_SYSTEM:-Fidian}" >>/home/fido/.fidoconfig
    echo "YOUR_LOCATION ${YOUR_LOCATION:-Trancentral}" >>/home/fido/.fidoconfig
    echo "YOUR_HOSTNAME ${YOUR_HOSTNAME:-fidian}" >>/home/fido/.fidoconfig
    echo "UPLINK_HOST ${UPLINK_HOST:-example.com}" >>/home/fido/.fidoconfig
    echo "UPLINK_PORT ${UPLINK_PORT}" >>/home/fido/.fidoconfig
    echo "UPLINK_AKA ${UPLINK_AKA:-0.0/0}" >>/home/fido/.fidoconfig
    echo "SESSION_PASSWORD ${SESSION_PASSWORD:-SECRET123}" >>/home/fido/.fidoconfig
    echo "PACKET_PASSWORD ${PACKET_PASSWORD}" >>/home/fido/.fidoconfig
    echo "AREAFIX_PASSWORD ${AREAFIX_PASSWORD}" >>/home/fido/.fidoconfig
    echo "FILEFIX_PASSWORD ${FILEFIX_PASSWORD}" >>/home/fido/.fidoconfig
    if [ $r -gt 0 ]; then
      sleep 30
    fi
    /usr/local/sbin/fidosetup.sh
  fi
fi

export LINK_NAME=''
export LINK_DOMAIN=''
export YOUR_NAME=''
export YOUR_AKA=''
export YOUR_SYSTEM=''
export YOUR_LOCATION=''
export YOUR_HOSTNAME=''
export UPLINK_HOST=''
export UPLINK_PORT=''
export UPLINK_AKA=''
export SESSION_PASSWORD=''
export PACKET_PASSWORD=''
export AREAFIX_PASSWORD=''
export FILEFIX_PASSWORD=''
export WEB_PASSWORD=''
