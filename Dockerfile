#
# Dockerfile for v2ray
#

FROM ubuntu:latest as builder

RUN apt-get update
RUN apt-get install curl -y
RUN curl -L -o /tmp/install-release.sh https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
RUN curl -L -o /tmp/install-dat-release.sh https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh
RUN chmod +x /tmp/install*
RUN /tmp/install-release.sh
RUN /tmp/install-dat-release.sh

FROM alpine:latest

COPY --from=builder /usr/local/bin/v2ray /usr/bin/v2ray/
COPY --from=builder /usr/local/bin/v2ctl /usr/bin/v2ray/
COPY --from=builder /usr/local/share/v2ray/geoip.dat /usr/bin/v2ray/
COPY --from=builder /usr/local/share/v2ray/geosite.dat /usr/bin/v2ray/

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

WORKDIR /etc/v2ray

ENTRYPOINT ["/entrypoint.sh"]

CMD ["v2ray", "-config=/etc/v2ray/config.json"]
