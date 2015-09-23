=======
Console
=======

.. image:: http://vm170.documentfoundation.org/badge/console/debian:7

.. image:: http://vm170.documentfoundation.org/badge/console/ubuntu:12.04

.. image:: http://vm170.documentfoundation.org/badge/console/ubuntu:14.04

.. image:: http://vm170.documentfoundation.org/badge/console/debian:8

.. image:: http://vm170.documentfoundation.org/badge/console/centos:7

These states manage console-settings.

init
----

The init.sls includes other platform-specific sls.

debian
------

debian.sls manages console-settings, includes console-setup to set up console and configures it using the following debconf:

.. literalinclude:: console-setup
   :linenos:
