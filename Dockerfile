#
# Dockerfile for v2ray
#

FROM v2fly/v2fly-core

COPY config.init /etc/v2ray/config.init
COPY docker-entrypoint.sh /entrypoint.sh

ENV PATH /usr/bin/v2ray:$PATH
ENV PORT 8888

WORKDIR /etc/v2ray

ENTRYPOINT ["/entrypoint.sh"]
CMD ["v2ray", "-config=/etc/v2ray/config.json"]
