
.PHONY: launch-base-jammy clean-base-jammy clean-cloud-init clean

# Nice workaround from
# https://github.com/AGWA/git-crypt/issues/69#issuecomment-263547396
vars_encrypted := $(shell grep -rq "\x0GITCRYPT" base-jammy.pkrvars.hcl && echo "LOCKED" || echo "UNLOCKED")

#
# base
#
base-jammy: cloud-init.img
ifeq ($(vars_encrypted), UNLOCKED)
	packer build -only qemu.base-jammy -var-file base-jammy.pkrvars.hcl base-jammy.pkr.hcl
else
	packer build -only qemu.base-jammy base-jammy.pkr.hcl
endif

launch-base-jammy:
	./launch.sh output-base-jammy/base-jammy cloud-init.img

clean-base-jammy:
	rm -rf ./output-base-jammy

#
# misc
#
cloud-init.img:
	cloud-localds cloud-init.img user-data.yaml

clean-cloud-init:
	rm -f cloud-init.img

clean: clean-base-jammy clean-cloud-init


