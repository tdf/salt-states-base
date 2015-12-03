.. index:: pair: service; gerrit
.. index:: url; gerrit.libreoffice.org
.. index:: Code Review

.. _gerrit_service:

Gerrit
======

Gerrit is a tool for Developers to review the Source-Code.

Installation
------------

.. note::

  The Installation of gerrit is like the Description on gerrit site:

  https://gerrit-documentation.storage.googleapis.com/Documentation/2.8.1/install.html

* Download of the current Version of gerrit::

    http://gerrit-releases.storage.googleapis.com/index.html

* Creating a new User / Group running gerrit on it::

    addgroup --system gerrit
    adduser --system --ingroup gerrit --home /opt/gerrit gerrit

* Install Dependencies of gerrit::

    apt-get install postgresql
    su - postgres
    pwgen 12 1
    createuser --no-superuser --no-createdb --no-createrole -P -I gerrit
    createdb -O gerrit gerrit
    apt-get install openjdk-7-jre-headless


* become gerrit-User::

    su - gerrit -s /bin/bash

* Initialisation of gerrit::


    wget http://gerrit.googlecode.com/files/gerrit-full-<version>.war
    java -jar gerrit-full-<version>.war init -d gerrit_site

    *** Gerrit Code Review <version>
    ***

    Create '/opt/gerrit/gerrit_site' [Y/n]? Y

    *** Git Repositories
    ***

    Location of Git repositories   [git]:

    *** SQL Database
    ***

    Database server type           [POSTGRESQL/?]:
    Server hostname                [daten]:
    Server port                    [(POSTGRESQL default)]:
    Database name                  [gerrit_db]:
    Database username              [gerrit_user]:
    Change gerrit_users's password    [y/N]?

    *** User Authentication
    ***

    Authentication method          [OPENID/?]:

    *** Email Delivery
    ***

    SMTP server hostname           [localhost]:
    SMTP server port               [(default)]:
    SMTP encryption                [NONE/?]:
    SMTP username                  :

    *** Container Process
    ***

    Run as                         [gerrit]:
    Java runtime                   [/usr/lib/jvm/java-6-openjdk/jre]:
    Upgrade /opt/gerrit/gerrit_site/bin/gerrit.war [Y/n]?
    Copying gerrit.war to /opt/gerrit/gerrit_site/bin/gerrit.war

    *** SSH Daemon
    ***

    Listen on address              [*]: Listen on port                 [29418]:
    *** HTTP Daemon
    ***

    Behind reverse proxy           [Y/n]? Proxy uses SSL (https://)      [Y/n]?
    Subdirectory on proxy server   [/]:
    Listen on address              [127.0.0.1]:
    Listen on port                 [8081]:
    Canonical URL                  [https://gerrit.libreoffice.org/]:

    *** Plugins
    ***

    Prompt to install core plugins [y/N]? y
    Install plugin replication version 1.0 [y/N]? y

    Initialized /opt/gerrit/gerrit_site

* DNS-Settings

    Set up a DNS-Alias gerrit.domain to the Host running gerrit

* Symlink init-script::

    ln -s /opt/gerrit/gerrit_site/bin/gerrit.sh /etc/init.d/
    update-rc.d gerrit.sh defaults

* Create `/etc/default/gerritcodereview`::

    # Configuration variables.  These may be set in /etc/default/gerritcodereview.
    #
    # GERRIT_SITE
    #   Path of the Gerrit site to run.  $GERRIT_SITE/etc/gerrit.config
    #   will be used to configure the process.
    GERRIT_SITE=/opt/gerrit/gerrit_site/
    #
    # GERRIT_WAR
    #   Location of the gerrit.war download that we will execute.  Defaults to
    #   container.war property in $GERRIT_SITE/etc/gerrit.config.
    #
    # NO_START
    #   If set to "1" disables Gerrit from starting.
    #
    # START_STOP_DAEMON
    #   If set to "0" disables using start-stop-daemon.  This may need to
    #   be set on SuSE systems.


* Configure Firewall Rule::

    ufw allow in 29418/tcp

* Create an Apache Virtual Host pointing to gerrit installation:

    .. code-block:: apache

      <VirtualHost *:80>
        ServerName gerrit.libreoffice.org
        ServerAlias gerrit.documentfoundation.org
        CustomLog /var/log/apache2/gerrit.libreoffice.org.log vhost_combined
        RewriteEngine on
        RewriteRule ^(.*) https://gerrit.libreoffice.org$1 [NE,L]
      </VirtualHost>

      <VirtualHost *:443>
        RewriteEngine on
        RewriteCond %{HTTP_HOST} !^gerrit\.libreoffice\.org$ [NC]
        RewriteRule ^(.*)$ https://gerrit.libreoffice.org$1 [R=301,L]
        SSLEngine On
        SSLCertificateFile /etc/ssl/certs/libreoffice.crt
        SSLCertificateKeyFile /etc/ssl/private/libreoffice.key
        SSLCertificateChainFile /etc/ssl/certs/libreoffice.chain
        ServerName gerrit.libreoffice.org
        ServerAlias gerrit.documentfoundation.org
        CustomLog /var/log/apache2/gerrit.libreoffice.org.log vhost_combined
        ProxyRequests Off
        ProxyVia Off
        ProxyPreserveHost On
        <Proxy *>
          Order allow,deny
          Allow from all
        </Proxy>
        <Location />
          Order allow,deny
          Allow from all
        </Location>
        ProxyPass / http://127.0.0.1:8081/
        ProxyPassReverse / http://127.0.0.1:8081/
      </VirtualHost>

    .. todo::

      State filename of gerrit vhost.

* Install the :ref:`gerritbot` plugin
* Install the `svngit` plugin

Python Scripting
----------------
::
    sudo apt-get install python-bzutils


Gitweb
------

::

    sudo apt-get install highlight gitweb

    sudo emacs /etc/gitweb.conf
         # change $projectroot to /opt/gerrit/gerrit_site/git (or where-ever
         the gerrit_home + instance_dir + /git/ is)
         # Add Highlighting at the end
         $feature{'highlight'}{'default'} = [1];

Anongit
-------

::

    apt-get install git-daemon-run

edit /etc/sv/git-daemon-run to make it looks like::

    #!/bin/sh
    exec 2>&1
    echo 'git-daemon starting.'
    exec chpst -ugerrit \
    "$(git --exec-path)"/git-daemon --verbose --reuseaddr \
    --base-path=/opt/gerrit/gerrit_site/git /opt/gerrit/gerrit_site/git

    #note -ugerrit  => -u<gerrit user>
    #and
    #--base-path=<path to gerrit's git repo>   <path-to-gerrit-git-repo>

restart the service (the get-apt started it with a default path and user... it also set it up to be auto-start on boot)::

    sv restart gir-daemon

make sure it is running::

    ps -elf | grep git-daemon
    you should see the command line that is in the file above

If need be, the log of the service is in /var/log/git-daemon/current

open the port for git: ufw allow 9418/tcp

Upgrade
-------

* Stop gerrit::

    /etc/init.d/gerrit.sh stop

* Download the current gerrit version::

    cd /opt/gerrit/gerrit_site/bin/
    mv gerrit.war gerrit.war.old
    wget -O gerrit.war http://gerrit-releases.storage.googleapis.com/gerrit-2.8.6.1.war
    chown gerrit:gerrit gerrit.war

* Upgrade database::

    java -jar gerrit.war init --batch

* Start gerrit again::

    /etc/init.d/gerrit.sh start

Start
-----

::

  sudo /etc/init.d/gerrit.sh start



Stop
----

::

  sudo /etc/init.d/gerrit.sh stop



Disable
-------

::

  sudo update-rc.d -f gerrit.sh remove



Enable
------

::

  sudo update-rc.d gerrit.sh defaults 99



Responsible
-----------

Thiebaud, Norbert <nthiebaud@gmail.com>
Michaelsen, Björn <bjoern.michaelsen@gmail.com>
Einsle, Robert <r.einsle@documentfoundation.org>
Holesovsky, Jan  <kendy@suse.cz>
