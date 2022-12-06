#!/bin/sh

KERNEL_IMG="$1"
ROOTFS="$2"
HOSTDIR="$3"

qemu-system-aarch64 -machine virt -cpu cortex-a57 -smp 4 -m 2g -kernel ${KERNEL_IMG} -hda ${ROOTFS} -append "root=/dev/vda rw console=ttyAMA0" -netdev user,id=ens33,hostfwd=tcp::8765-:22 -device e1000,netdev=ens33 -nographic -virtfs local,path=${HOSTDIR},mount_tag=host0,id=host0,security_model=passthrough
