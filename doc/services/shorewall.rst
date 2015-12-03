.. index:: pair: service; shorewall

.. _shorewall_service:

Shorewall
================

Shorewall is a highly flexible firewall. Its configuration can be found in :file:`/etc/shorewall`.



Installation
------------

* to install shorewall::

    sudo apt-get install shorewall

* define the interfaces in :file:`/etc/shorewall/interfaces`::

    net eth0 detect routefilter,tcpflags

* define the zones in :file:`/etc/shorewall/zones`::

    fw firewall
    net ipv4

* define the default policies in :file:`/etc/shorewall/policy`::

    net all DROP
    fw all ACCEPT

* define the rules in :file:`/etc/shorewall/rules`::

    #SECTION ALL
    #SECTION ESTABLISHED
    #SECTION RELATED
    SECTION NEW
    Invalid(DROP)   net             all
    DNS(ACCEPT)     $FW             net
    SSH(ACCEPT)     all             $FW
    Ping(ACCEPT)    net             $FW

* test the configuration::

    shorewall check

* apply the configuration::

    shorewall start


Start
-----

::

  sudo /etc/init.d/shorewall start



Stop
----

::

  sudo /etc/init.d/shorewall stop



Disable
-------

::

  sed -i s/startup=1/startup=0/g /etc/default/shorewall



Enable
------

::

  sed -i s/startup=0/startup=1/g /etc/default/shorewall



Responsible
-----------

Alexander Werner, Robert Einsle
