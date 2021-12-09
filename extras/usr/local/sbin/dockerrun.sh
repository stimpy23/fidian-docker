#!/bin/bash
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

if [ $(grep -c unconfigured /home/fido/.fidoconfig) -gt 0 ]; then
  /usr/local/sbin/fidoconfig.sh
fi
