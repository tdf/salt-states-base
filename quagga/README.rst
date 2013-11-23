======
Quagga
======

These states are responsible for the installation and configuration of quagga as dynamic routing daemon.

init
----

The init.sls installs needed quagga packages and defines service for starting

zebra
-----

The zebra.sls configures zebra-daemon himself.

bgpd
----

The bgpd.sls creates config-files for bgp-routing-instance

ospfd
-----

The ospfd.sls creares config-files for ospf-routing-instance

ripd
----

The rip.sls creates config-files for rip-routing-instance
