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
## Réseau

Le Wi-Fi est géré par `iwd`, en station comme en point d'accès : c'est lui
qui pose l'adresse d'un côté (`EnableNetworkConfiguration` dans
`/etc/iwd/main.conf`) et qui sert le DHCP de l'autre. Ni `hostapd` ni
`dnsmasq` ne sont embarqués.

Tout est piloté par `/usr/bin/kbrd-network`, appelé au démarrage par
`/etc/init.d/S72kbrd-network` et par KBRD-API quand l'onglet *Network* des
réglages est enregistré :

|Commande|Effet|
|-|-|
|`kbrd-network up`|Le chemin du démarrage : réseau enregistré s'il y en a un, point d'accès sinon|
|`kbrd-network apply`|Idem, après un enregistrement depuis KBRD-WEB|
|`kbrd-network hotspot`|Force le point d'accès|
|`kbrd-network status`|L'état de l'interface, une paire `clé<TAB>valeur` par ligne|
|`kbrd-network scan`|Les réseaux vus, `SSID<TAB>sécurité` par ligne — fonctionne aussi en mode point d'accès|

Sans réseau enregistré — un clavier qui sort de sa boîte — ou quand le
réseau enregistré ne répond pas dans le délai imparti, le clavier diffuse
son propre point d'accès. C'est cette retombée qui le rend récupérable
après un changement de box ou une clé erronée.

|Réglage d'usine|Valeur|
|-|-|
|SSID|`KBRD-<4 derniers caractères du numéro de série>`|
|Clé WPA2|`kbrd-setup`|
|Adresse|`192.168.100.1/24`|
|Plage DHCP|`192.168.100.10` → `192.168.100.100`|
|Délai avant retombée|30 s|

Ni passerelle ni DNS ne sont annoncés sur ce réseau : le clavier ne route
rien, et annoncer une route par défaut qui ne mène nulle part couperait
l'Internet du poste qui s'y connecte.

### Configuration

Deux fichiers, même format `CLE=valeur`, le second l'emportant clé par clé :

|Fichier|Contenu|
|-|-|
|`/etc/kbrd/network.conf`|Les valeurs d'usine, livrées avec l'image|
|`/data/network/network.conf`|Ce qui a été enregistré depuis KBRD-WEB, sur la partition qui survit à `make flash`|

> [!NOTE]
> Ce que fait le script au démarrage est repris à chaque fois dans
> `/var/log/kbrd-network.log`.

### Ordre de démarrage

Le réseau passe après l'interface graphique, pour que l'association et
l'attente du DHCP ne retardent pas l'affichage du clavier :

    S60kbrd-api → S70kbrd-dev → S71iwd → S72kbrd-network → S73nginx

`S71iwd` est déplacé depuis le `S40iwd` de Buildroot par `post-build.sh`.
`S40network`, lui, reste en place : `/etc/network/interfaces` ne déclare
que la boucle locale, par laquelle KBRD-DEV et KBRD-API se parlent.
