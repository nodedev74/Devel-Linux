#!/bin/bash

set -e

if [ id -u = 0 ];
then
    echo ""
    exit 1
fi

sudo apt-get install live-build git cryptsetup

cp config.example.mk config.mk
cp .env.example .env


sudo lb clean --purge

lb config noauto -d bookworm --debian-installer live --debian-installer-distribution bookworm \
    --archive-areas "main non-free-firmware" --debootstrap-options "--variant=minbase --include=apt-transport-https,gnupg,openssl"

sudo lb chroot

for file in $(find . -name '*.url');
do
    directory=$(dirname $file)
    read -r url < $file
    filename=$(basename -- $url)
    path="${directory}/${filename}"
    
    wget -O $path $url
    git update-index --assume-unchanged $file
    rm -f $file
done
