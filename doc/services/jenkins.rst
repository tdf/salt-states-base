
.. index:: pair: service; jenkins
.. index:: url; ci.libreoffice.org
.. index:: Countinuous Integration

:: _jenkins_service:

Jenkins
=======

  Jenkins is used to publish build logs.

Installation
------------

* to install prerequisites of jenkins

  .. code-block:: bash

    apt-get -y install openjdk-7-jdk openjdk-7-jre-headless

* to install Jenkins

  New File :file:`/etc/apt/sources.list.d/jenkins.list` with content:

  .. code-block:: sourceslist

    deb http://pkg.jenkins-ci.org/debian binary/

  To use this repository first add the key to your system::

    wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

  Update your local package index, then install Jenkins::

    sudo apt-get update
    sudo apt-get install jenkins

* DNS-Settings

    Set up a DNS-Alias ci.libreoffice.org to the Host running gerrit

* Configure Firewall Rule::

    ufw allow in 29418/tcp

* Change the config files::

    # Replace default HTTP_PORT 8080 port to 7080
    sed -i s/HTTP_PORT=8080/HTTP_PORT=7080/g /etc/default/jenkins

* Create an Apache Virtual Host pointing to gerrit installation:

  .. code-block:: apache

    <VirtualHost *:80>
      ServerName ci.libreoffice.org
      CustomLog /var/log/apache2/ci.libreoffice.org.log vhost_combined
      RewriteEngine on
      RewriteRule ^(.*) https://ci.libreoffice.org$1 [NE,L]
    </VirtualHost>

    <VirtualHost *:443>
      ServerName ci.libreoffice.org
      SSLEngine On
      SSLCertificateFile /etc/ssl/certs/libreoffice.crt
      SSLCertificateKeyFile /etc/ssl/private/libreoffice.key
      SSLCertificateChainFile /etc/ssl/certs/libreoffice.chain
      CustomLog /var/log/apache2/ci.libreoffice.org.log vhost_combined

      # Jenkins CI
      ProxyRequests On
      <Proxy *>
        Order deny,allow
        Allow from all
      </Proxy>
      ProxyPass / http://127.0.0.1:7080/
      ProxyPassReverse / http://127.0.0.1:7080/
    </VirtualHost>

    .. todo::

      State filename of jenkins vhost.

* Open Port 38844 (Used as jenkins ssh port)

  Jenkins itself opens port 38844 as ssh-port for connecting gerrit to jenkins

  To allow access to port 38844:

  .. code-block:: bash

    ufw allow in 38844/tcp

Start
-----

::

  sudo /etc/init.d/jenkins start



Stop
----

::

  sudo /etc/init.d/jenkins stop


Disable
-------

::

  sudo update-rc.d -f jenkins remove



Enable
------

::

  sudo update-rc.d jenkins defaults 99


Responsible
-----------

Thiebaud, Norbert <nthiebaud@gmail.com>
Michaelsen, Bjoern <bjoern.michaelsen@gmail.com>
Einsle, Robert <r.einsle@documentfoundation.org>
Ostrovsky, David <david@ostrovsky.org>

