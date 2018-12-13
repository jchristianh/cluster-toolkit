#!/bin/bash

STATIC_IMG="/opt/cluster/STATIC_IMAGE/CENTOS7_64"

rm -rfv ${STATIC_IMG}/var/cache/yum/*
rm -fv ${STATIC_IMG}/etc/sysconfig/selinux
rm -fv ${STATIC_IMG}/etc/localtime
rm -rfv ${STATIC_IMG}/boot/*
