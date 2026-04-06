#!/bin/sh
set -eu
mkdir -p /opt
export HOME=/opt

BROADWAY_DISPLAY="${BROADWAY_DISPLAY:-:5}"
BROADWAY_PORT="${BROADWAY_PORT:-8085}"
BROADWAY_BIND="${BROADWAY_BIND:-0.0.0.0}"

# Ensure GTK app connects to the exact Broadway display we start.
export BROADWAY_DISPLAY

# Some distros ship broadwayd variants without --address/--port.
if /usr/bin/broadwayd --help 2>&1 | grep -q -- '--port'; then
	/usr/bin/broadwayd --address "${BROADWAY_BIND}" --port "${BROADWAY_PORT}" "${BROADWAY_DISPLAY}" &
else
	/usr/bin/broadwayd "${BROADWAY_DISPLAY}" &
fi
BROADWAY_PID="$!"

cleanup() {
	kill "${BROADWAY_PID}" 2>/dev/null || true
}

trap cleanup INT TERM EXIT

export GDK_BACKEND=broadway
exec /usr/bin/dbus-run-session -- /usr/bin/virt-manager --no-fork
