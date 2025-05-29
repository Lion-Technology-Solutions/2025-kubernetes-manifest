#!/bin/sh
set -e

# Ensure permissions are correct
if [ "$(id -u)" = "0" ]; then
  chown -R nexus:nexus ${NEXUS_DATA} ${NEXUS_HOME}
  exec su-exec nexus "$@"
else
  exec "$@"
fi