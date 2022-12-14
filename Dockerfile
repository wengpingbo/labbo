FROM ubuntu:20.04

COPY labbo /root/labbo
COPY toolchain /root/labbo
RUN apt update && apt install -y qemu qemu-utils qemu-user-static binfmt-support && \
    apt install -y vim net-tools ethtool ssh git wget curl telnet iputils-ping && \
    apt install -y qemu-system-aarch64 qemu-system-arm && \
    ln -sv /usr/lib/x86_64-linux-gnu/libncursesw.so.6.2 /usr/lib/x86_64-linux-gnu/libncursesw.so.5 && \
    ln -sv /usr/lib/x86_64-linux-gnu/libncurses.so.6.2 /usr/lib/x86_64-linux-gnu/libncurses.so.5 && \
    ln -sv /usr/lib/x86_64-linux-gnu/libtinfo.so.6.2 /usr/lib/x86_64-linux-gnu/libtinfo.so.5 && \
    mkdir -pv /root/.config/gdb && \
    echo "set auto-load safe-path /" > /root/.config/gdb/gdbinit && \
    sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc && \
    echo "source /root/labbo/docker/docker_bashrc" >> /root/.bashrc && \
    git clone https://github.com/wengpingbo/ilinux.git /tmp/ilinux && \
    /tmp/ilinux/setup.sh && rm -rf /tmp/ilinux

