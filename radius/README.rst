======
Radius
======

These states are responsible for the installation and configuration of the radius client and server.

client
------

The client.sls installs freeradius-client.

server
------

The server.sls installs needed freeradius-server and watches the freeradius-service.

init
----

The init.sls includes client, so if only radius is included, client be installed.
