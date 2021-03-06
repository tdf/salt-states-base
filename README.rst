=================
TDF-Documentation
=================

.. image:: https://travis-ci.org/tdf/salt-states-base.svg?branch=master
    :target: https://travis-ci.org/tdf/salt-states-base

This is the public documentation for the infrastructure of The Document Foundation.

It also servers as a collection of salt states for basic system configuration.
Most of the different states are interdependent, it was therefore decided to host them in one repository.



Using salt-states-base on your infrastructure
---------------------------------------------

- Install and configure your salt-master (see http://docs.saltstack.com) for details.
- Clone this repository::

    cd /srv/salt
    git clone git@github.com:tdf/salt-states-base.git salt-states-base

- Add this location to your `file_roots`, e.g. in :file:`/etc/salt/master.d/paths.conf`:

  .. code-block:: yaml

    file_roots:
      base:
        - /srv/salt/my-states
        - /srv/salt/salt-states-base

TODO
----

- Use travis and docker to test the states per commit
- Primary target platform: Debian 8


Reference
---------

:doc:`Full table of contents </doc/contents>`
    Complete table of contents

:doc:`Developer guide </doc/states/development>`
    Start here if you are interested in contributing to this repository

License
-------

Ths Code is distributed under `Apache 2.0 License`_

.. _`Apache 2.0 license`: http://www.apache.org/licenses/LICENSE-2.0.html
