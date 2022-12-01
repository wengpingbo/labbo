#!/bin/sh

set -e

git clone https://github.com/torvalds/linux.git ${GITHUB_WORKSPACE}
cat configs/linux_kernel_defconfig >> ${GITHUB_WORKSPACE}/linux/arch/arm64/configs/defconfig
cd ${GITHUB_WORKSPACE}/linux
make ARCH=arm64 defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- -j

