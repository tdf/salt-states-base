.. index:: pair: service; nginx
.. index:: pair: service; webserver


.. _nginx_service:

Nginx
=====

Nginx is a fast, light and scalable Webserver.



Installation
------------

* to install Nginx::

    sudo apt-get install nginx-full

* Disable the server version display in :file:`/etc/nginx/nginx.conf`:

  .. code-block:: nginx

      http {
           server_tokens off;
      }


Additional security
^^^^^^^^^^^^^^^^^^^

.. note::

  The default settings of nginx are quite secure. This section is considered optional.

.. note::

  The following settings can be written into the *http*-section of :file:`/etc/nginx/nginx.conf` or in *server*-sections in :file:`/etc/nginx/sites-available/*`.


* Restrict access to domain names:

  .. code-block:: nginx

    if ($host !~ ^(first.tld|second.tld|third.tld)$ ) {
      return 444;
    }

* Limit to **GET** and **POST**:

  .. code-block:: nginx

    if ($request_method !~ ^(GET|POST)$ ) {
      return 444;
    }

* Block User-Agents:

  .. code-block:: nginx

    if ($http_user_agent ~* LWP::Simple|BBBike|wget|msnbot|scrapbot) {
            return 403;
     }

* Block Buffer-Overflow-Attacks:

  .. code-block:: nginx

    client_body_buffer_size  1K;
    client_header_buffer_size 1k;
    client_max_body_size 1k;
    large_client_header_buffers 2 1k;

* Block Timeout-Attacks:

  .. code-block:: nginx

    client_body_timeout   10;
    client_header_timeout 10;
    keepalive_timeout     5 5;
    send_timeout          10;

* Limit simultaneous connections:

  .. code-block:: nginx

    limit_zone slimits $binary_remote_addr 5m;
    limit_conn slimits 5;

.. note::

  The following settings must be in a *server*-section in :file:`/etc/nginx/sites-available/`.

* Disable hotlinking:

  .. code-block:: nginx

    location /images/ {
      valid_referers blocked first.allowed.tld second.allowed.tld;
       if ($invalid_referer) {
         return   403;
       }
    }

* Basic authentication:

  .. code-block:: nginx

    auth_basic  "Restricted";
    auth_basic_user_file   /usr/nginx/htpasswd;

* Rewrite HTTP to HTTPS for all virtual hosts in :file:`/etc/nginx/sites-available/default`:

  .. code-block:: nginx

    server {
      listen 80 default_server;
      rewrite ^ https://$host$request_uri? permanent;
    }

* Deny access to hidden files:

  .. code-block:: nginx

    location ~ /\. {
      deny all;
    }

* Deny access to folders:

  .. code-block:: nginx

    location ^~ /dir {
      deny all;
    }


Start
-----

::

  sudo service nginx start



Stop
----

::

  sudo service nginx top



Disable
-------

::

  sudo update-rc.d nginx remove



Enable
------

::

  sudo update-rc.d nginx defaults



Responsible
-----------

Alexander Werner, 
Robert Einsle
