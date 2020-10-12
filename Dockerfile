#
# Dockerfile for v2ray
#

FROM golang:alpine as builder

RUN apk update && apk add --no-cache git bash wget curl
WORKDIR /build
RUN git clone --progress https://github.com/v2fly/v2ray-core.git . && \
    bash ./release/user-package.sh nosource noconf codename=$(git describe --abbrev=0 --tags) buildname=docker-fly abpathtgz=/tmp/v2ray.tgz

FROM alpine:latest

COPY --from=builder /tmp/v2ray.tgz /tmp

RUN set -ex && \
    apk --no-cache add ca-certificates && \
    mkdir /var/log/v2ray/ &&\
    mkdir -p /usr/bin/v2ray && \
    tar xvfz /tmp/v2ray.tgz -C /usr/bin/v2ray && \
    rm -rf /var/cache/apk

COPY config.json /etc/v2ray/config.json
COPY docker-entrypoint.sh /entrypoint.sh

ENV PATH /usr/bin/v2ray:$PATH
ENV PORT 8888

WORKDIR /etc/v2ray

ENTRYPOINT ["/entrypoint.sh"]

CMD ["v2ray", "-config=/etc/v2ray/config.json"]
