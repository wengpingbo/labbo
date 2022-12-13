FROM ubuntu:22.04

COPY labbo /root/labbo
RUN apt update && apt install -y qemu qemu-utils qemu-user-static binfmt-support && \
    apt install -y vim net-tools ethtool ssh git wget curl iputils-ping && \
    apt install -y qemu-system-aarch64 qemu-system-arm && \
    sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc && \
    git clone https://github.com/wengpingbo/ilinux.git /tmp/ilinux && \
    /tmp/ilinux/setup.sh && rm -rf /tmp/ilinux

