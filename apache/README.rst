======
Apache
======

.. image:: http://vm170.documentfoundation.org/badge/apache/debian:7
	   
.. image:: http://vm170.documentfoundation.org/badge/apache/ubuntu:12.04

.. image:: http://vm170.documentfoundation.org/badge/apache/ubuntu:14.04

.. image:: http://vm170.documentfoundation.org/badge/apache/centos:6

.. image:: http://vm170.documentfoundation.org/badge/apache/centos:7

These states install and configure the webserver of the Apache project.

macro
-----

The macro.sls installs additional apache macro module.

The `libapache2-mod-macro` package is installed and enabled.

The file :file:`/etc/apache2/conf.d/TEMPLATE.VHost` is created:

.. literalinclude:: TEMPLATE.VHost
   :language: apache
   :linenos:

php
---

The php.sls installs additional files for php5 installation. It includes apache.sls, so apache is installed to.

server
------

The server.sls installs the needes apache modules and manages a base set of files to secure the Apache installation.

The apache package is intalled and the apache service is managed. An e-mail alias from www-data to root is created.

The file :file:`localized-error-pages` is created:

.. literalinclude:: localized-error-pages
   :language: apache
   :linenos:

The file :file:`/var/www/index.html` is removed.

The directory :file:`/srv/www` is created.

The apache modules include, proxy_http, rewrite, ssl and expires are enabled.

In :file:`/etc/apache2/conf.d/security` the following settings are changed:

- `ServerTokens` is set to `Prod`
- `ServerSignature` is set to `Off`

Indexing is disabled for `mod_alias` in :file:`/etc/apache2/mods-available/alias.conf`

The file :file:`/etc/apache2/conf.d/z99-user` is created:

.. literalinclude:: z99-user
   :language: apache
   :linenos:



init
----

The init.sls includes server, so base apache-server installation is done.
