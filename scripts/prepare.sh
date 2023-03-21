#!/bin/sh

set -e

ROOTDIR="$1"

echo "install dependencies"
sudo apt update
sudo apt install -y make gcc g++ git bc qemu-utils default-jre

echo "download toolchain"
mkdir -pv ${ROOTDIR}/toolchain
curl -L https://developer.arm.com/-/media/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -o ${ROOTDIR}/toolchain/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
curl -L https://developer.arm.com/-/media/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz -o ${ROOTDIR}/toolchain/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz

cd ${ROOTDIR}/toolchain
tar xf arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
rm arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
tar xf arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz
rm arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz

echo "download android avd"
mkdir -pv ${ROOTDIR}/android_sdk/cmdline-tools
curl -L https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o ${ROOTDIR}/android_sdk/commandlinetools-linux-9477386_latest.zip

cd ${ROOTDIR}/android_sdk/cmdline-tools
unzip ../commandlinetools-linux-9477386_latest.zip
mv cmdline-tools latest
cd ${ROOTDIR}/android_sdk
rm commandlinetools-linux-9477386_latest.zip
#echo y | ./cmdline-tools/latest/bin/sdkmanager --install "system-images;android-33;google_apis;x86_64"
echo y | ./cmdline-tools/latest/bin/sdkmanager --install "platforms;android-33"
echo y | ./cmdline-tools/latest/bin/sdkmanager --install "platform-tools"

