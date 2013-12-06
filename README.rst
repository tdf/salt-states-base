================
salt-states-base
================

Collection of salt states for basic system configuration


Getting started
---------------

- Install and configure your salt-master (see http://docs.saltstack.com) for details.
- Clone this repository::

    cd /srv/salt
    git clone git@github.com:tdf/salt-states-base.git salt-states-base

- Add this location to your `file_roots`, e.g. in :file:`/etc/salt/master.d/paths`:

  .. code-block:: yaml

    file_roots:
      base:
        - /srv/salt/my-states
        - /srv/salt/salt-states-base

- Clone the needed `salt-pillar-base` repository::

    cd /srv/pillar
    git clone git@github.com:tdf/salt-pillar-base.git salt-pillar-base

- Add this location to your `pillar_roots`, e.g. in :file:`/etc/salt/master.d/paths`:

  .. code-block:: yaml

    pillar_roots:
      base:
        - /srv/pillar/my-pillar
        - /srv/pillar/salt-pillar-base


TODO
----

- automated testing using docker on github push

- supported Platforms: i386, x64, debian wheezy, debian squeeze, ubuntu 12.04 lts, ubuntu 14.04 lts, centos 6.x

- api stability once basics are implemented

- create howto to write new modules

- best practices


Reference
---------

.. toctree::
   :maxdepth: 2
   :glob:

   */*

License
-------

Ths Code is distributed under `Apache 2.0 License`_

.. _`Apache 2.0 license`: http://www.apache.org/licenses/LICENSE-2.0.html
