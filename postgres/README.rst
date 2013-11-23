========
Postgres
========

These states are responsible for the installation and configuration of postgresql server and client.

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
