#!/bin/sh
set -e

if [ ! -f UUID ] && [ -z "$UUID" ]; then
	cat /proc/sys/kernel/random/uuid > UUID
elif [ ! -f UUID ] && [ -n "$UUID" ]; then
	echo $UUID > UUID
fi

UUID=$(cat UUID)

# Set config.json
if [ ! -f /etc/v2ray/config.json ]; then
	cp /etc/v2ray/config.init /etc/v2ray/config.json
	sed -i "s/PORT/$PORT/g" /etc/v2ray/config.json
	sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json
fi

echo starting v2ray platform
echo starting with UUID:$UUID
echo listening at 0.0.0.0:$PORT

exec "$@"
