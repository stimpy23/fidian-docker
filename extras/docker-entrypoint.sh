#!/bin/sh

DIR=/docker-entrypoint.d
if [ -d "$DIR" ]; then
  /bin/run-parts --regex='^.*\.sh$' "$DIR"
fi

exec "$@"
