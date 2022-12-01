#!/bin/sh

set -e

git clone https://git.buildroot.net/buildroot ${GITHUB_WORKSPACE}
git checkout origin/2022.08.x
cp -v configs/buildroot_aarch64_defconfig ${GITHUB_WORKSPACE}/buildroot/configs/labbo_defconfig
cd ${GITHUB_WORKSPACE}/buildroot
make ARCH=arm64 labbo_defconfig
make ARCH=arm64 -j

