#!/bin/bash
set -e
################################################
# Script to install usbmount on an embedded arm device running yocto.
#
# Run like './install.sh root@192.168.999.999' with the argument being the ssh
# connection string for an embedded arm device.
################################################

TARGET=$1
if [ $TARGET ]; then
    echo "Installing on $TARGET..."
else
    echo "You must provide a target!"
    exit 1
fi

echo "Creating directories..."
ssh $TARGET 'mkdir -p /etc/usbmount/mount.d'
ssh $TARGET 'mkdir -p /etc/usbmount/umount.d'
ssh $TARGET 'mkdir -p /usr/share/usbmount'
ssh $TARGET 'for i in 0 1 2 3 4 5 6 7; do mkdir -p /media/usb$i; done'

echo "Transferring files..."
scp 00_create_model_symlink $TARGET:/etc/usbmount/mount.d/.
scp 00_remove_model_symlink $TARGET:/etc/usbmount/umount.d/.
scp usbmount                $TARGET:/usr/share/usbmount/.
scp usbmount.conf           $TARGET:/etc/usbmount/.
scp 90-usbmount.rules       $TARGET:/lib/udev/rules.d/.
scp usbmount@.service       $TARGET:/lib/systemd/system/.
