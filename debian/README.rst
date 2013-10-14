=============
Debian Module
=============

This salt-debian-module is responsible for debian-specific settings.

sources
-------

The soruces.sls updates sources.list.

init
----

The init.sls includes sources.

backports
---------

Enables backports in :file:`/etc/apt/sources.list.d/backports.list`
