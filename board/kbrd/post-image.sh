#!/bin/bash

# Arrête le script si échec d'une commande, variable non définie ou erreur dans un pipe
set -euo pipefail

# --------------------------------------------------------------------------------
# Dossiers de base
# --------------------------------------------------------------------------------

# Dossier de la carte "board/kbrd/"
BOARD_DIR="$(dirname "$0")"
# Nom de la carte "kbrd"
BOARD_NAME="$(basename "${BOARD_DIR}")"
# Chemin de configuration temporaire
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
# Chemin de la configuration genimage.cfg
GENIMAGE_CFG="${BINARIES_DIR}/genimage.cfg"


# --------------------------------------------------------------------------------
# On nettoie les dossiers temporaires quand le script se termine
# --------------------------------------------------------------------------------

cleanup() {
  rm -rf "${GENIMAGE_TMP}"
  rm -rf "${ROOTPATH_TMP:-}"
}
trap cleanup EXIT


# --------------------------------------------------------------------------------
# Copie les config.txt et cmdline.txt
# --------------------------------------------------------------------------------

install -D -m 0644 "${BOARD_DIR}/config.txt" "${BINARIES_DIR}/rpi-firmware/config.txt"
install -D -m 0644 "${BOARD_DIR}/cmdline.txt" "${BINARIES_DIR}/rpi-firmware/cmdline.txt"


# --------------------------------------------------------------------------------
# On copie les fichiers boot dans genimage.cfg
# --------------------------------------------------------------------------------

FILES=()
for i in "${BINARIES_DIR}"/*.dtb "${BINARIES_DIR}/rpi-firmware/"*; do
  [[ -e "$i" ]] || continue
  FILES+=( "${i#${BINARIES_DIR}/}" )
done

KERNEL="$(sed -n 's/^kernel=//p' "${BINARIES_DIR}/rpi-firmware/config.txt" | head -n1 || true)"
[[ -n "${KERNEL}" ]] && FILES+=( "${KERNEL}" )

BOOT_FILES=$(printf '\\t\\t\\t"%s",\\n' "${FILES[@]}")
sed "s|#BOOT_FILES#|${BOOT_FILES}|" "${BOARD_DIR}/genimage.cfg.in" > "${GENIMAGE_CFG}"


# --------------------------------------------------------------------------------
# On copie tous les overlays vc4-kms nécessaires depuis notre propre arbre kernel
# (jamais depuis rpi-firmware ni un fichier externe), pour garantir la
# correspondance des labels DT entre le .dtb de base et les overlays.
# --------------------------------------------------------------------------------

LINUX_BUILD_DIR="$(find "${BUILD_DIR}" -maxdepth 1 -iname "linux-rpi-*" ! -iname "linux-headers-*" | head -n1)"

mkdir -p "${BINARIES_DIR}/rpi-firmware/overlays"

# KMS VC4 pour BCM2711 / CM4
cp -f \
  "${LINUX_BUILD_DIR}/arch/arm64/boot/dts/overlays/vc4-kms-v3d-pi4.dtbo" \
  "${BINARIES_DIR}/rpi-firmware/overlays/vc4-kms-v3d.dtbo"

# Panel Waveshare
cp -f \
  "${LINUX_BUILD_DIR}/arch/arm64/boot/dts/overlays/vc4-kms-dsi-waveshare-panel-v2.dtbo" \
  "${BINARIES_DIR}/rpi-firmware/overlays/vc4-kms-dsi-waveshare-panel-v2.dtbo"

# --------------------------------------------------------------------------------
# On génère l'image finale avec genimage
# --------------------------------------------------------------------------------

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