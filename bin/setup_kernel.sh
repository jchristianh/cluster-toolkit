#!/bin/bash

TFTPROOT="/tftpboot"
OSRELEASE=`uname -r`
DRACUT="/usr/sbin/dracut"
DRACUT_OPTIONS="network nfs"

printf "cleaning up old boot images ..."

#echo "removing old kernel/initrd links..."
rm -f ${TFTPROOT}/initrd.img
rm -f ${TFTPROOT}/vmlinuz

printf "done!\n"

printf "building initrd ..."

#echo "building initrd..."
${DRACUT} --force --add "${DRACUT_OPTIONS}" ${TFTPROOT}/initrd-${OSRELEASE}-netboot.img ${OSRELEASE}

#echo "setting perms on initrd..."
chmod 644 ${TFTPROOT}/initrd-${OSRELEASE}-netboot.img

#echo "linking initrd image to ${TFTPROOT}/initrd.img..."
#ln -sf ${TFTPROOT}/initrd-${OSRELEASE}-netboot.img ${TFTPROOT}/initrd.img
cp -a ${TFTPROOT}/initrd-${OSRELEASE}-netboot.img ${TFTPROOT}/initrd.img

printf "done!\n"

printf "copying kernel ${OSRELEASE} in place ..."

#echo "copying kernel for ${OSRELEASE} in place..."
cp -a /boot/vmlinuz-`uname -r` ${TFTPROOT}

#echo "setting perms on kernel..."
chmod 755 ${TFTPROOT}/vmlinuz-`uname -r`

#echo "linking vmlinuz-`uname -r` to vmlinuz..."
#ln -sf ${TFTPROOT}/vmlinuz-`uname -r` ${TFTPROOT}/vmlinuz
cp -a ${TFTPROOT}/vmlinuz-`uname -r` ${TFTPROOT}/vmlinuz

printf "done!\n"
