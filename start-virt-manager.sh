#!/bin/bash
set -euo pipefail

# Ensure locale environment variables are exported so GTK doesn't complain.
export LANG=${LANG:-en_US.UTF-8}
export LANGUAGE=${LANGUAGE:-en_US:en}
export LC_ALL=${LC_ALL:-en_US.UTF-8}

# Ensure DISPLAY is set to the container X server (baseimage typically provides :0)
export DISPLAY=${DISPLAY:-:0}

# Wait for X socket to appear before launching the GUI app (timeout ~30s)
WAIT_SECONDS=30
COUNT=0
while [ ! -e /tmp/.X11-unix/X0 ] && [ $COUNT -lt $WAIT_SECONDS ]; do
	sleep 1
	COUNT=$((COUNT+1))
done

if [ ! -e /tmp/.X11-unix/X0 ]; then
	echo "Warning: X socket /tmp/.X11-unix/X0 not found after ${WAIT_SECONDS}s; attempting to start anyway"
fi

exec virt-manager --no-fork
