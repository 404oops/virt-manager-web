#!/bin/sh
set -eu
mkdir -p /opt
export HOME=/opt

BROADWAY_DISPLAY="${BROADWAY_DISPLAY:-:5}"
BROADWAY_PORT="${BROADWAY_PORT:-8085}"
BROADWAY_BIND="${BROADWAY_BIND:-0.0.0.0}"

/usr/bin/broadwayd --address "${BROADWAY_BIND}" --port "${BROADWAY_PORT}" "${BROADWAY_DISPLAY}" &
BROADWAY_PID="$!"

cleanup() {
	kill "${BROADWAY_PID}" 2>/dev/null || true
}

trap cleanup INT TERM EXIT

export GDK_BACKEND=broadway
exec /usr/bin/virt-manager
