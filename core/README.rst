================
Salt Core Module
================

This salt-core-module is responsible for core package management to install the needed packages.

apticron
========

The apticron.sls installs apticron and configures it to do dayly security-updates of the system.
console
=======

The console.sls changes the installed console-settings to default VGA 

locales
=======

The locales.sls installs german language packs.

packages
========

The packages.sls is to install all needed core-packages on every Machine. This can be called via

.. code-block:: yaml

  base:
    '*':
      - core.packages

The packages to be installed can be found in packages.sls

packages.extra
==============

The packages.extra Module reads a pillar to include extra packages.

The pillar looks like:

.. code-block:: yaml

  packages_extra:
    - <package1>  
    - <package2>
    ...  

sudo
====

The sudo.sls is to install and configure sudo as needed Package. 

timezone
========

The timezone.sls configures timezone to default UTC. If other timezone is needed, a pillar is used.

Layout of the pillar:

.. code-block:: yaml

  timezone: Etc/UTC

init
====

The init.sls includes apticron, console, locales, packages, sudo and timezone, so if only core is included in top.sls, both, packages and sudo will be run.

License
=======

Ths Code is distributed under Apache 2.0 License


.. _`Apache 2.0 license`: http://www.apache.org/licenses/LICENSE-2.0.html
