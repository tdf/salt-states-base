==================
Salt Apache Module
==================

This salt-apache-module is responsible for Apache Web-Server installation.

server
======

The server.sls installs the needes apache modules and manages a base set of files to secure the Apache installation.

php
===

The php.sls installs additional files for php5 installation. It includes apache.sls, so apache is installed to.

init
====

The init.sls includes server, so base apache-server installation is done.

License
=======

Ths Code is distributed under Apache 2.0 License


.. _`Apache 2.0 license`: http://www.apache.org/licenses/LICENSE-2.0.html
