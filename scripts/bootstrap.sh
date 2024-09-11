#!/bin/bash

set -e

if [ id -u = 0 ];
then
    echo ""
    exit 1
fi

echo "[Warning] "

response=$(read -p "Continue? (Y/N) ")
if [];
then
    exit 1
fi

response=$(read -p "")
if [];
then
    version=$(read -p "")
    name=$(read -p "")
    label=$(read -p "")
    publisher=$(read -p "")
    username=$(read -p "")
    locales=$(read -p "")
    timezone=$(read -p "")
    keyboard_layouts=$(read -p "")

    cat <<EOF >> config.mk
    # Config v1
    
    VERSION=${version}
    NAME=${name}
    LABEL=${label}
    PUBLISHER=${publisher}

    USERNAME=${username}
    LOCALES=${locales}
    TIMEZONE=${timezone}
    KEYBOARD_LAYOUTS=${keyboard_layouts}
    EOF
else 
    echo "[Warning] "
    cp config.example.mk config.mk
fi

response=$(read -p "")
if [];
then
    user_password=$(read -p "")
    root_password=$(read -p "")
    partition_passphrase=$(read -p "")

    cat <<EOF >> .env
    USER_PASSWORD=${user_password}
    ROOT_PASSWORD=${root_password}

    PARTITION_PASSPHRASE=${partition_passphrase}
    EOF
else
    echo "[Warning] "
fi

sudo apt-get -y install cryptsetup git live-build wget

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
