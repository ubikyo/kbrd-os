#!/bin/sh

set -eu

# --------------------------------------------------------------------------------
# Ajout d'une console sur tty1
# --------------------------------------------------------------------------------

INITTAB="${TARGET_DIR}/etc/inittab"

if [ -f "${INITTAB}" ]; then
  # Ajoute tty1 seulement si absent
  grep -q '^tty1::' "${INITTAB}" || \
    sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L tty1 0 vt100 # HDMI console' "${INITTAB}"
fi


# --------------------------------------------------------------------------------
# On supprime dropbear
# --------------------------------------------------------------------------------

rm -f "${TARGET_DIR}/etc/init.d/S50dropbear"