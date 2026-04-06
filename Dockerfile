# Simple container running virt-manager using jlesage/baseimage-gui
# Based on: https://github.com/jlesage/docker-baseimage-gui

FROM jlesage/baseimage-gui:debian-13-v4
LABEL maintainer="404oops"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        virt-manager \
        libvirt-clients \
        libvirt-daemon-system \
        python3-libvirt \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY start-virt-manager.sh /usr/local/bin/start-virt-manager.sh
RUN chmod +x /usr/local/bin/start-virt-manager.sh

EXPOSE 6901

CMD ["/usr/local/bin/start-virt-manager.sh"]