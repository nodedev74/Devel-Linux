#!/bin/bash

set -e

if [[ $(id -u) == 0 ]];
then
    echo "[Error] This script should not be run as root"
    exit 1
fi

if [[ -f .bs ]]; then

    echo "[Warning] Bootstrap has been allready executed"

    read -p "Continue? (Y/N): " response
    if [[ "${response,}" != "y" ]]; 
    then
        exit 0
    fi
fi

read -p "Do you want to configure the build? (Y/N): " response

if [[ "${response,}" == "y" ]];
then
    read -p "Version: " version
    read -p "Name: " name
    read -p "Label: " label
    read -p "Publisher: " publisher
    read -p "Username: " username
    read -p "Locales: " locales
    read -p "Timezone: " timezone
    read -p "Keyboard Layouts: " keyboard_layouts

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
    echo "[Warning] The example configuration will be used"
    cp config.example.mk config.mk
fi

read -p "Do you want to set user and root passwords? (Y/N): " response
if [[ "${response,}" == "y" ]]; 
then
    read -p "User Password: " user_password
    read -p "Root Password: " root_password
    read -p "Partition Passphrase: " partition_passphrase

    cat <<EOF >> .env
USER_PASSWORD=${user_password}
ROOT_PASSWORD=${root_password}

PARTITION_PASSPHRASE=${partition_passphrase}
EOF

else
    echo "[Warning] "
fi

sudo apt-get -y install cryptsetup git live-build wget

git submodule update --init --recursive

sudo lb clean --purge

lb config noauto -d bookworm --debian-installer live --debian-installer-distribution bookworm \
    --archive-areas "main non-free-firmware" --debootstrap-options "--variant=minbase --include=apt-transport-https,gnupg,openssl"

sudo lb bootstrap

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

sudo lb chroot

cat <<EOF >> .bs
$(date '+%Y-%m-%d %H:%M:%S')
EOF
