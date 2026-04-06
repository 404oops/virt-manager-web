# Simple container running virt-manager over GTK Broadway.

FROM debian:bookworm-slim
LABEL maintainer="404oops"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        locales \
        ca-certificates \
        virt-manager \
        virt-viewer \
        spice-client-gtk \
        libgtk-3-bin \
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
    LC_ALL=en_US.UTF-8

EXPOSE 8085

COPY rootfs/ /

RUN chmod +x /startapp.sh

ENTRYPOINT ["/startapp.sh"]