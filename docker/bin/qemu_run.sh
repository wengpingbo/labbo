#!/bin/sh

KERNEL_IMG="$1"
ROOTFS="/root/labbo/rootfs/ubuntu-base.img"
HOSTDIR="$2"

NETDEV=lo

# find active network interface
iflist=`ifconfig -s | awk '{print $1}' | tr '\n' ' ' | sed 's/Iface //'`
for interf in $iflist; do
	ping -q -c1 -n -W 1 -I $interf baidu.com > /dev/null
	[ $? -eq 0 ] && NETDEV=$interf && break
done

qemu-system-aarch64 -machine virt -cpu cortex-a57 -smp 4 -m 2g -kernel ${KERNEL_IMG} -hda ${ROOTFS} -append "root=/dev/vda rw console=ttyAMA0" -netdev user,id=${NETDEV},hostfwd=tcp::8765-:22 -device e1000,netdev=${NETDEV} -nographic -virtfs local,path=${HOSTDIR},mount_tag=host0,id=host0,security_model=passthrough
