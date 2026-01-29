#!/bin/bash
set -euo pipefail

BOARD_DIR="$(dirname "$0")"
BOARD_NAME="$(basename "${BOARD_DIR}")"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# --- /data filesystem (prebuilt) ---------------------------------------------
# Data à 200Mo
DATA_SIZE_M=100
DATA_IMG="${BINARIES_DIR}/data.ext4"
DATAFS_OVERLAY="${BOARD_DIR}/datafs-overlay"

# Essaie de récupérer l'UID/GID de l'utilisateur 'kbrd' tel qu'il existe dans le rootfs target
# (si dispo). Sinon on laisse root:root et tu pourras chown au boot.
KBRD_UID=1000
KBRD_GID=1000
PASSWD_FILE=""
GROUP_FILE=""

if [[ -n "${TARGET_DIR:-}" && -f "${TARGET_DIR}/etc/passwd" ]]; then
	PASSWD_FILE="${TARGET_DIR}/etc/passwd"
	GROUP_FILE="${TARGET_DIR}/etc/group"
elif [[ -f "${BUILD_DIR}/target/etc/passwd" ]]; then
	PASSWD_FILE="${BUILD_DIR}/target/etc/passwd"
	GROUP_FILE="${BUILD_DIR}/target/etc/group"
fi

if [[ -n "${PASSWD_FILE}" ]]; then
	KBRD_UID="$(awk -F: '$1=="kbrd"{print $3}' "${PASSWD_FILE}" || true)"
	if [[ -n "${GROUP_FILE}" ]]; then
		KBRD_GID="$(awk -F: '$1=="kbrd"{print $3}' "${GROUP_FILE}" || true)"
	fi
fi

# Prépare un overlay temporaire (pour pouvoir poser perms/ownership dedans)
DATA_STAGING="$(mktemp -d)"
cleanup() {
	rm -rf "${DATA_STAGING}"
	rm -rf "${GENIMAGE_TMP}"
	rm -rf "${ROOTPATH_TMP}"
}
trap cleanup EXIT

mkdir -p "${DATA_STAGING}"

# Overlay optionnel: board/kbrd/datafs-overlay/ (tu peux y mettre media/, db/, etc.)
if [[ -d "${DATAFS_OVERLAY}" ]]; then
	cp -a "${DATAFS_OVERLAY}/." "${DATA_STAGING}/"
fi

# S'assure que le point /data existe DANS la partition data (racine du fs data)
# Ici, la partition "data" sera montée sur /data, donc on met le contenu directement à la racine.
# Exemple: si tu veux /data/media, alors crée "media/" dans datafs-overlay.
# On met quand même les perms de la racine.
chmod 755 "${DATA_STAGING}"

# Si on peut, on met le bon owner sur la racine du fs data (sinon, ça restera root:root)
# Note: chown nécessite des droits; on tente via fakeroot si dispo.
if command -v fakeroot >/dev/null 2>&1 && [[ -n "${KBRD_UID}" && -n "${KBRD_GID}" ]]; then
	fakeroot sh -c "chown -R ${KBRD_UID}:${KBRD_GID} '${DATA_STAGING}'"
fi

# Construit data.ext4 sans montage (mkfs.ext4 -d copie l'arborescence)
rm -f "${DATA_IMG}"
truncate -s "${DATA_SIZE_M}M" "${DATA_IMG}"
mkfs.ext4 -F -L data -d "${DATA_STAGING}" "${DATA_IMG}" >/dev/null

# --- Boot firmware files ------------------------------------------------------
if [ -f "${BOARD_DIR}/config.txt" ]; then
	install -D -m 0644 "${BOARD_DIR}/config.txt" \
		"${BINARIES_DIR}/rpi-firmware/config.txt"
fi

if [ -f "${BOARD_DIR}/cmdline.txt" ]; then
	install -D -m 0644 "${BOARD_DIR}/cmdline.txt" \
		"${BINARIES_DIR}/rpi-firmware/cmdline.txt"
fi

# --- genimage cfg generation (si pas de variante board) ----------------------
if [ ! -e "${GENIMAGE_CFG}" ]; then
	GENIMAGE_CFG="${BINARIES_DIR}/genimage.cfg"
	FILES=()

	for i in "${BINARIES_DIR}"/*.dtb "${BINARIES_DIR}"/rpi-firmware/*; do
		FILES+=( "${i#${BINARIES_DIR}/}" )
	done

	KERNEL=$(sed -n 's/^kernel=//p' "${BINARIES_DIR}/rpi-firmware/config.txt")
	FILES+=( "${KERNEL}" )

	BOOT_FILES=$(printf '\\t\\t\\t"%s",\\n' "${FILES[@]}")
	sed "s|#BOOT_FILES#|${BOOT_FILES}|" "${BOARD_DIR}/genimage.cfg.in" \
		> "${GENIMAGE_CFG}"
fi

# --- genimage ----------------------------------------------------------------
ROOTPATH_TMP="$(mktemp -d)"
rm -rf "${GENIMAGE_TMP}"

export BOARD_DIR

genimage \
	--rootpath "${ROOTPATH_TMP}"   \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
