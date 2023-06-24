#!/usr/bin/env bash
postinst() {
  # Installing kernel upgrade helper script
  install -Dm755 99-vmmodules.install /etc/kernel/install.d/99-vmmodules.install
  # Installing vmware kernel modules
  VMWARE_VERSION=$(cat /etc/vmware/config | grep player.product.version | sed '/.*\"\(.*\)\".*/ s//\1/g')
  [ -z VMWARE_VERSION ] && exit 0
  mkdir -p /tmp/git; cd /tmp/git
  git clone -b workstation-${VMWARE_VERSION} https://github.com/mkubecek/vmware-host-modules.git
  cd vmware-host-modules
  make -j$(nproc)
  make install
  # Loading modules and starting systemd services
  modprobe vmmon vmnet
  systemctl daemon-reload
}

if [ $# -eq 0 ]
  then
    echo "No bundle supplied"
    exit 1
fi

echo "Using bundle $1"
echo "Making $1 executable if not already..."
chmod -v +x $1
if ${1}; then
  postinst
else
  echo "Failed to install VMware Workstation"
  exit 1
fi
