===
Apt
===

.. image:: http://vm170.documentfoundation.org/badge/apt/debian:7

.. image:: http://vm170.documentfoundation.org/badge/apt/ubuntu:12.04

.. image:: http://vm170.documentfoundation.org/badge/apt/ubuntu:14.04

.. image:: http://vm170.documentfoundation.org/badge/apt/centos:6

.. image:: http://vm170.documentfoundation.org/badge/apt/centos:7


These states configure apt, apt-listchanges and apticron.

apt
---

apt.sls installs configuration for timeouts in http and ftp transports in :file:`/etc/apt/apt.conf.d/999user`:

.. literalinclude:: apt_999user
   :language: perl
   :linenos:

apt-listchanges
---------------

Installs the package `apt-listchanges` for notifiing on packages updates and preconfigures the package using the following debconf:

.. literalinclude:: apt-listchanges
   :linenos: 


apticron
--------

Installs and configures apticron to automatically package updates, preconfiguring apticron using the following debconf:

.. literalinclude:: apticron
   :linenos:

In :file:`/etc/apticron/apticron.conf` the setting `LISTCHANGES_PROFILE` is set to `apticron`.

init
----

init.sls includes apt.sls, apt-listchanges and apticron to manage apt-stuff
