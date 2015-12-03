.. _silverstripe_service:

SilverStripe
============

SilverStripe is a php based Content Management System that is used to run the
libreoffice.org and documentfoundation.org websites.

Requirements
------------

1) **Webserver** (currently using apache, but switching to nginx is trivial)
2) **Database** (using mysql currently, postgresql support is available)
3) **mod_php/php-fpm** or similar to run php via the webserver
4) php-opcode cacher like **xcache**
5) Open Port(s): 80 TCP, 443 TCP (standard **webserver ports**)

Installation
------------

* Create database user & database in mysql::

    sudo mysql <<EOF
    CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
    CREATE DATABASE dbname;
    GRANT ALL PRIVILEGES ON dbname.* TO 'username'@'localhost';
    EOF

* Configure webserver - details depend on webserver and method of running php
  that was chosen

  * redirect non-existing URLs to silverstripe's main.php
  * directly hand out exsisting files
  * usual blocking of access to configuration files, etc.
  * use maintenance.php when it exists to put the site into maintenance mode

* import existing database to mysql, or if you want to start from scratch

  * clone https://github.com/silverstripe/silverstripe-installer into the
    webroot, visit site/index.php and follow the instructions::

      git clone https://github.com/silverstripe/silverstripe-installer /srv/http/silverstripe
      <visit sitename/index.php in your browser>

* clone https://github.com/tdf/cms-code into the webroot and
  https://github.com/tdf/cms-themes into webroot/themes & update the containing
  submodules::

    rm -r /srv/http/silverstripe
    git clone https://github.com/tdf/cms-code /srv/http/silverstripe
    rm -r /srv/http/silverstripe/themes
    git clone https://github.com/tdf/cms-themes /srv/http/silverstripe/themes
    cd /srv/http/silverstripe && git submodule update --init

* copy private configuration into place::

    cp _config.php /srv/http/silverstripe/mysite/_config.php

* run dev/build to update the database to the new types introduced in the
  custom-setup::

    /srv/http/silverstripe/sapphire/sake dev/build

* remove maintenance.php file that is included in the repo::

    rm /srv/http/silverstripe/sapphire/maintenance.php

Updating
--------

The code is managed on github, modulo a few local changes, so to update, the general approach is to do::

    cd /srv/http/silverstripe
    git stash save && git pull -r && git stash pop

Depending on the characteristics of the changes, you either need to run
dev/build as above (new php → changes to the DB needed) and/or flush all (new
template files) - to flush all append **?flush=all** to the URL

.. note::

  git stash save will restore the maintenance.php, i.e. put the page into
  maintenance mode during the update, this allows for a clean update, without
  the user getting weired errors because dev/build wasn't run or when there are
  merge conflicts that need to be cleaned up.

Translations - Syncing from/to pootle
-------------------------------------

Some strings from the automatically generated pages are managed in pootle, so translators have an easy time trasnlating. For the newdesign site, only one single file is relevant, namely *newdesign.po*

Silversripe however keeps its translations (and other configuration data) in yaml files, so conversion has to be performed to integrate it into the repository.

Conversion to yaml is a little tricky, as yaml supports a variety of different
ways to describe a string (esp. continuation of split lines), but
silverstripe's parser only supports the simple method. So to convert, you have
to run the strings to msgcat --no-wrap to make all strings single-line ones,
and then use the patched po2yaml tool from https://github.com/unho/yaml2po.git

Patched means: replacing 
        outfile.puts(tr.to_yaml)
by
        outfile.puts(tr.to_yaml(:line_width => -1))

to the po2yaml script. 

so first get newdesign-<lang>.po files from pootle (download the website project). 

converting to single-line translations is necessary for the po2yaml scripts to make use of the translations::

    for i in newdesign*po ; do msgcat --no-wrap $i > $(echo $i |sed -e 's#newdesign-##'); rm $i; done
    # then convert to yaml
    for i in *po; do po2yaml $i $(basename $i po)yml ; done
    # strip all files that don't contain translations (all consisting of only two lines)
    wc -l *yml |awk '/^\s+2\s/{print $2}' |xargs -r rm
    # move to mysite/lang, git add and commit
    mv *yml /path/to/mysite/lang/ ; cd /path/to/mysite/lang
    git add * yml
    # optionally check for consistency
    git commit -m "update translations"


to create update pot from yml, there's helper task in silverstripe that extacts translations (./framework/tasks/i18nTextCollectorTask.php) - although it creates the translation files per-module, and not a single one, so some manual tewaking is necessary (or since new strings aren't added en-masse usually): Just add them manually to the en-US.yml file.

conversion to pot for pootle then is done with the companion utility from the abovementioned repository (yaml2po) - for updating pootle itself with the newly created newdesign.pot, please refer to the pootle documentation.

Adding Users and Subsites
-------------------------
to facilitate adding new subsites and new members, custom "ModelAdmin"
components have been created that are accessible from the main subsite if you
have admin-privileges in silverstripe.

Adding a new subsite using the form/csv method will copy the content from the
main (en-US) site as a template to use for translation.

The Group admin provides an easier interface to adding people (as with default
way, you'd have to switch to the subsite where you want to add the people first)
In the group admin, you can just select the group/search for the  corresponding
project and add a member directly. Visit
https://www.libreoffice.org/admin/group_import/, select/open the group, add
the user and done. If you're adding a new user, make use of the
"forgot-password" funcitonality to have the system send a PW-Reset-Link to  the
new user.

Initially they were created to do mass-import from the old site, but that is no
use case aynmore (but of course can still be used to mass-add a bunch of
editors)

Starting, Stopping, Disabling
-----------------------------

Starting/Stopping is done via the webserver - to disable the site, you can
enable the maintenance mode by restoring the maintenance.php file::

    cd /srv/http/silverstripe
    git checkout -- maintenance.php

To enable again, just delete the maintenance.php file again.

.. todo::
  * add private configuration
  * detail administrative stuff like groups/permissions that are used for running
    the site

Responsible
-----------

cloph
