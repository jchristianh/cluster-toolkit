#!/bin/bash

STATIC_IMG="/opt/cluster/STATIC_IMAGE/DEB10"

printf "purging existing static image ..."
rm -rf ${STATIC_IMG}/*
printf "done!\n";

echo "creating minimal base image at ${STATIC_IMG}..."

#debootstrap --include linux-image-amd64,grub-pc,locales --arch amd64 buster ${STATIC_IMG} http://ftp.us.debian.org/debian

debootstrap --include linux-image-amd64,grub-pc,locales --arch=amd64 buster ${STATIC_IMG} http://mirror.cc.columbia.edu/debian/
#debootstrap --arch=amd64 bionic ${STATIC_IMG} http://archive.ubuntu.com/ubuntu/
