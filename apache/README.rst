=============
Apache Module
=============

This salt-apache-module is responsible for Apache Web-Server installation.

macro
-----

The macro.sls installs additional apache macro module.

php
---

The php.sls installs additional files for php5 installation. It includes apache.sls, so apache is installed to.

server
------

The server.sls installs the needes apache modules and manages a base set of files to secure the Apache installation.

init
----

The init.sls includes server, so base apache-server installation is done.
