
.. index:: pair: service; voting

Voting
======

TDF deploys a clone of the GNOME Foundation voting system, for all
kinds of member decision making.

Installation
------------

* Setup a subsite for voting::

    See somewhere else. Subsite needs to have php enabled.

* Clone voting repo::

    git clone git://gerrit.libreoffice.org/voting

* Set document root::

    Should point to voting/vote subdirectory of the git repo you've just cloned

* Setup database tables::

    according to voting/vote/include/schema.sql
    Additional info for setting up an actual election can be found in voting/bin/create-tmp-tokens.pl

* Local php setup::

    Create a voting/vote/include/localconfig.php for your install, content along these lines

    <?php
      $mysql_host = "localhost";
      $mysql_user = "web";
      $mysql_password = "whatever";
      $mysql_db = "elections";
    ?>

Responsible
-----------

Thorsten Behrens <thb@documentfoundation.org>
Florian Effenberger <floeff@documentfoundation.org>
