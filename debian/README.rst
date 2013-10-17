=============
Debian Module
=============

This salt-debian-module is responsible for debian-specific settings.

backports
---------

Enables backports in :file:`/etc/apt/sources.list.d/backports.list`

debconf
-------

debconf installes debconf-utils for debconf-setups

sources
-------

The soruces.sls updates sources.list.

init
----

The init.sls includes sources.
