#!/bin/sh
set -eu


# --------------------------------------------------------------------------------
# Dossier data pour le montage du volume data
# --------------------------------------------------------------------------------

install -d -m 755 -o root -g root "${TARGET_DIR}/data"

# --------------------------------------------------------------------------------
# Nginx
# --------------------------------------------------------------------------------

# On créé les dossiers nécessaires
install -d -m 755 -o root -g root \
  "${TARGET_DIR}/var/log/nginx" \
  "${TARGET_DIR}/var/cache/nginx" \
  "${TARGET_DIR}/var/cache/nginx/client-body"

# On définit le propriétaire pour www-data (uid/gid 33)
chown -R 33:33 \
  "${TARGET_DIR}/var/www" \
  "${TARGET_DIR}/var/cache/nginx"