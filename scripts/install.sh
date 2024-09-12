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
    echo "[Error] The Command has to be run as priviliged user"
    exit 1
fi

if [ -z "${ISO_FILE}" ];
then
    echo "[Error] There is no iso file to install"
    exit 1
fi

echo "\n"
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

dd if="$ISO_FILE" of="$USB_DEVICE" conv=fsync bs=4M status=progress

fdisk "$PERSISTENCE" <<< $(printf "n\np\n\n\n\nw")

printf "$PASSPHRASE" | cryptsetup luksFormat "$PERSISTENCE"
cryptsetup luksOpen "/dev/${USB_DEVICE}3" usb
mkfs.ext4 -L persistence /dev/mapper/usb
e2label /dev/mapper/usb persistence

mkdir -p "$MOUNT_POINT"
mount "$USB_DEVICE" "$MOUNT_POINT"

tee /mnt/usb/persistence.conf <<EOF
/home/$LIVE_USER/.zsh       link
/home/$LIVE_USER/.oh-m-zsh  link

/home/$LIVE_USER/.config    link

/var/cache/apt
EOF

umount /dev/mapper/usb
cryptsetup luksClose /dev/mapper/usb