FROM ghcr.io/linuxserver/baseimage-alpine:edge

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sweisgerber"

RUN set -ex \
  echo "**** setup apk testing mirror ****" \
  && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && cat /etc/apk/repositories \
  && echo "**** install runtime packages ****" \
  && apk add --no-cache -U --upgrade \
    alsa-utils \
    librespot@testing \
    shairport-sync@testing \
    snapcast \
    snapweb@testing \
#    avahi \
  && apk add -U avahi \
    avahi-tools \
#  && apk add dbus \
#  && dbus-uuidgen > /var/lib/dbus/machine-id \
#  && mkdir -p /var/run/dbus \
  && echo "**** cleanup ****" \
  && rm -rf \
    /tmp/* \
    /etc/ssl \
    /var/cache/apk/* \
    /lib/apk/db/*

# apk add alsa-utils alsa-lib alsaconf alsa-ucm-conf
# environment settings
ENV \
START_SNAPCLIENT=true \
START_SNAPSERVER=false \
SNAPCLIENT_OPTS="" \
SNAPSERVER_OPTS=""

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 1704
EXPOSE 1780
#
VOLUME /config /data
