# KBRD-OS
Système d'exploitation pour le clavier basé sur un raspberry CM4.

## Compilation

Compiler KBRD-OS depuis le projet [KBRD](https://github.com/ubikyo/kbrd)

## Transfert vers le raspberry

Vérifier que l'image est disponible dans le dossier **/output/images/kbrd.img**. Connecter via le port USBC, le raspberry, sur l'ordinateur avec l'interrupteur **BOOT** activé. 

Installer pv :

    sudo apt install pv :

Lancer le transfert :

    ./transfert.sh

Une fois terminé on désactive le mode **BOOT** boot via l'interrupteur et on redémarre le raspberry.


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