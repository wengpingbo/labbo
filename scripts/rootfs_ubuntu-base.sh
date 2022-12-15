#!/bin/sh

set -e

ROOTDIR="$1"
ARCH="$2"
mkdir -pv ${ROOTDIR}/ubuntu/mnt
cd ${ROOTDIR}/ubuntu
TDIR=${ROOTDIR}/ubuntu/mnt

qemu-img create -f qcow2 ubuntu-base-${ARCH}.img 10G
modprobe nbd max_part=8
qemu-nbd --connect=/dev/nbd0 ubuntu-base-${ARCH}.img
mkfs.ext4 /dev/nbd0
mount /dev/nbd0 ${TDIR}

if [ "$ARCH" = "arm64" ]; then
	curl -L https://cdimage.ubuntu.com/ubuntu-base/releases/20.04.5/release/ubuntu-base-20.04.5-base-arm64.tar.gz -o ubuntu-base.tar.gz
elif [ "$ARCH" = "arm" ]; then
	curl -L https://cdimage.ubuntu.com/ubuntu-base/releases/20.04.5/release/ubuntu-base-20.04.5-base-armhf.tar.gz -o ubuntu-base.tar.gz
fi
tar xf ubuntu-base.tar.gz -C ${TDIR}

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
apt install -y ssh sudo ifupdown net-tools ethtool systemd vim cron

# add system user
useradd -s '/bin/bash' -m -G adm,sudo ubuntu
echo ubuntu:ubuntu | chpasswd
echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# fix "Timed out waiting for device ttyAMA0" errors
ln -sv /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttyAMA0.service

# fix 'agetty --noclear' not work
sed -i 's/TTYVTDisallocate=yes/TTYVTDisallocate=no/' /lib/systemd/system/getty@.service

# setup autologin
sed -i "s/agetty -o '-p/agetty -a ubuntu -o '-f -p/" /lib/systemd/system/getty@.service

# setup network
echo auto eth0 > /etc/network/interfaces.d/eth0
echo iface eth0 inet dhcp >> /etc/network/interfaces.d/eth0

# setup hostname
echo labbo-$ARCH > /etc/hostname
echo 127.0.0.1 localhost >> /etc/hosts
echo 127.0.1.1 labbo-$ARCH >> /etc/hosts

# auto mount host share directory
echo "host0   /share    9p      trans=virtio,msize=512k,multidevs=remap   0 0" >> /etc/fstab
echo "@reboot chmod 777 /share" >> /etc/crontab

# custom welcome message
cat << MEND > /etc/motd

===============================================================

Enter labbo-$ARCH system, default username/password: ubuntu/ubuntu

===============================================================

MEND
sync
exit
EOF

mount --make-private ${TDIR}
umount -R ${TDIR}
qemu-nbd --disconnect /dev/nbd0

mkdir -pv ${ROOTDIR}/rootfs
mv ${ROOTDIR}/ubuntu/ubuntu-base-${ARCH}.img ${ROOTDIR}/rootfs
rm -rf ${ROOTDIR}/ubuntu

