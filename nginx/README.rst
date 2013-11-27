=====
Nginx
=====

States to install and configure the fast and light webserver Nginx.

php
---

Includes the nginx server as well as the php5 fpm states.

server
------

Installs the `nginx` package and manages the service with the same name. An e-mail alias from `www-data` to `root` is added.

hash_size
---------

Adds the file :file:`/etc/nginx/conf.d/hash_size.conf` to increase the server names hash size:

.. literalinclude:: hash_size.conf
   :language: nginx
   :linenos:

init
----

The init.sls includes server, so base nginx installation is done
