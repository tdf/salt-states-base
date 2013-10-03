====================
Salt Postgres Module
====================

This salt-postgres-module is responsible for postgres client and server management.

client
------

The client.sls installs postgresql-client.

server
------

The server.sls installs postgresql.

init
----

The init.sls includes client and server, so if only postgres is included, client and server will be installed.

dev
---

The dev.sls installed development packages for postgres
