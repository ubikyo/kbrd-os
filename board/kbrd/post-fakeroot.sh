#!/bin/sh
set -eu

## --------------------------------------------------------------
## Nginx
## --------------------------------------------------------------

echo "Nginx setup"

install -d -m 755 -o root -g root \
  "${TARGET_DIR}/var/log/nginx" \
  "${TARGET_DIR}/var/cache/nginx" \
  "${TARGET_DIR}/var/cache/nginx/client-body"

## Set ownership to www-data (uid/gid 33)
chown -R 33:33 \
  "${TARGET_DIR}/var/www" \
  "${TARGET_DIR}/var/cache/nginx"

install -d -m 755 -o root -g root "${TARGET_DIR}/usr/lib/python3.13/site-packages"