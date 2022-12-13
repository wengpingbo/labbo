FROM ubuntu:22.04

COPY labbo /root/labbo
RUN apt update && apt install -y qemu qemu-utils qemu-user-static binfmt-support && \
    apt install -y vim net-tools ethtool ssh git wget curl iputils-ping && \
    apt install -y qemu-system-aarch64 qemu-system-arm && \
    sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc && \
    echo "source /root/labbo/docker/docker_bashrc" >> /root/.bashrc && \
    cp /root/labbo/docker/gitconfig /root/.gitconfig

