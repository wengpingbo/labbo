# labbo

I just hate to re-build my test box again and again.

## How to use labbo

1. Download docker image and labbo

```
docker pull echowpb/labbo:latest
git clone https://github.com/wengpingbo/labbo.git
```
2. Download linux kernel source code and built it
3. Cd labbo && ./run [host share folder] to enter container
4. In container, run qrunarm/qrunarm64 /path/to/kernel/image
5. In container or host, run gdb-multiarch /path/to/vmlinux
6. Type "target remote :1234" in gdb to connect to your test box
7. Have fun

Check cheat sheet in docker to get details help

## About Linux kernel config

Suggested Linux kernel arm config:

```
cat << EOF >> arch/arm/configs/multi_v7_defconfig
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_9P_FS=y
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
CONFIG_GDB_SCRIPTS=y
EOF
```
Suggested Linux kernel arm64 config:

```
cat << EOF >> arch/arm64/configs/defconfig
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
CONFIG_GDB_SCRIPTS=y
EOF
```
