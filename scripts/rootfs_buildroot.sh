#!/bin/sh

set -e

git clone https://git.buildroot.net/buildroot ${GITHUB_WORKSPACE}/buildroot
cp -v configs/buildroot_aarch64_defconfig ${GITHUB_WORKSPACE}/buildroot/configs/labbo_defconfig
cd ${GITHUB_WORKSPACE}/buildroot
git checkout origin/2022.08.x
make ARCH=arm64 labbo_defconfig
make ARCH=arm64 -j

