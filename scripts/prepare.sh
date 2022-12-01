#!/bin/sh

set -e

echo "install dependencies"
sudo apt update
sudo apt install -y make gcc g++ git bc

echo "download toolchain"
mkdir -pv ${GITHUB_WORKSPACE}/toolchain
curl -L https://developer.arm.com/-/media/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -o ${GITHUB_WORKSPACE}/toolchain/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz

cd ${GITHUB_WORKSPACE}/toolchain
tar xf arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
echo "${GITHUB_WORKSPACE}/toolchain/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu/bin" >> ${GITHUB_PATH}

