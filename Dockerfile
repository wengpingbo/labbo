FROM ubuntu:22.04

COPY labbo/* /labbo
COPY toolchain /labbo
COPY rootfs /labbo
RUN apt update && apt install -y qemu qemu-utils qemu-user-static binfmt-support vim net-tools ethtool

