#!/bin/bash
set -e

# Create op user
sudo groupadd op
sudo useradd op -s /bin/bash -m -g op

# Install op user ssh keys
comment="op_key"
sudo mkdir -p /home/op/.ssh
sudo touch /home/op/.ssh/authorized_keys

# Allow login using given public key
cat <<EOF | sudo tee /home/op/.ssh/id_rsa.pub | sudo tee -a /home/op/.ssh/authorized_keys
${OP_SSH_PUBLIC_KEY} ${comment}
EOF

# Fix ~/.ssh permissions
sudo chmod 700 /home/op/.ssh
sudo chmod 600 /home/op/.ssh/id_rsa.pub
sudo chown -R op:op /home/op

# Allow passwordless sudo for op user
sudo adduser op sudo
cat <<EOF | sudo tee /etc/sudoers.d/op
op ALL=(ALL) NOPASSWD:ALL
EOF
