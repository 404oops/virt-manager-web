#!/bin/bash
set -euo pipefail

# Start virt-manager in the GUI session provided by the jlesage baseimage-gui.
# The baseimage provides an X session + web access (noVNC). virt-manager is a GTK app
# and should display in that session.

exec virt-manager --no-fork
