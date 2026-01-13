# Installation

## Workspace de base
Créer un dossier kbrd
mkdir kbrd
cd kbrd

## Cloner buildroot
git clone https://github.com/buildroot/buildroot.git

## Cloner kbrd-os
git clone https://github.com/ubikyo/kbrd-os.git

## Définir kbrd-os comme projet externe
export BR2_EXTERNAL=$PWD/kbrd-os

## Créer une configuration depuis le defconfig dans le répertoire output
make -C buildroot O=$PWD/output kbrd_defconfig

## On efface l'image précédent et on compile
rm -f output/images/*.img && \
make -C buildroot O=$PWD/output target-finalize && \
make -C buildroot O=$PWD/output

# Si nécessaire

## Menuconfig pour modifier les options du système
make -C buildroot O=$PWD/output menuconfig

## Menuconfig pour modifier le noyau
make -C buildroot O=$PWD/output linux-menuconfig

## Menuconfig pour modifier busybox
make -C buildroot O=$PWD/output busybox-menuconfig

## Sauvegarder la configuration modifiée de menuconfig dans defconfig
make -C buildroot O=$PWD/output savedefconfig BR2_DEFCONFIG=$PWD/kbrd-os/configs/kbrd_defconfig

## Sauvegarder la configuration modifiée du moyan dans defconfig
make -C buildroot O=$PWD/output linux-update-defconfig


# Nettoyage 
## soft
make -C buildroot O=$PWD/output clean


## Reset complet
make -C buildroot O=$PWD/output distclean

