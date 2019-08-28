#!/bin/bash

yum clean all
rm -vf /var/lib/rpm/__db*
rpm --rebuilddb
yum clean all
yum update
