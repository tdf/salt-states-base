============
Nginx Module
============

This salt-nginx-module is responsible for Nginx Web-Server installation.

php
---

Includes the nginx server as well as the php5 fpm states.

server
------

Installs the `nginx` package and manages the service with the same name. An e-mail alias from `www-data` to `root` is added.

init
----

The init.sls includes server, so base nginx installation is done
