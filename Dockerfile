FROM ubuntu:22.04

COPY labbo /labbo
RUN apt update && apt install -y qemu qemu-utils qemu-user-static binfmt-support vim net-tools ethtool

