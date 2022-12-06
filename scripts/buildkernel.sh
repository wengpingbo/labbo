#!/bin/sh

set -e

TDIR=${GITHUB_WORKSPACE}/sources/linux
aarch64-none-linux-gnu-gcc -v
mkdir -pv $TDIR
git clone --depth=1 https://github.com/torvalds/linux.git $TDIR
cat configs/linux_arm64_defconfig >> ${TDIR}/arch/arm64/configs/defconfig
cd $TDIR
make ARCH=arm64 defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- -j

