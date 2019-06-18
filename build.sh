#!/bin/bash

set -e

FAHCLIENT_URL=${1:-https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.5/fahclient_7.5.1_amd64.deb}
IMAGE=foldingathome
TAG=$(echo $FAHCLIENT_URL | sed -r 's/.*\/v([0-9]\.[0-9])\/.*/\1/')

[ -z "$TAG" ] && {
  TAG='latest'
}

docker build -t $IMAGE:$TAG - << EOF
FROM nvidia/cuda:latest
# OpenCL: https://gitlab.com/nvidia/opencl/blob/ubuntu16.04/runtime/Dockerfile
RUN apt update && apt upgrade -y && apt install -y rsync ocl-icd-libopencl1 clinfo wget
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
RUN wget $FAHCLIENT_URL -O /tmp/faclient.deb
RUN dpkg-deb -x /tmp/faclient.deb /tmp/foo
RUN rsync -a /tmp/foo/ /
RUN rm -rf /tmp/*
RUN mkdir /$IMAGE
WORKDIR /$IMAGE
ENTRYPOINT ["/usr/bin/FAHClient"]
EOF
