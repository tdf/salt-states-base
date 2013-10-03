================
Salt Virt Module
================

This salt-virt-module is responsible for installing needed Packages for Virtualisation.

client
------

The client.sls installs virt-manager, virsh-bin and virtinst packages

lxc
---

The lxc.sls installs lxc virtualisation.

qemu
----

The qemu.sls installs qemu-dependent packages and sets some proc-variables.

init
----

The init.sls includes client so the client-libraies will be installed.
