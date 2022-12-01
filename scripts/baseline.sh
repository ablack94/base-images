#!/bin/bash
set -ex

sudo apt-get update -y

sudo apt-get install -y \
    curl \
    wget \
    git \
    vim \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    libseccomp2 \
    podman

