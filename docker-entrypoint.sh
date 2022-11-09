#!/bin/sh
set -e

if [ ! -f UUID ] && [ -z "$UUID" ]; then
	cat /proc/sys/kernel/random/uuid > UUID
elif [ ! -f UUID ] && [ -n "$UUID" ]; then
	echo $UUID > UUID
fi

# Set config.json
if [ ! -f /etc/v2ray/config.json ]; then
	UUID=$(cat UUID)
	cp /etc/v2ray/config.init /etc/v2ray/config.json
	sed -i "s/PORT/$PORT/g" /etc/v2ray/config.json
	sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json
	echo "V2Ray Initialized"
	echo "UUID:$UUID"
	echo "Listening at 0.0.0.0:$PORT"
fi

exec "$@"
