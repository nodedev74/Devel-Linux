#!/bin/bash

set -e

if [ id -u = 0 ];
then
    echo ""
    exit 1
fi

ISO_APPLICATION_NAME="$1"
ISO_APPLICATION_LABEL="$2"
ISO_PUBLISHER="$3"

LIVE_USERNAME="$4"
LIVE_LOCALES="$5"
LIVE_TIMEZONE="$6"
LIVE_KEYBOARD_LAYOUT="$7"

sudo lb clean

lb config noauto \
    -d bookworm \
    --image-name "$ISO_APPLICATION_NAME" \
    --iso-application "$ISO_APPLICATION_LABEL" \
    --iso-publisher "$ISO_PUBLISHER" \
    --debian-installer none \
    --archive-areas "main contrib non-free-firmware" \
    --debootstrap-options "--variant=minbase --include=apt-transport-https,gnupg,openssl" \
    --bootappend-live "boot=live components username=$LIVE_USERNAME locales=$LIVE_LOCALES timezone=$LIVE_TIMEZONE keyboard-layouts=$LIVE_KEYBOARD_LAYOUT noautologin"

sudo lb build