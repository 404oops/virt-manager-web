#!/bin/sh
set -eu

export HOME=/config
# Force software rendering and disable GTK GL context creation in the container client.
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export MESA_LOADER_DRIVER_OVERRIDE=llvmpipe
export GDK_GL=disable
if [ -z "$LIBVIRT_DEFAULT_URI" ]; then
  exec /usr/bin/virt-manager -c LIBVIRT_DEFAULT_URI
else
  exec /usr/bin/virt-manager
fi
