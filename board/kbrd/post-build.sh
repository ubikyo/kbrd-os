#!/bin/sh

set -eu

# --------------------------------------------------------------------------------
# Suppression console sur TTY1
# --------------------------------------------------------------------------------

sed -i '\|^tty1::respawn:/sbin/getty|d' "${TARGET_DIR}/etc/inittab"


# --------------------------------------------------------------------------------
# On supprime dropbear
# --------------------------------------------------------------------------------

rm -f "${TARGET_DIR}/etc/init.d/S50dropbear"

# --------------------------------------------------------------------------------
# Ordre de démarrage du réseau
# --------------------------------------------------------------------------------
#
# Buildroot installe iwd en S40, donc avant KBRD-DEV : l'association
# Wi-Fi et l'attente du DHCP retardaient l'affichage du clavier. On le
# repousse derrière S70kbrd-dev, juste avant S72kbrd-network qui s'appuie
# dessus et S73nginx qui sert KBRD-WEB.
#
# S40network, lui, reste où il est : /etc/network/interfaces ne déclare
# que la boucle locale (voir le rootfs-overlay), et c'est par elle que
# KBRD-DEV et KBRD-API se parlent en 127.0.0.1.

if [ -e "${TARGET_DIR}/etc/init.d/S40iwd" ]; then
  mv "${TARGET_DIR}/etc/init.d/S40iwd" "${TARGET_DIR}/etc/init.d/S71iwd"
fi
