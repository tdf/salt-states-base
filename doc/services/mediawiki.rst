.. index:: pair: service; wiki
.. index:: url; wiki.documentfoundation.org


.. _mediawiki_service:

MediaWiki
=========

We do have 2,5 Mediawiki installations:
 * TDFWIKI (https://wiki.documentfoundation.org)
 * HELPWIKI (https://help.libreoffice.org)
 * help-api (https://help-api.libreoffice.org - only accessible when adding to hosts)

The TDFWIKI is a full-featured installation and has many extensions installed.

The HELPWIKI is a "half"-featured installation, has many sym-links to the TDFWIKI, and only a few extensions.

Help-API is "only a config file" so that the usage of the API is allowed. Every other file is a sym-link to HELPWIKI.


Installation
------------

Following prerequisites we do need
 * Ploticus (for Extension:EasyTimeline)
 * perl (for at least Extension:EasyTimeline)
 * texvc (for Extension:math)
 * more for Extension:math
 * graphviz (for Extension:Graphviz)
 * Exim4 or PostFix (for Extension:BounceHandler)

Installed Extensions
====================

We do have the following extensions installed at the moment:

TDFWIKI
-------

 * BounceHandler (installed, but not working atm)
 * CategoryTree (see at the bottom the cas - used)
 * CheckUser (used by dennis for identifying spammers (e.g. by same UserAgents))
 * Interwiki (candidate for being deinstalled again)
 * Add_HTML_Meta_and_Title (need for [[Design]] for google verification)
 * Cite (to be removed for 1.25, maybe instal then CiteThisPage)
 * EasyTimeline (used at e.g. [[Template:LibOReleaseLifecycle]])
 * Graphviz (used at e.g. [[Development/Build System]])
 * ImageMap (prerequisit for Graphiz)
 * MapSources (used for event and hackfest pages to integrate a OSM)
 * Math (used at e.g. [[Documentation/Color and Tone Adjustment]])
 * ParserFunctions (additional code stuff for extensions)
 * RSS (e.g. [[EasyHacks]] bugs listed inwiki)
 * SyntaxHighlight (very much used for development pages)
 * Widgets (Calendar in wiki, e.g. tdfwiki/EventsCalendar)
 * AbuseFilter (prevent spammer, most config onwiki, see [[Special:AbuseFilter]])
 * AntiBot (anti bot framework - is it used?)
 * AntiSpoof (prevent account creation with mixed-scripts)
 * ConfirmEdit (recaptcha extension for registation and first edits)
 * SpamBlacklist (prevent spammers, see [[MediaWiki:Spam-blacklist]])
 * TitleBlacklist (prevent spamers, see [[MediaWiki:Titleblacklist]])
 * CodeMirror (syntaxhighlight in text field)
 * Bugzilla (used at [[EasyHacks]], at the moment fork by colonelqubit)
 * Gadgets (needed for G+ Calendar)
 * LanguageSelector (see helpwiki)
 * OpenSearchXml (to be removed for 1.25)
 * PCR GUI Inserts (piwiki integration)
 * WikiEditor

HELPWIKI
--------

 * PCR GUI Inserts (piwik integration)
 * ParserFunctions (using for templates in functions)
 * SyntaxHighlight (in use for OOBAS macros, e.g. [[Basic/Reset_Statement_Runtime]])
 * LanguageSelector (switch languages from en to de, etc. depending on users browser language)
 * WikiEditor (good q - in use?)
 * WikihelpRedirect (Kendy's extension for redirecting to the correct version page)


Accessing Help-API
------------------
To access help-api.libreoffice.org simply add to your /etc/host


  .. code-block:: php
     176.9.154.106 help-api.libreoffice.org


Adding new extensions
---------------------
New extensions should be git cloned to :file:`/var/www/sites/wiki.documentfoundation.org/extensions/` (or if no git repository is available, then unpack it there and document it here)

The extension needs to be included in the :file:`./core/LocalSettings.php` by using require_once "$IP"/extensions/Name/Name.php";

Extensions which do need to load additional files (e.g. images for toolbars) have to be symlinked to :file:`/var/www/sites/wiki.documentfoundation.org/core/extensions/` - be careful there exists extensions which canot be symlinked (e.g. Bugzilla integration)


Upgrading
---------

* add to :file:`/var/www/sites/wiki.documentfoundation.org/core/LocalSettings.php` and :file:`/var/www/sites/help.libreoffice.org/core/LocalSettings.php`:

  .. code-block:: php

    $wgReadOnly = 'This wiki is currently being upgraded to a newer software version.';

* Update the core repository to the wanted tag::

    cd /var/www/sites/wiki.documentfoundation.org/core
    sudo su -s/bin/bash www-data
    git pull
    git checkout REL1_24
    git submodule update --init

.. todo::
 
  update this documentation here as there aren't any submodules any more :-(

* Update the internal extensions repository to the wanted tag::

    cd extensions
    git pull
    git checkout REL1_24
    git submodule update --init

* Update the external extensions repository to the wanted tag::

    cd ../../extensions
    git pull
    git checkout REL1_24
    git submodule update --init

* Update the skins to the wanted tag::

    cd /var/www/sites/wiki.documentfoundation.org/skins/Vector/
    git pull
    git checkout REL1_24

* adapt the file :file:`/var/www/sites/wiki.documentfoundation.org/extensions/Widgets/WidgetRenderer.php`::

    sed -i s/"\$IP\/extensions"/"\$IP2\/extensions"/g /var/www/sites/wiki.documentfoundation.org/extensions/Widgets/WidgetRenderer.php
    sed -i s/"global \$IP;"/"global \$IP2;"/g /var/www/sites/wiki.documentfoundation.org/extensions/Widgets/WidgetRenderer.php

* udpate the Math extension::

    cd /var/www/sites/wiki.documentfoundation.org/core/extensions/Math/math
    make

* Enable AntiBot::

    cp -R /var/www/sites/wiki.documentfoundation.org/extensions/AntiBot/available/ /var/www/sites/wiki.documentfoundation.org/extensions/AntiBot/active/

* Fix permissions::

    chown -R www-data: /var/www/sites/wiki.documentfoundation.org

* Run maintenance script::

    cd core
    php maintenance/update.php --nopurge --quick


    cd /var/www/sites/wiki.documentfoundation.org/core
    php maintenance/update.php --nopurge --quick --conf /var/www/sites/help.libreoffice.org/core/LocalSettings.php


* Comment out `$wgReadOnly` from :file:`/var/www/sites/wiki.documentfoundation.org/core/LocalSettings.php` and :file:`/var/www/sites/help.libreoffice.org/core/LocalSettings.php`


Skins
-----
Since Mediawiki 1.24 no standard skins are any longer distributed by the Wikimedia Foundation.

We have only one skin installed at the moment: skin "Vector" (also standard skin at Wikipedia).
It is installed at

* /var/www/sites/wiki.documentfoundation.org/skins/

and respectively symlinked for help and help-api

Extension
---------

Additional speciality notes about extensions can be found here:

* Syntaxhighligh_GeShi has to be on branch REL1_23 instead of REL1_24 as REL1_24 throughs errors (at least at Special:Version)
* Bugzilla-Integration, Math, CodeMirror and WikiEditor have hardcoded paths for .../core/extensions/.../images and thus are symlinked

Start/Stop/Enable/Disable
-------------------------

This is done via the webserver::

  /etc/init.d/apache2 start/stop


Responsible
-----------

Dennis Roczek <dennisroczek@gmail.com>