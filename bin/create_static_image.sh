#!/bin/bash

STATIC_IMG="/opt/cluster/STATIC_IMAGE/CENTOS7"

printf "purging existing static image ..."
rm -rf ${STATIC_IMG}/*
printf "done!\n";

echo "creating minimal base image at ${STATIC_IMG}..."

yum groups install -y "Minimal Install" --releasever=7 --installroot=${STATIC_IMG}
#yum groups install -y "Compute Node" --releasever=7 --installroot=${STATIC_IMG}
