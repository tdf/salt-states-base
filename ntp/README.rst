===
Ntp
===

These states are responsible for installing an configuring ntp.

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
