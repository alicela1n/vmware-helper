#!/usr/bin/env bash
postinst() {
  # Installing and enabling systemd services and kernel upgrade helper script
  install -Dm644 vmware.service /etc/systemd/system/vmware.service
  install -Dm644 vmware-networks-server.service /etc/systemd/system/vmware-networks-server.service
  install -Dm644 vmware-usbarbitrator.service /etc/systemd/system/vmware-usbarbitrator.service
  install -Dm644 vmware-workstation-server.service /etc/systemd/system/vmware-workstation-server.service
  install -Dm644 99-vmmodules.install /etc/kernel/install.d/99-vmmodules.install
  systemctl daemon-reload
  systemctl enable vmware.service vmware-networks-server.service vmware-usbarbitrator.service
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
  systemctl start vmware.service vmware-networks-server.service vmware-usbarbitrator.service
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
