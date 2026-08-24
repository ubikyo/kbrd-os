# KBRD-OS
Système d'exploitation pour le clavier basé sur un raspberry CM4.

## Compilation et transfert sur le raspberry

Compiler KBRD-OS depuis le projet [KBRD](https://github.com/ubikyo/kbrd)

## Modification de la configuration

### Système

Modifier la configuration :

    cd kbrd
    make -C buildroot O=$PWD/output menuconfig

Sauvegarder la configuration :

    make -C buildroot O=$PWD/output savedefconfig BR2_DEFCONFIG=$PWD/kbrd-os/configs/kbrd_defconfig

### Noyau

Modifier la configuration :

    cd kbrd
    make -C buildroot O=$PWD/output linux-menuconfig

Sauvegarder la configuration :

    make -C buildroot O=$PWD/output linux-update-defconfig

### Busybox

Modifier la configuration :

    cd kbrd
    make -C buildroot O=$PWD/output busybox-menuconfig

Sauvegarder la configuration :

    make -C buildroot O=$PWD/output busybox-update-config