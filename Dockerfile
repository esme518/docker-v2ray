
#
# Dockerfile for v2ray
#

FROM alpine:latest

ADD https://storage.googleapis.com/v2ray-docker/v2ray /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/v2ctl /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geoip.dat /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geosite.dat /usr/bin/v2ray/

RUN set -ex && \
    apk --no-cache add ca-certificates && \
    mkdir /var/log/v2ray/ &&\
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray && \
    rm -rf /var/cache/apk

COPY config.json /etc/v2ray/config.json
COPY docker-entrypoint.sh /entrypoint.sh

ENV PATH /usr/bin/v2ray:$PATH
ENV PORT 8888

EXPOSE $PORT/tcp

WORKDIR /etc/v2ray

ENTRYPOINT ["/entrypoint.sh"]

CMD ["v2ray", "-config=/etc/v2ray/config.json"]
