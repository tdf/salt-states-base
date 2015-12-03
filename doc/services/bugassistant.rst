Bugassistant (frontend to bugzilla)
===================================

.. sectionauthor:: Christian Lohmaier <cloph@documentfoundation.org>

The Bugzilla assistant (bugassistant) is a frontend to bugzilla that has a
step-by-step style frontend that guides the user into filing a hopefully useful
and complete bugreport. It is used via a transparent proxy to
bugs.freedesktop.org

Requirements
------------

The bugassistant needs 

* **XMLRPC::Lite** (package libsoap-lite-perl on Ubuntu)
* **HTML::Templates** (package libhtml-template-perl on Ubuntu)
* **xsltproc** (package xsltproc on Ubuntu) - http://xmlsoft.org/XSLT/xsltproc.html
* **tidy** (package tidy on Ubuntu) - http://tidy.sourceforge.net/
* **curl**, **git** and **make**


Installation
------------

Code is maintained in http://github.com/tdf/www-bugassistant along with description information in the wiki at https://wiki.documentfoundation.org/QA/Bugzilla/Components 

So just clone the repository, run make to create the files, then copy the files to the appropriate target location::

        git clone https://github.com/tdf/www-bugassistant.git
        cd www-bugassistant
        make
        # copy files around..

Cronjob to automate the update
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

        cat > /etc/cron.d/9999bugassistant  << EOF
        #  Bugassistant update script
        #
        # m h dom mon dow user  command
        #
        # update the unconfirmed bugs count
        0 0 * * * wsadmin perl $HOME/www-bugassistant/stats/unconfirmedBugsCount.pl > $HOME/www-bugassistant/bug/qateam/unconfirmedBugsCount.html
        5 0 * * * wsadmin perl $HOME/www-bugassistant/stats/generalStats.pl         > $HOME/www-bugassistant/bug/qateam/generalStats.html

        # refresh all of the bugassistant and sync all changes to webroot
        15 0 * * * wsadmin cd $HOME/www-bugassistant && git pull | grep -v "Already up-to-date" || make > /tmp/bugassistant-cron.log && ( rsync -a bug/* /var/www/sites/libreoffice.org/bugassistant/libreoffice/bug/ ; rsync -a bug/* /var/www/sites/newdesign.libreoffice.org/bugassistant/libreoffice/bug/ )
        EOF


Reverse Proxy to bugs.freedesktop.org
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: apache

        <VirtualHost *:443>
            ServerName          bugassistant.libreoffice.org
            DocumentRoot        /var/www/sites/bugassistant.libreoffice.org
 
            ProxyPass           /libreoffice !
            ProxyPass           / https://bugs.libreoffice.org/ retry=1
            ProxyPreserveHost   On
            SSLProxyEngine      On
 
            SSLEngine on
 
            SSLCertificateFile /etc/ssl/certs/libreoffice.org.crt
            SSLCertificateKeyFile /etc/ssl/private/libreoffice.org.key
            SSLCertificateChainFile /etc/ssl/certs/libreoffice.org.chain
 
            CustomLog /var/log/apache2/bugassistant.libreoffice.org.log vhost_combined
 
        </VirtualHost>

Redirect/Aliases for actual bugassistant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
.. code-block:: apache

       <VirtualHost *:443>
         ...
          Alias /bugassistant/ /var/www/sites/bugassistant.libreoffice.org/
          SSLProxyEngine      On
          # 
          # This location will be used by https://bugassistant.libreoffice.org/bug/bug.html
          # when included in an iframe in https://libreoffice.org/get-help/bug/ to obey the
          # same origin policy and be allowed to explore the DOM of an iframe containing
          # a bug submission form result.
          # 
          ProxyPass           /bugzilla/ https://bugs.libreoffice.org/ retry=1
          ProxyPreserveHost   On
          #
          # Bugzilla will redirect 
          #   https://libreoffice.org/bugzilla/bug_list.cgi 
          # to
          #   https://libreoffice.org/bug_list.cgi
          # when the user is logged in. To preserve the /bugzilla/ directory
          # the Location: header must be reworked, which is the purpose of
          # the ProxyPassReverse that follow. 
          # Note that bugzilla does *not* return a Location that is 
          #   https://bugs.libreoffice.org/bug_list.cgi
          # because it creates the Location: header using the hostname from 
          # which the request was originally made, i.e. libreoffice.org or
          # www.libreoffice.org. However, bugzilla has no way to know that the
          # original path of the request was prefixed with /bugzilla/ and it is
          # the responsibility of the reverse proxy to rewrite the location 
          # accordingly.
          #
          ProxyPassReverse   /bugzilla/ https://libreoffice.org/
          ProxyPassReverse   /bugzilla/ https://www.libreoffice.org/
          ...
        <VirtualHost *:80>
          ...
          #
          # Bug reporting is forced to https because bugzilla always uses https
          # Any attempt to access it from http would violate the same origin policy.
          #
          RewriteRule ^/get-help/bug/$ https://libreoffice.org/get-help/bug/ [R=301,L,NC]
          ...
