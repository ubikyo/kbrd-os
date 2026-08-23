#!/bin/bash
set -e

IMAGE="../output/images/kbrd.img"

clear 

printf "\n\033[47;30m %-60s \033[0m\n\n" "On démarre le raspberry en périphérique de stockage"

cd ../usbboot
sudo ./rpiboot -d mass-storage-gadget64

printf "\n\033[47;30m %-60s \033[0m\n" "En attente du raspberry"

while true; do
    DEVICE=$(lsblk -dn -o NAME,MODEL,TRAN | \
        awk '$NF == "usb" && /Raspberry Pi multi-function USB device/ {print "/dev/"$1; exit}')

    [ -n "$DEVICE" ] && break
    sleep 1
done

printf "\n\033[47;30m %-60s \033[0m\n\n" "Périphérique détecté : $DEVICE"

printf "On copie l'image\n\n"

pv -f "$IMAGE" | sudo dd of="$DEVICE" bs=4M iflag=fullblock oflag=direct

printf "\nOn vide le buffer\n\n"
sudo blockdev --flushbufs "$DEVICE"

printf "On éjecte le périphérique\n"
sudo eject "$DEVICE"

printf "\n\033[47;30m %-60s \033[0m\n\n" "Transfert terminé !"
