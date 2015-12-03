.. index:: pair: service; salt
.. index:: url; floyd.libreoffice.org

.. _salt_service:

Salt
====

Salt is a configuration management system that uses easy to understand yaml-syntax and jinja-Templates.



Installation
------------

Client
^^^^^^

::

  wget -O - http://bootstrap.saltstack.org | sudo sh

oder::

  curl -L https://bootstrap.saltstack.com | sudo sh


.. note::

  avamis rules need machine_id grain - that is read from
  :file:`/etc/machine-id` or if that doesn't exist from
  :file:`/var/lib/dbus/machine-id`
  
  Either install systemd-machine-id-setup (for systemd based distros) or
  dbus-uuidgen (package dbus on ubuntu) to have it generated.


Master
^^^^^^


::

  wget -O - http://bootstrap.saltstack.org | sudo sh -s -- -M

.. note::

  If wget seems to stop, there is a possible sudo error. Try pressing ENTER.

.. note::

  Due to strange behaviour of apt starting with 12.10, an old version of salt may be installed.
  You can check the version of salt with ``salt-minion --version`` and compare this version with that installed on the master.
  To update to the desired stable version, issue the following commands::

    sudo apt-get install -y software-properties-common python-software-properties
    sudo add-apt-repository -y ppa:saltstack/salt
    sudo apt-get update && sudo apt-get upgrade


Configuration of Master
-----------------------

* Salt by default is too verbose, decrease it a little bit::

    echo "state_verbose: False" > /etc/salt/master.d/9999user.conf

* Setup configuration root directories::

    cat >> /etc/salt/master.d/9999user.conf << EOF
    file_roots:
      base:
        - /srv/salt/tdf
        - /srv/salt/base
    EOF

* Setup metadata root directories::

    cat >> /etc/salt/master.d/9999user.conf << EOF
    pillar_roots:
      base:
        - /srv/pillar/tdf
        - /srv/pillar/base
    EOF

* Clone the configuration repositories as normal user (don't forget to user ``ssh -A`` to forward your local key)::

    sudo mkdir /srv/salt /srv/pillar
    sudo chown :users /srv/salt /srv/pillar
    sudo chmod g+rwxs /srv/salt /srv/pillar
    git clone git@pumbaa.documentfoundation.org:salt/salt /srv/salt
    git clone git@pumbaa.documentfoundation.org:salt/pillar /srv/pillar
    cd /srv/salt; git config core.sharedRepository group
    cd /srv/pillar; git config core.sharedRepository group

* Restart the master::

    /etc/init.d/salt-master restart

* Setup ufw::

    ufw allow in 4505
    ufw allow in 4506/tcp


Adding a Minion
-----------------------

* Set master in :file:`/etc/salt/minion.d/9999user.conf`::

    echo "master: ####master.fqdn####" > /etc/salt/minion.d/9999user.conf

.. note::

  For version 0.17 and 0.17.1 of the salt minion, the FQDN is not reported correctly on Debian-based systems.
  Please issue this command additionally::

    echo "id: ####minion.fqdn####" >> /etc/salt/minion.d/9999user.conf

* Restart the minion::

    /etc/init.d/salt-minion restart

* On the master, accept the key of the minion::

    salt-key -a ####minion.fqdn####

* Test the connection::

    salt '####minion.fqdn####' test.ping


Start
-----

::

  /etc/init.d/salt-master start
  /etc/init.d/salt-minion start



Stop
----

::

  /etc/init.d/salt-master stop
  /etc/init.d/salt-minion stop



Disable
-------

Using the default upstart way::

  sh -c "echo 'manual' > /etc/init/salt-master.override"
  sh -c "echo 'manual' > /etc/init/salt-minion.override"



Enable
------

::

  sudo rm /etc/init/salt-master.override
  sudo rm /etc/init/salt-minion.override



Responsible
-----------

Alexander Werner <alex@documentfoundation.org>
