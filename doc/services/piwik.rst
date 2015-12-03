Piwik
=====

Piwik is a php based webanalytics package that is used to track the websites
run by The Document Foundation

Requirements
------------

1) **Webserver** (currently using apache, but switching to nginx is trivial)
2) **Database** (using mysql currently, postgresql support still experimental)
3) **mod_php/php-fpm** or similar to run php via the webserver
4) php-opcode cacher like **xcache**
5) Open Port(s): 80 TCP, 443 TCP (standard **webserver ports**)

Installation
------------

* Create database user & database in mysql.
  Limiting the  max. simultaneous connections is optional, but recommended (db
  gets large, and thus backup takes long, so limiting the concurrent
  connectsion from the user avoids blocking mysql for other users during a
  mysqldump)::

    sudo mysql <<EOF
    CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
    CREATE DATABASE dbname;
    GRANT ALL PRIVILEGES ON dbname.* TO 'username'@'localhost' WITH MAX_USER_CONNECTIONS 240;
    EOF

* Configure webserver - details depend on webserver and method of running php
  that was chosen

  * redirect index.php to https vhost (for login to webfrontend)

* download current piwik release and extract into webroot, visit the vhost to
  do initial setup (create database table, create admin user)

* set piwik to use cronjob to update data instead of on-demand in the
  webinterface (Settings|General Settings) and add cronjob to system.
  use locking to prevent running into each other and optionally exclude time of
  mysqldump::

    cat > /etc/cron.d/piwik-archival <<EOF
    #  Archival process for piwik
    #
    # m h dom mon dow user  command
    # exlude the timeframes when backups are usually done
    34 0-3,7-23 * * * www-data flock -n /tmp/piwik-archival.log.lock -c 'php5 <webroot>/live/console core:archive --url=https://piwik.documentfoundation.org > /tmp/piwik-archival.log' || echo "piwik archival not done yet"
    EOF

Updating
--------

* update is offered in the webfrontend, have webfrontend install the new version
* in case of databasescheme update (the website update will prompt you whether
  this is needed or not)
  
  * disable tracking of changes (as it will exhaust mysql-connections
    otherwise, see limit above)::

      vim <webroot>/config/config.ini.php # set record_statistics = 0 
      [Tracker]
      record_statistics = 0

  * optionally also disable logging in to the webfrontend::

      vim <webroot>/config/config.ini.php # set maintenance_mode = 1 
      [General]
      maintenance_mode = 1

  * run the database update::

      php5 <webroot>/live/console core:update

  * enable tracking again after update is finished

Starting, Stopping, Disabling
-----------------------------

Starting/Stopping is done via the webserver.

To disable the site, use the method described in the updating section.

Adding sites that should be tracked
-----------------------------------

Create the page in piwik's webfrontend, then add the tracking code to the
footer of the site that should be tracked. (code that should be added to the
website is also displayed in the piwik frontend)

Responsible
-----------

cloph
