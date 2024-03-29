#!/bin/sh

DEBUG_LEVEL=${DEBUG_LEVEL:-0}
EXPORTER_PORT=${EXPORTER_PORT:-9113}
RADOSGW_HOST=${RADOSGW_HOST:-'127.0.0.1'}
RADOSGW_PORT=${RADOSGW_PORT:-8080}
RADOSGW_PROTO=${RADOSGW_PROTO:-'http'}

if test "$DEBUG"; then
    if test "$DEBUG_LEVEL" -lt 1 2>/dev/null; then
	DEBUG_LEVEL=1
    fi
    set -x
fi

export RADOSGW_SERVER=$RADOSGW_PROTO://$RADOSGW_HOST:$RADOSGW_PORT \
    VIRTUAL_PORT=${EXPORTER_PORT} \
    DEBUG=${DEBUG_LEVEL}
unset RADOSGW_HOST RADOSGW_PORT RADOSGW_PROTO DEBUG_LEVEL EXPORTER_PORT

exec python -u /usr/src/app/radosgw_usage_exporter.py
