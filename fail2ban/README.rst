========
fail2ban
========

.. image:: http://vm170.documentfoundation.org/badge/fail2ban/debian:7

.. image:: http://vm170.documentfoundation.org/badge/fail2ban/ubuntu:12.04

.. image:: http://vm170.documentfoundation.org/badge/fail2ban/ubuntu:14.04

.. image:: http://vm170.documentfoundation.org/badge/fail2ban/centos:6

.. image:: http://vm170.documentfoundation.org/badge/fail2ban/centos:7

These states install an configure fail2ban.

init
----

Installs the `fail2ban` package and manages the service with the same name.

The local configuration :file:`/etc/fail2ban/jail.local` is created:

.. literalinclude:: jail.local
   :language: ini
   :linenos:
