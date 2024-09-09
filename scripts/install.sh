#!/bin/bash

set -e

USB_DEVICE="$1"
MOUNT_POINT=""

ISO_FILE="$(find . -name '*.iso')"

LIVE_USER="$2"

PERSISTENCE="${USB_DEVICE}3"
PASSPHRASE="$3"

if [ id -u != 0 ];
then 
    echo ""
    exit 1
fi

if [ -z "${ISO_FILE}" ];
then
    echo ""
    exit 1
fi

echo ""

# todo: wipe up whole disk

dd if="$ISO_FILE" of="$USB_DEVICE" conv=fsync bs=4M status=progress

fdisk "$PERSISTENCE" <<< $(printf "n\np\n\n\n\nw")

printf "$PASSPHRASE" | cryptsetup luksFormat "$PERSISTENCE"
cryptsetup luksOpen /dev/sdX3 usb
mkfs.ext4 -L persistence /dev/mapper/usb
e2label /dev/mapper/usb persistence

mkdir -p "$MOUNT_POINT"
mount "$USB_DEVICE" "$MOUNT_POINT"

tee /mnt/usb/persistence.conf <<EOF
/home/$LIVE_USER/.zsh       link
/home/$LIVE_USER/.oh-m-zsh  link

/home/$LIVE_USER/.config

/var/cache/apt
EOF

umount /dev/mapper/usb
cryptsetup luksClose /dev/mapper/usb