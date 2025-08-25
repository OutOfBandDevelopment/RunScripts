#!/bin/sh
# Forward remote debugging port to allow host access
socat TCP-LISTEN:9223,fork,reuseaddr TCP:127.0.0.1:9222 &

# Start Chrome and keep container alive until Chrome exits
google-chrome \
  --remote-debugging-address=0.0.0.0 \
  --remote-debugging-port=9222 \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --user-data-dir=/tmp/google-chrome/config \
  --disable-software-rasterizer \
  --disable-extensions "$@"
