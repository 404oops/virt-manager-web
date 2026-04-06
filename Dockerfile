# Simple container running virt-manager using jlesage/baseimage-gui
# Based on: https://github.com/jlesage/docker-baseimage-gui

FROM jlesage/baseimage-gui:debian-13-v4
LABEL maintainer="404oops"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        locales \
        virt-manager \
        virt-viewer \
        spice-client-gtk \
        libvirt-clients \
        python3-libvirt \
    && sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

COPY rootfs/ /

RUN chmod +x /startapp.sh

RUN set-cont-env APP_NAME "virt-manager"