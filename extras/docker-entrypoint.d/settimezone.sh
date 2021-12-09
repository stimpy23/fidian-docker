#!/bin/bash
if [ -z "$TZ" ] || [ ! -f "/usr/share/zoneinfo/$TZ" ]; then
  TZ=UTC
fi
if [ $(grep -c "$TZ" /etc/timezone) -eq 0 ]; then
    cp "/usr/share/zoneinfo/$TZ" /etc/localtime
    echo "$TZ" >/etc/timezone
fi
