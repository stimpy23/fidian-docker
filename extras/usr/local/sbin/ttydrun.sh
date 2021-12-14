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
export WEB_PASSWORD=''

cd /home/fido
if [ $(grep -c unconfigured /home/fido/.fidoconfig) -gt 0 ]; then
  /usr/local/sbin/fidoconfig.sh
fi

runit=$(dialog --clear --no-cancel --backtitle "Fidian" --menu "Choose action" 0 0 0 "GoldED" "" "FidoConfig" "" "poll" "" "toss" "" "tick" "" "echoscan" "" "netscan" "" 3>&1 1>&2 2>&3)

clear

case "$runit" in
	"GoldED")
		/usr/bin/golded
	;;
	"FidoConfig")
		/usr/local/sbin/fidoconfig.sh
	;;
	"poll")
		/usr/local/sbin/poll.sh
	;;
	"echoscan")
		/usr/local/sbin/echoscan.sh
	;;
	"netscan")
		/usr/local/sbin/netscan.sh
	;;
	"toss")
		/usr/local/sbin/toss.sh
	;;
	"tick")
		/usr/local/sbin/tick.sh		
	;;
	default)
	;;
esac

exec /usr/local/sbin/ttydrun.sh