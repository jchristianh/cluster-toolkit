#!/bin/bash

STATIC_IMG="/opt/cluster/STATIC_IMAGE/CENTOS7_64"

echo "creating minimal base image at ${STATIC_IMG}..."

yum groups install -y "Minimal Install" --releasever=7 --installroot=${STATIC_IMG}
