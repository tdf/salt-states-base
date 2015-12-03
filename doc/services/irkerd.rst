
.. index:: pair: service; irked

.. _irkerd_service:

irkerd
======

Relay for shipping notification to IRC servers

Installation
------------

* clone git://gitorious.org/irker/irker.git

* create a group ciabot

* create a 'service' user ciabot

* copy irkerd to /usr/bin/.

* install an upstart config irkerd.conf in /etc/init/.::

        # irkerd - Relay for shipping notification to IRC servers
        #

        description   "Relay for shipping notification to IRC server"

        start on filesystem or runlevel [2345]
        stop on runlevel [!2345]

        console log
        setuid ciabot
        setgid ciabot

        pre-start script
        test -x /usr/bin/irkerd || { stop; exit 0; }
        end script

        exec /usr/bin/irkerd -n loircbot

Responsible
-----------

Thiebaud, Norbert <nthiebaud@gmail.com>

