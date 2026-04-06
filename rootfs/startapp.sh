#!/bin/sh
set -eu

export HOME=/config
# Force software rendering and disable GTK GL context creation in the container client.
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export MESA_LOADER_DRIVER_OVERRIDE=llvmpipe
export GDK_GL=disable
exec /usr/bin/virt-manager
