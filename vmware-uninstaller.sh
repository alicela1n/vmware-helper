#!/usr/bin/env bash
echo "Uninstalling VMware Workstation..."

echo "Stopping systemd services..."
systemctl disable --now vmware.service vmware-networks-server.service vmware-workstation-server.service

echo "Removing systemd services..."
rm -rfv /etc/systemd/system/vmware.service /etc/systemd/system/vmware-usbarbitrator.service /etc/systemd/system/vmware-networks-server.service /etc/systemd/system/vmware-workstation-server.service

echo "Removing kernel module helper script"
rm -rfv /etc/kernel/install.d/99-vmmodules.install
echo "Running VMware Uninstaller..."
vmware-installer -u vmware-workstation
