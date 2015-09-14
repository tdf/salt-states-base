=====
Nginx
=====

.. image:: http://vm170.documentfoundation.org/badge/nginx/debian:7

.. image:: http://vm170.documentfoundation.org/badge/nginx/ubuntu:12.04

.. image:: http://vm170.documentfoundation.org/badge/nginx/ubuntu:14.04

.. image:: http://vm170.documentfoundation.org/badge/nginx/centos:6

.. image:: http://vm170.documentfoundation.org/badge/nginx/centos:7

States to install and configure the fast and light webserver Nginx.


Available states
----------------

certs
^^^^^

Installs include-files for ssl-certificates as defined in `nginx:certs` pillar. An example looks like this:

.. code-block:: yaml

    nginx:
      certs:
        <cert-name>:
          crt: /etc/ssl/certs/site.chained.crt
          key: /etc/ssl/private/site.key
          ocsp: /etc/ssl/certs/site.ocsp.resp

The certificate must be chained with intermediary certificats of the CA, but without the root certificate::

    cat site.crt sub.crt > site.chained.crt

Starting with nginx 1.3.7+, OCSP-stapling is available. To enable it, you have to create the stapling file as such::

    ISSUER_CER=<root.crt>
    SERVER_CER=<cert-name.crt>
    URL=$(openssl x509 -in $SERVER_CER -text | grep "OCSP - URI:" | cut -d: -f2,3)
    openssl ocsp -noverify -no_nonce -respout ocsp.resp -issuer $ISSUER_CER -cert $SERVER_CER -url $URL


dhparams
^^^^^^^^

Adds the `ssl_dhparam` parameter to the :file:`includes/ssl`

hash_size
^^^^^^^^^

Adds the file :file:`/etc/nginx/conf.d/hash_size.conf` to increase the server names hash size:

.. literalinclude:: hash_size.conf
   :language: nginx
   :linenos:

init
^^^^

The init.sls includes server, so base nginx installation is done

php
^^^

Includes the nginx server as well as the php5 fpm states.

server
^^^^^^

Installs the `nginx` package and manages the service with the same name. An e-mail alias from `www-data` to `root` is added.



Additional files
----------------

includes/ssl
^^^^^^^^^^^^

The file :file:`/etc/nginx/includes/ssl` is created and provides sane defaults for ssl including PFS:

.. literalinclude:: includes/ssl
    :language: nginx
    :linenos:


Use it as such in an nginx server-block:

.. code-block:: nginx

    include ssl;
