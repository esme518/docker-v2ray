#
# Dockerfile for v2ray
#

FROM v2fly/v2fly-core as source

FROM alpine
COPY --from=source /usr/bin/v2ray /usr/bin/v2ray
COPY --from=source /usr/local/share/v2ray /usr/local/share/v2ray

COPY config.init /etc/v2ray/config.init
COPY docker-entrypoint.sh /entrypoint.sh

RUN set -ex \
  && apk add --update --no-cache \
     ca-certificates \
     openssl \
  && mkdir -p /var/log/v2ray \
  && rm -rf /tmp/* /var/cache/apk/*

ENV PATH /usr/bin/v2ray:$PATH
ENV PORT 8888

WORKDIR /etc/v2ray

ENTRYPOINT ["/entrypoint.sh"]
CMD ["v2ray","run","-c","/etc/v2ray/config.json"]
