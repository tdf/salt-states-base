==================
Salt Radius Module
==================

This salt-radius-module is responsible for radius client and server management.

client
======

The client.sls installs freeradius-client.

server
======

The server.sls installs needed freeradius-server and watches the freeradius-service.

init
====

The init.sls includes client, so if only radius is included, client be installed.

License
=======

Ths Code is distributed under Apache 2.0 License

.. _`Apache 2.0 license`: http://www.apache.org/licenses/LICENSE-2.0.html
