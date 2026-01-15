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

## On efface l'image précédente et on compile
rm -rf output/target && \
rm -f output/images/*.img && \
make -C buildroot O=$PWD/output target && \
make -C buildroot O=$PWD/output target-finalize && \
make -C buildroot O=$PWD/output

# Nettoyage 
## soft
make -C buildroot O=$PWD/output clean

## Reset complet
make -C buildroot O=$PWD/output distclean

# SSH

## Création d'un clé
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/kbrd -C "kbrd"
chmod 600 ~/.ssh/kbrd
chmod 644 ~/.ssh/kbrd.pub

## Récupération de la clé publique
nano ~/.ssh/kbrd.pub

## Se connecter en SFTP
sftp -i ~/.ssh/kbrd kbrd@172.16.12.200

# GIT

## Créer une clé
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/jquintard -C "jquintard"

## Ajouter cette clé à l'agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/jquintard

## Récupérer la clé publique
cat ~/.ssh/jquintard.pub

## Dans gihub
Settings
SSH and GPG keys
New SSH key
De type authentication
Coller la clé publique

# Tester l'accès
ssh -T git@github.com

# Modifier l'accès au dépôt via SSH
git remote set-url origin git@github.com:ubikyo/kbrd-os.git
git remote set-url origin git@github.com:ubikyo/kbrd-ui.git
git remote -v


# Bootchart

## Installation du client
sudo apt install python3-cairo
git clone https://github.com/xrmx/bootchart.git
cp -v bootchart/pybootchartgui/main.py.in bootchart/pybootchartgui/main.py

## Récupérer le fichier
scp kbrd:/var/log/bootlog.tgz resources/bootlog.tgz
python3 bootchart/pybootchartgui.py -f png -o resources/ resources/bootlog.tgz