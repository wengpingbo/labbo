#!/bin/sh

IMG="$1"
TDIR="$2"

mount $IMG $TDIR
mount -t sysfs none ${TDIR}/sys
mount -t proc none ${TDIR}/proc
mount --bind /dev/ ${TDIR}/dev
mount --bind /dev/pts ${TDIR}/dev/pts
mount -o bind /etc/resolv.conf ${TDIR}/etc/resolv.conf
chroot $TDIR

mount --make-private $TDIR
umount -R $TDIR

