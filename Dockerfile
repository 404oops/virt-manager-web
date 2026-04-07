# Simple container running virt-manager using jlesage/baseimage-gui
# Based on: https://github.com/jlesage/docker-baseimage-gui

FROM jlesage/baseimage-gui:debian-13-v4
LABEL maintainer="404oops"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        locales \
        libegl1 \
        libgl1 \
        libglx-mesa0 \
        libgbm1 \
        libgl1-mesa-dri \
        virt-manager \
        virt-viewer \
        spice-client-gtk \
        libvirt-clients \
        python3-libvirt \
        && SPICE_GTK_GI_PKG="$(apt-cache search '^gir1\.2-spiceclientgtk' | awk 'NR==1 {print $1}')" \
        && SPICE_GLIB_GI_PKG="$(apt-cache search '^gir1\.2-spiceclientglib' | awk 'NR==1 {print $1}')" \
        && if [ -n "$SPICE_GTK_GI_PKG" ]; then \
                 apt-get install -y --no-install-recommends "$SPICE_GTK_GI_PKG"; \
             else \
                 echo "WARNING: No SpiceClientGtk GI package found in apt repos"; \
             fi \
        && if [ -n "$SPICE_GLIB_GI_PKG" ]; then \
                 apt-get install -y --no-install-recommends "$SPICE_GLIB_GI_PKG"; \
             else \
                 echo "WARNING: No SpiceClientGLib GI package found in apt repos"; \
             fi \
    && sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    LIBGL_ALWAYS_SOFTWARE=1 \
    GALLIUM_DRIVER=llvmpipe \
    WEB_AUDIO=1

COPY rootfs/ /

RUN chmod +x /startapp.sh

RUN set-cont-env APP_NAME "virt-manager"