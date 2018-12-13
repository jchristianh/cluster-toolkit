#!/bin/bash

NODE_IP=$1
STATIC_IMG="/opt/cluster/STATIC_IMAGE/CENTOS7_64/*"
ROOT_PATH="/tftpboot/clients"


if [ $# -eq 0 ]
  then
    echo "usage: ./create_root.sh <node ip>"
    exit
fi

echo "creating rootfs at ${ROOT_PATH}/${NODE_IP}..."
cp -axv ${STATIC_IMG} ${ROOT_PATH}/${NODE_IP}
