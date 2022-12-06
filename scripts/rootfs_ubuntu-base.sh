#!/bin/sh

set -e

ROOTDIR="$1"
mkdir -pv ${ROOTDIR}/ubuntu/mnt
cd ${ROOTDIR}/ubuntu
TDIR=${ROOTDIR}/ubuntu/mnt

curl -L https://cdimage.ubuntu.com/ubuntu-base/releases/22.04.1/release/ubuntu-base-22.04.1-base-arm64.tar.gz -o ubuntu-base-22.04.1-base-arm64.tar.gz
qemu-img create -f raw ubuntu-base.img 10G
mkfs.ext4 ubuntu-base.img
mount ubuntu-base.img ${TDIR}
tar xf ubuntu-base-22.04.1-base-arm64.tar.gz -C ${TDIR}

# setup dns
cat << EOF | chroot ${TDIR}
echo nameserver 114.114.114.114 >> /etc/resolv.conf
exit
EOF

# prepare chroot
mount -t sysfs none ${TDIR}/sys
mount -t proc none ${TDIR}/proc
mount --bind /dev ${TDIR}/dev
mount --bind /dev/pts ${TDIR}/dev/pts
mount -o bind /etc/resolv.conf ${TDIR}/etc/resolv.conf
cat << EOF | chroot ${TDIR}
apt update
apt install -y ssh sudo ifupdown net-tools ethtool systemd vim

# add system user
useradd -s '/bin/bash' -m -G adm,sudo ubuntu
echo ubuntu | passwd --stdin ubuntu

# fix "Timed out waiting for device ttyAMA0" errors
ln -s /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttyAMA0.service

# fix 'agetty --noclear' not work
sed -i 's/TTYVTDisallocate=yes/TTYVTDisallocate=no/' /lib/systemd/system/getty@.service

# setup autologin
sed -i "s/agetty -o '-p/agetty -a ubuntu -o '-f -p/" /lib/systemd/system/getty@.service

# setup network
echo auto eth0 > /etc/network/interfaces.d/eth0
echo iface eth0 inet dhcp >> /etc/network/interfaces.d/eth0

# setup hostname
echo labbo > /etc/hostname
echo 127.0.0.1 localhost >> /etc/hosts
echo 127.0.1.1 labbo >> /etc/hosts

# auto mount host share directory
echo "host0   /share    9p      trans=virtio,version=9p2000.L   0 0" >> /etc/fstab

# custom welcome message
cat << MEND > /etc/motd

===============================================================

Enter labbo system, default username/password: ubuntu/ubuntu

===============================================================

MEND
exit
EOF

mount --make-private ${TDIR}
umount -R ${TDIR}

mkdir -pv ${ROOTDIR}/rootfs
mv ${ROOTDIR}/ubuntu/ubuntu-base.img ${ROOTDIR}/rootfs
rm -rf ${ROOTDIR}/ubuntu

