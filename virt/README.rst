================
Salt Virt Module
================

This salt-virt-module is responsible for installing needed Packages for Virtualisation.

client
======

The client.sls installs virt-manager, virsh-bin and virtinst packages

lxc
===

The lxc.sls installs lxc virtualisation.

qemu
====

The qemu.sls installs qemu-dependent packages and sets some proc-variables.

init
====

The init.sls includes client so the client-libraies will be installed.

License
=======

Ths Code is distributed under Apache 2.0 License


.. _`Apache 2.0 license`: http://www.apache.org/licenses/LICENSE-2.0.html