#!/bin/bash

BASE_IMG_PATH=$1

if [ $# -eq 0 ]
  then
    echo "usage: ./create_base.sh <path to base image>"
    exit
fi

echo "creating minimal base image at ${BASE_IMG_PATH}..."

yum groups install -y "Minimal Install" --releasever=7 --installroot=${BASE_IMG_PATH}
