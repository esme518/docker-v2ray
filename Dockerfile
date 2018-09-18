
#
# Dockerfile for v2ray
#

FROM ubuntu:latest as builder

RUN apt-get update
RUN apt-get install curl -y
RUN curl -L -o /tmp/go.sh https://install.direct/go.sh
RUN chmod +x /tmp/go.sh
RUN /tmp/go.sh

FROM alpine:latest

COPY --from=builder /usr/bin/v2ray/v2ray /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/v2ctl /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geoip.dat /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geosite.dat /usr/bin/v2ray/

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
