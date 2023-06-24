# vmware-helper
Helper for VMware on Linux

# nonsystemd vs systemd
If you want to use the traditional init scripts, either on a systemd without systemd or on a system with
systemd with sysvinit backwards compatibility use the `nosystemd` script. Otherwise use the `systemd` script.

# How to use
You need a VMware bundle, then you run the script as root, for example:

```
$ sudo ./vmware-installer-{systemd, nosystemd}.sh VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle
```
Uninstalling is done using:
```
$ sudo ./vmware-uninstaller.sh
```
