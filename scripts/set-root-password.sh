#!/bin/bash
set -ex

if [[ -e "${ROOT_PASSWORD}" ]]; then
    echo "Missing environment variable ROOT_PASSWORD">&2
    exit 1
fi

echo "Setting root password to '${ROOT_PASSWORD}'"
echo "root:${ROOT_PASSWORD}" | sudo chpasswd
