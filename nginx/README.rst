=================
Salt Nginx Module
=================

This salt-nginx-module is responsible for Nginx Web-Server installation.

php
===

The php.sls installs additional files for php5 installation. It includes nginx.sls, so nginx is installed to.

server
======

server.sls installs nginx and defines a service for restarting nginx on config-changes

init
====

The init.sls includes server, so base nginx installation is done

License
=======

Ths Code is distributed under Apache 2.0 License

.. _`Apache 2.0 license`: http://www.apache.org/licenses/LICENSE-2.0.html
