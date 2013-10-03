==========
Ntp Module
==========

This salt-ntp-module is responsible for installing and configuring ntp.

conf
----

conf.sls manages the configuration of ntp-daemon

pkg
---

installs ntp and defines service for ntp to let ntp restart on config-changes

init
----

The init.sls pkg and conf.
