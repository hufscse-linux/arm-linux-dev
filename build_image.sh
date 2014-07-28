#!/bin/bash

WORKSPACE=$PWD
TMP_DIR=$WORKSPACE/tmp
TARGET_IMAGE=$WORKSPACE/tmp/qemu_mmc.img
PARTITION_MAP=$WORKSPACE/tmp/partition_map

rm -rf $TMP_DIR

dd if=/dev/zero of=$TARGET_IMAGE bs=4M count=100

echo "build msdos partition table"
sudo parted --script $TARGET_IMAGE mklabel msdos

echo "create primary partition 1"
sudo parted --script $TARGET_IMAGE mkpart primary fat32 1 100

echo "create primary partition 2"
sudo parted --script $TARGET_IMAGE mkpart primary ext2 101 399

echo "set primary partition 1 as a bootable"
sudo parted --script $TARGET_IMAGE set 1 boot on

sudo kpartx -av $TARGET_IMAGE > $PARTITION_MAP

PARTITION_1=/dev/mapper/$(cat $PARTITION_MAP | grep p1 | awk '{ print $3 }')
PARTITION_2=/dev/mapper/$(cat $PARTITION_MAP | grep p2 | awk '{ print $3 }')

echo "format primary partition1 to vfat"
sudo mkfs.vfat $PARTITION_1

echo "format primary partition1 to ext4"
sudo mkfs.ext4 $PARTITION_2

sudo kpartx -d $TARGET_IMAGE

