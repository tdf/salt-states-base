===================
Salt Package Module
===================

This salt-package-module is installs defined packages.

drbd
----

drbd.sls installs needed packages for a drbd managed volume

extra
-----

extra.sls installs packages defines in pillar.data

The pillar-data should looks like:

.. code-block:: yaml

  packages_extra:
    - package1
    - package2
    - ...

git
---

git.sls installs packages for git version-control-system

lxc
---

lxc.sls installs needed packages for a lxc container-host

net
---

net.sls installs core networking packages

pacemaker
---------

pacemaker installs needed packages for pacemaker

init
----

The init.sls includes git and net and installs additions packages
