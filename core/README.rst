================
Salt Core Module
================

This salt-core-module is responsible for core package management to install the needed packages.

console
=======

The console.sls changes the installed console-settings to default VGA 

debconf
=======

debconf.sls installs debconf-utils for salt-module to configure debian-stuff

profile
=======

profile.sls installs user-profile settings

timezone
========

The timezone.sls configures timezone to default UTC. If other timezone is needed, a pillar is used.

Layout of the pillar:

.. code-block:: yaml

  timezone: Etc/UTC

unattended-upgrades
===================

unattendes-upgrades.sls installs and configures package for unattended upgrades

init
====

The init.sls includes console, debconf, profile, timezone and unattended-upgrades.

License
=======

Ths Code is distributed under Apache 2.0 License

.. _`Apache 2.0 license`: http://www.apache.org/licenses/LICENSE-2.0.html
