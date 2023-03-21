FROM ubuntu:20.04

COPY labbo /root/labbo
COPY toolchain /root/labbo/toolchain
COPY android_sdk /root/labbo/android_sdk
RUN /root/labbo/scripts/docker_setup.sh

