#!/bin/sh

if [ ! -f UUID ]; then
	cat /proc/sys/kernel/random/uuid > UUID
	UUID=$(cat UUID)
fi

# Set config.json
sed -i "s/PORT/$PORT/g" /etc/v2ray/config.json
sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json

echo starting v2ray server
echo starting with UUID:$UUID
echo listening at 0.0.0.0:$PORT

exec "$@"
