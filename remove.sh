#!/bin/bash
set -e
################################################
# Script to remove usbmount from an embedded arm device running yocto.
#
# Run like './remove.sh root@192.168.999.999' with the argument being the ssh
# connection string for an embedded arm device.
################################################

TARGET=$1
if [ $TARGET ]; then
    echo "Removing from $TARGET..."
else
    echo "You must provide a target!"
    exit 1
fi

echo "Removing directories..."
ssh $TARGET 'rm -rf /etc/usbmount'
ssh $TARGET 'rm -rf /usr/share/usbmount'
ssh $TARGET 'for i in 0 1 2 3 4 5 6 7; do rm -rf /media/usb$i; done'

echo "Removing files..."
ssh $TARGET 'rm -f /lib/udev/rules.d/90-usbmount.rules'
ssh $TARGET 'rm -f /lib/systemd/system/usbmount@.service'
