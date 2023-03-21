#!/bin/sh

set -ex

# package install
apt update && apt install -y qemu qemu-utils qemu-user-static binfmt-support
apt install -y vim net-tools ethtool ssh git wget curl telnet iputils-ping default-jre
apt install -y gdb-multiarch gcc g++
apt install -y qemu-system-aarch64 qemu-system-arm

# fix gdb errors
ln -sv /usr/lib/x86_64-linux-gnu/libncursesw.so.6.2 /usr/lib/x86_64-linux-gnu/libncursesw.so.5
ln -sv /usr/lib/x86_64-linux-gnu/libncurses.so.6.2 /usr/lib/x86_64-linux-gnu/libncurses.so.5
ln -sv /usr/lib/x86_64-linux-gnu/libtinfo.so.6.2 /usr/lib/x86_64-linux-gnu/libtinfo.so.5
mkdir -pv /root/.config/gdb
echo "set auto-load safe-path /" > /root/.config/gdb/gdbinit
echo "set auto-load safe-path /" > /root/.gdbinit

# bash setup
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
echo "source /root/labbo/docker/docker_bashrc" >> /root/.bashrc
git clone https://github.com/wengpingbo/ilinux.git /tmp/ilinux
/tmp/ilinux/setup.sh && rm -rf /tmp/ilinux

# android avd setup
#cd /root/labbo/android_sdk
#avdmanager -v create avd --force --name "android33" --package "system-images;android-33;google_apis;x86_64" --abi "x86_64" --device "pixel_5"

