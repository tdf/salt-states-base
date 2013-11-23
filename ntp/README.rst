==========
Ntp Module
==========

This salt-ntp-module is responsible for installing and configuring ntp.

conf
----

Manages the file :file:`/etc/ntp.conf`:

.. literalinclude:: ntp.conf
   :linenos:

pkg
---

Installs the package `ntp` and manages the service with the same name.

init
----

Includes conf and pkg.
