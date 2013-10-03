===================
Salt Rsyslog Module
===================

This salt-module manages rsyslog for remote logging.

rsyslog
-------

The rsyslog.sls installs rsyslog and manages rsyslog service

tcp-client
----------

Includes rsyslog for installing and managing rsyslog service.

Configures rsyslog as tcp-client to send rsyslog events to an rsyslog-servers.

Rsyslog-server definition is done by an Pillar:

.. code-block:: yaml

	rsyslog-tcp-server: 10.0.0.1  # defaults to loghost
	rsyslog-tcp-port: 514         # defaults to 514


tcp-server
----------

Includes rsyslog for installing and managing rsyslog service.

Configures rsyslog as tcp-server to make posibility to recieve rsyslog-events via tcp.

.. code-block:: yaml

	rsyslog-tcp-port: 514         # defaults to 514

udp-client
----------

Includes rsyslog for installing and managing rsyslog service.

Configures rsyslog as udp-client to send rsyslog events to an rsyslog-servers.

Rsyslog-server definition is done by an Pillar:

.. code-block:: yaml

	rsyslog-udp-server: 10.0.0.1  # defaults to loghost
	rsyslog-udp-port: 514         # defaults to 514


udp-server
----------

Includes rsyslog for installing and managing rsyslog service.

Configures rsyslog as udp-server to make posibility to recieve rsyslog-events via udp.

.. code-block:: yaml

	rsyslog-udp-port: 514         # defaults to 514
