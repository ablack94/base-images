#!/bin/bash

image="$1"
cloudinit="$2"

if [[ -e "${cloudinit}" ]]; then
  cloudinit="./cloud-init.img"
fi

qemu-system-x86_64  \
  -machine accel=kvm,type=q35 \
  -cpu host \
  -m 2G \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -drive if=virtio,format=qcow2,file="${image}" \
  -drive if=virtio,format=raw,file="${cloudinit}"

