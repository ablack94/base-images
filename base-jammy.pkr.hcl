#
# base-jammy.pkr.hcl
# Golden VM image based on Ubuntu Jammy
# 'base' doesn't really include anything special, it's just a collection of core packages.
# Complex setup shouldn't be done here, subsequent images can build off this.
#

#
# Define the root password
# This is meant for break-glass scenarios and should *not* be
# widely used/distributed.
#
variable "root_password" {
  type = string
  sensitive = true
  default = "root"
}

#
# Defines the public key for the op user
# This is technically not sensitive since it's just the public key, just marking it
# that way since it's pretty long and I don't want it showing up in logs.
#
variable "op_ssh_public_key" {
  type = string
  sensitive = true
}

#
# What base ISO should we use?
#
variable "base_iso_url" {
  type = string
  default = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "base_iso_checksum" {
  type = string
  default = "fe35607e272c86fa96b33f5d441885a5c5d977b81a391ad3391420ea477450a9"
}


source "qemu" "base-jammy" {
  vm_name           = "base-jammy"
  iso_url           = "${var.base_iso_url}"
  iso_checksum      = "${var.base_iso_checksum}"
  output_directory  = "output-base-jammy"
  memory            = 2048
  disk_image        = true
  disk_size         = "10G"
  boot_wait         = "10s"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username      = "ubuntu"
  ssh_password      = "#Ubuntu"
  ssh_timeout       = "1m"
 
  headless = true
  qemuargs = [
    ["-cdrom", "cloud-init.img"],
    ["-serial", "mon:stdio"]
  ]
}

build {
  sources = ["qemu.base-jammy"]

  # Set root password
  provisioner "shell" {
    script = "./scripts/set-root-password.sh"
    environment_vars = [
      "ROOT_PASSWORD=${var.root_password}",
    ]
  }

  # Install baseline packages
  provisioner "shell" {
    script = "./scripts/baseline.sh"
  }

  # Add op user
  provisioner "shell" {
    script = "./scripts/setup-op.sh"
    environment_vars = [
      "OP_SSH_PUBLIC_KEY=${var.op_ssh_public_key}",
    ]
  }

  # Cleanup
  provisioner "shell" {
    script = "./scripts/cleanup.sh"
  }

}

